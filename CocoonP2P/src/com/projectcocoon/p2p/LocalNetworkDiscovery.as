/*
* Copyright 2011 (c) Peter Elst, project-cocoon.com.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.projectcocoon.p2p
{
	
	import com.projectcocoon.p2p.command.CommandList;
	import com.projectcocoon.p2p.command.CommandType;
	import com.projectcocoon.p2p.events.AccelerationEvent;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	import com.projectcocoon.p2p.managers.GroupManager;
	import com.projectcocoon.p2p.managers.ObjectManager;
	import com.projectcocoon.p2p.util.ClassRegistry;
	import com.projectcocoon.p2p.vo.AccelerationVO;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.sensors.Accelerometer;
	
	import mx.collections.ArrayCollection;
	import mx.core.IMXMLObject;

	
	[Event(name="groupConnected", type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="groupClosed", type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="clientAdded", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientAdded", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientUpdate", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientRemoved", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="dataReceived", type="com.projectcocoon.p2p.events.MessageEvent")]
	[Event(name="accelerometerUpdate", type="com.projectcocoon.p2p.events.AccelerationEvent")]
	[Event(name="objectAnnounced", type="com.projectcocoon.p2p.events.ObjectEvent")]
	[Event(name="objectProgress", type="com.projectcocoon.p2p.events.ObjectEvent")]
	[Event(name="objectComplete", type="com.projectcocoon.p2p.events.ObjectEvent")]
	public class LocalNetworkDiscovery extends EventDispatcher implements IMXMLObject
	{
		/**
		 * URL for LAN connectivity
		 */
		private static const RTMFP_LOCAL:String = "rtmfp:";
		
		/**
		 * URL for peer discovery through Adobe's Cirrus service
		 * @see http://labs.adobe.com/technologies/cirrus/
		 */ 
		private static const RTMFP_CIRRUS:String = "rtmfp://p2p.rtmfp.net";
	
		private var _clientName:String;
		private var _groupName:String = "com.projectcocoon.p2p.default";
		private var _autoConnect:Boolean = true;
		private var _nc:NetConnection;
		private var _group:NetGroup;
		private var _groupSpec:GroupSpecifier;
		private var _groupManager:GroupManager;
		private var _objectManager:ObjectManager;
		private var _localClient:ClientVO;
		private var _clients:ArrayCollection = new ArrayCollection();
		private var _sharedObjects:ArrayCollection;
		private var _receivedObjects:ArrayCollection;
		private var _url:String = RTMFP_LOCAL;
		private var _key:String;
		private var _useCirrus:Boolean;
		private var _multicastAddress:String = "225.225.0.1:30303";
		private var _receiveLocal:Boolean;
		private var _acc:Accelerometer;
		private var _accelerometerInterval:uint = 0;
		
		// ========================== //
			
		public function LocalNetworkDiscovery()
		{
			registerClasses();
		}
		
		public function initialized(document:Object, id:String):void
		{
			if (autoConnect)
				connect();
		}
		
		/**
		 * Connects to the p2p network 
		 */		
		public function connect():void
		{
			close();
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			if (_url == RTMFP_CIRRUS)
			{
				if (!key || key.length == 0)
					throw new Error("To use Cirrus, you have to set your developer key")
				_nc.connect(RTMFP_CIRRUS, key);
			}
			else
			{
				_nc.connect(_url);
			}
		}
		
		public function close():void
		{
			cleanup();
		}
		
		/**
		 * Sends an arbitrary message (object, primitive, etc.) to a specific peer in the p2p network 
		 * @param value the message to send. Can be any type.
		 * @param groupID the group address of the peer (usually ClientVO.groupID)
		 */		
		public function sendMessageToClient(value:Object, groupID:String):void
		{
			var msg:MessageVO = _groupManager.sendMessageToGroupAddress(value, _group, groupID);
			if(loopback) 
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg));
		}
		
		/**
		 * Sends an arbitrary message (object, primitive, etc.) to all peers in the p2p network 
		 * @param value the message to send. Can be any type.
		 */
		public function sendMessageToAll(value:Object):void
		{
			var msg:MessageVO = _groupManager.sendMessageToAll(value, _group);
			if(loopback) 
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg));
		}
		
		/**
		 * Shares an arbitrary object (any type: object, primitive, etc.) with a specific peer in the p2p network.
		 * The peer will receive an ObjectEvent.OBJECT_ANNOUNCED event. To request the annonced object,
		 * the peer has to call requestObject()
		 * @param value the object to share. Can be any type.
		 */
		public function shareWithClient(value:Object, groupID:String, metadata:Object = null):void
		{
			share(value, groupID, metadata);
		}
		
		/**
		 * Shares an arbitrary object (any type: object, primitive, etc.) with all peers in the p2p network.
		 * The peer will receive an ObjectEvent.OBJECT_ANNOUNCED event. To request the annonced object,
		 * the peer has to call requestObject()
		 * @param value the object to share. Can be any type.
		 */
		public function shareWithAll(value:Object, metadata:Object = null):void
		{
			share(value, null, metadata);
		}
		
		/**
		 * Requests a shared object. Once requested, the object will be replicated.
		 * During replication, ObjectEvent.OBJECT_PROGRESS events get dispatched.
		 * When the object replication is finished, an ObjectEvent.OBJECT_COMPLETE event gets dispatched
		 * @param metadata the metadata of the requested object
		 * 
		 */		
		public function requestObject(metadata:ObjectMetadataVO):void
		{
			var msg:MessageVO = getObjectManager().request(metadata);
			if (msg)
				receivedObjects.addItem(msg.data);
		}
		
		// ========================== //
		
		/**
		 * Number of connected clients
		 */
		[Bindable(event="clientsConnectedChange")]
		public function get clientsConnected():uint
		{
			if (_groupManager && _group)
				return _groupManager.getClients(_group).length;
			return 0;
		}
		
		/**
		 * ArrayCollection filled with ClientVO objects representing all clients
		 */
		[Bindable(event="clientsChange")]
		public function get clients():ArrayCollection
		{
			return _clients;
		}
		
		/**
		 * ArrayCollection filled with ObjectMetadataVO objects representing all objects shared by the local client
		 */		
		[Bindable(event="sharedObjectsChange")]
		public function get sharedObjects():ArrayCollection
		{
			if (!_sharedObjects)
			{
				_sharedObjects = new ArrayCollection();
				dispatchEvent(new Event("sharedObjectsChange"));
			}
			return _sharedObjects;
		}
		
		/**
		 * ArrayCollection filled with ObjectMetadataVO objects representing all objects received by this client
		 */		
		[Bindable(event="receivedObjectsChange")]
		public function get receivedObjects():ArrayCollection
		{
			if (!_receivedObjects)
			{
				_receivedObjects = new ArrayCollection();
				dispatchEvent(new Event("receivedObjectsChange"));
			}
			return _receivedObjects;
		}
		
		/**
		 * When true, the connection will get created automatically after initialization<p/>
		 * Defaults to true
		 * @default true
		 */
		public function get autoConnect():Boolean
		{
			return _autoConnect;
		}
		public function set autoConnect(value:Boolean):void
		{
			_autoConnect = value;
		}
		
		/**
		 * The name of the local client as it will appear in the list of clients
		 */
		public function get clientName():String
		{
			return _clientName;
		}
		public function set clientName(val:String):void
		{
			_clientName = val;
			if(_localClient) 
			{
				_localClient.clientName = val;
				announceName();
			}
		}		
		
		/**
		 * Specifies the name of the NetGroup where other peers will join in. <p/>
		 * <b>Note:</b> to avoid clashed with other applications, this should be something "unique",
		 * e.g. you should prefix the name with a reverse DNS name or something like that<p/>
		 * Defaults to com.projectcocoon.p2p.default
		 * @default com.projectcocoon.p2p.default
		 */
		public function get groupName():String
		{
			return _groupName;
		}
		public function set groupName(val:String):void
		{
			_groupName = val;
		}
		
		/**
		 * Specifies the local multicast address that will be used by all clients.<p/>
		 * Defaults to 225.225.0.1:30303
		 * @default 225.225.0.1:30303
		 */ 
		public function get multicastAddress():String
		{
			return _multicastAddress;
		}
		public function set multicastAddress(val:String):void
		{
			_multicastAddress = val;
		}
		
		/**
		 * When set to true, the local client will receive messages sent to other peers as well
		 * (helpful when building chat applications)<p/>
		 * Defaults to false
		 * @default false
		 */ 
		public function get loopback():Boolean
		{
			return _receiveLocal;
		}
		public function set loopback(bool:Boolean):void
		{
			_receiveLocal = bool;
		}
		
		/**
		 * Your Cirrus developer key, needed when using Cirrus
		 * @see http://labs.adobe.com/technologies/cirrus/
		 */ 
		public function get key():String
		{
			return _key;
		}
		public function set key(value:String):void
		{
			_key = value;
		}
		
		/**
		 * The RTMFP URL to connect to. 
		 * @default rtmfp:
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			_url = value;
		}
		
		/**
		 * When set to true, the connection will be made against the Cirrus peer introduction service
		 * which allows to connect to peers on different networks instead of using local peer discovery<p/>
		 * Defaults to false
		 * @default false
		 */
		public function get useCirrus():Boolean
		{
			return _useCirrus;
		}
		public function set useCirrus(value:Boolean):void
		{
			_useCirrus = value;
			if (_useCirrus)
				_url = RTMFP_CIRRUS;
		}

		/**
		 * Sets the desired time interval (in milliseconds) to use for reading updates from the Accelerometer
		 */
		public function get accelerometerInterval():uint
		{
			return _accelerometerInterval;	
		}
		public function set accelerometerInterval(val:uint):void
		{
			if (!Accelerometer.isSupported)
				return;
			
			_accelerometerInterval = val;
			
			if (_accelerometerInterval > 0) 
			{
				_acc = new Accelerometer();
				_acc.setRequestedUpdateInterval(accelerometerInterval);
				_acc.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			} 
			else if (_acc) 
			{
				_acc.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
				_acc = null;
			}
		}
		
		
		// ============= Private ============= //
		
		private function registerClasses():void
		{
			ClassRegistry.registerClasses();
		}
		
		private function cleanup():void
		{
			// do some cleanup
			if (_nc)
			{
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				if (_nc.connected)
					_nc.close();
				_nc = null;
			}
			
			if (_groupManager)
			{
				_groupManager.removeEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
				_groupManager.removeEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
				_groupManager.removeEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
				_groupManager.removeEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
				_groupManager.removeEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
				_groupManager.removeEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
				_groupManager.removeEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);
				_groupManager = null;
			}
			
			if (_objectManager)
			{
				_objectManager.removeEventListener(ObjectEvent.OBJECT_PROGRESS, onObjectProgress);
				_objectManager.removeEventListener(ObjectEvent.OBJECT_COMPLETE, onObjectComplete);
				_objectManager = null;
			}
			
			if (_acc)
			{
				_acc.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
				_acc = null;
			}
			
			if (_group)
				_group = null;
			
			if (_localClient)
				_localClient = null;
			
			if (_clients)
				_clients.removeAll();
			else
				_clients = new ArrayCollection();
			dispatchEvent(new Event("clientsChange"));		
		}
		
		private function setupGroup():void
		{
			
			// create and setup the GroupManager
			_groupManager = new GroupManager(_nc, multicastAddress);
			
			_groupManager.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			_groupManager.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			_groupManager.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			_groupManager.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
			_groupManager.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			_groupManager.addEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
			_groupManager.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);	
			
			// create the group
			_group = _groupManager.createNetGroup(groupName);
			
			// [jwarden 6.5.2011] bootstrapping in case someone arrives late, they'll get files
			getObjectManager();
		}

		private function setupClient():void
		{		
			// get the local ClientVO for reference
			_localClient = _groupManager.getLocalClient(_group);
			_localClient.clientName = getClientName();
		}
		
		private function getObjectManager():ObjectManager
		{
			if (!_objectManager)
			{
				_objectManager = new ObjectManager(_groupManager, _group);
				_objectManager.addEventListener(ObjectEvent.OBJECT_PROGRESS, onObjectProgress);
				_objectManager.addEventListener(ObjectEvent.OBJECT_COMPLETE, onObjectComplete);
			}
			return _objectManager;
		}

		private function getClientName():String
		{
			if(!_clientName) 
				_clientName = "";
			return _clientName;
		}
		
		private function announceName():void
		{
			// announce ourself to the other peers
			_groupManager.announceToGroup(_group);
		}
		
		private function share(value:Object, groupID:String, metadata:Object):void
		{
			var msg:MessageVO = getObjectManager().share(value, groupID, metadata);
			// [jwarden 7.16.2011] BUG: adds the item to the sharedObjects twice
			var len:int = sharedObjects.length;
			while(len--)
			{
				var message:MessageVO = sharedObjects.getItemAt(len) as MessageVO;
				if(message.sequenceId == msg.sequenceId)
					return;
			}
			sharedObjects.addItem(msg.data); // add the ObjectMetadataVO to the list of shared Objects
		}
		
		// ============= Event Handlers ============= //
		
		private function onNetStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code) 
			{
				case NetStatusCode.NETCONNECTION_CONNECT_SUCCESS:
					setupGroup();
					break;
			}
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			if (event.group == _group)
			{
				_localClient = _groupManager.getLocalClient(_group);
				_localClient.clientName = getClientName();
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			if (event.group == _group)
			{
				_clients.addItem(event.client);
				dispatchEvent(new Event("clientsConnectedChange"));
				announceName();
			}
			// distribute the event
			dispatchEvent(event);
		}
		
		private function onClientRemoved(event:ClientEvent):void
		{
			if (event.group == _group)
			{
				_clients.removeItemAt(_clients.getItemIndex(event.client));
				dispatchEvent(new Event("clientsConnectedChange"));
			}
			// distribute the event
			dispatchEvent(event);
		}
		
		private function onClientUpdate(event:ClientEvent):void
		{
			// distribute the event
			dispatchEvent(event);
		}
		
		private function onDataReceived(event:MessageEvent):void
		{
			if(event.group == _group && event.message.command == CommandList.ACCELEROMETER) 
			{
				var acc:AccelerationVO = event.message.data as AccelerationVO;
				dispatchEvent(new AccelerationEvent(AccelerationEvent.ACCELEROMETER, acc));
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onAccelerometer(evt:AccelerometerEvent):void
		{
			var acc:AccelerationVO = new AccelerationVO(_localClient, evt.accelerationX, evt.accelerationY, evt.accelerationZ, evt.timestamp);
			var msg:MessageVO = new MessageVO(_localClient, acc, null, CommandType.SERVICE, CommandList.ACCELEROMETER);
			if(loopback) 
				dispatchEvent(new AccelerationEvent(AccelerationEvent.ACCELEROMETER, acc));
			_group.post(msg);
		}

		private function onObjectAnnounced(event:ObjectEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());	
		}
		
		private function onObjectComplete(event:ObjectEvent):void
		{
			// distribute the event
			event.metadata.completedSignal.dispatch();
			dispatchEvent(event.clone());
		}
		
		private function onObjectProgress(event:ObjectEvent):void
		{
			// distribute the event
			event.metadata.progressSignal.dispatch();
			dispatchEvent(event.clone());
		}
		
	}
	
}