package com.jxl.shareslides.rl.mediators
{
	import com.jxl.shareslides.controls.ConnectionLight;
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.rl.models.NetworkModel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ConnectionLightMediator extends Mediator
	{
		[Inject]
		public var view:ConnectionLight;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		public function ConnectionLightMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			addContextListener(NetworkModelEvent.CONNECTED, updateConnection, NetworkModelEvent);
			addContextListener(NetworkModelEvent.DISCONNECTED, updateConnection, NetworkModelEvent);
			
			updateConnection();
		}
		
		private function updateConnection(event:NetworkModelEvent=null):void
		{
			view.showConnected(networkModel.connected);
		}
	}
}