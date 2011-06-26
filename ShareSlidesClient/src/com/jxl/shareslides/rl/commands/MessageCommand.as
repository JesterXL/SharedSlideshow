package com.jxl.shareslides.rl.commands
{
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class MessageCommand extends Command
	{
		[Inject]
		public var event:NetworkModelEvent;
		
		public function MessageCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			/*
			if(event.message.data && event.message.data.message == "setCurrentSlide")
			{
				if(syncCheckBox.selected)
				{
					currentSlide = event.message.data.currentSlide;
					this.updateCurrentSlideBytes();
				}
				
				lastHostSlide = event.message.data.currentSlide;
			}
			else if(event.message.data && event.message.data.message == "doYouNeedSlideshow")
			{
				if(event.message.client && event.message.client.isLocal)
					return;
				
				if(containsSlideshow(event.message.data.slideshowName) == false)
				{
					channel.sendMessageToClient({message: "doYouNeedSlideshowAck", request: true}, event.message.client.groupID);
				}
			}
			*/
		}
	}
}