package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.controller.SetNameEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.TransferModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class SetNameCommand extends Command
	{
		[Inject]
		public var event:SetNameEvent;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		[Inject]
		public var transferModel:TransferModel;
		
		public function SetNameCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("SetNameCommand::execute");
			var oldName:String = networkModel.localNetworkDiscovery.clientName;
			networkModel.localNetworkDiscovery.clientName = event.name;
			transferModel.localNetworkDiscovery.clientName = event.name;
			if(oldName != event.name)
			{
				Debug.log("\tdispatching name changed");
				var evt:SetNameEvent = new SetNameEvent(SetNameEvent.NAME_CHANGED);
				evt.name = event.name;
				dispatch(evt);
			}
		}
	}
}