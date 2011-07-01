package com.jxl.shareslidesmobile.views.mainviews.startslideshowviews
{

	import com.bit101.components.Component;
	import com.jxl.minimalcomps.DraggableList;
	import com.jxl.shareslidesmobile.controls.Button;
	import com.jxl.shareslidesmobile.controls.HeaderBar;
	import com.jxl.shareslidesmobile.controls.HeaderField;
	import com.jxl.shareslidesmobile.controls.InputText;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.controls.ProgressIndicator;
	import com.jxl.shareslidesmobile.controls.SlideEditItemRenderer;
	import com.jxl.shareslidesmobile.controls.TextHeader;
	import com.jxl.shareslidesmobile.events.view.NewSlideshowViewEvent;
	import com.jxl.shareslidesmobile.events.view.SlideEditItemRendererEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;

	import flash.filesystem.File;
	import flash.filesystem.FileStream;

	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.system.Capabilities;

	import mx.collections.ArrayCollection;

	[Event(name="createSlideshow", type="com.jxl.shareslidesmobile.events.view.CreateSlideshowViewEvent")]
	[Event(name="cancel", type="com.jxl.shareslidesmobile.events.view.CreateSlideshowViewEvent")]
	public class NewSlideshowView extends Component
	{

		private static const STATE_BROWSE:String 			= "browse";
		private static const STATE_PROCESSING:String 		= "processing";

		private var cameraRoll:CameraRoll;
		private var file:File;
		private var files:Array;

		private var background:BackgroundSymbol;
		private var header:HeaderBar;
		private var headerField:HeaderField;
		private var cancelButton:Button;
		private var saveButton:Button;
		private var nameLabelField:LabelField;
		private var nameInputText:InputText;
		private var slidesLabelField:LabelField;
		private var browseButton:Button;
		private var browseFolderButton:Button;
		private var slidesTextHeader:TextHeader;
		private var slidesList:DraggableList;
		private var progress:ProgressIndicator;

		private var filesCollection:ArrayCollection;

		public function NewSlideshowView(parent:DisplayObjectContainer=null)
		{
			super(parent);
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 800;

			currentState = STATE_BROWSE;

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(event:Event):void
		{
			currentState = STATE_BROWSE;
			reset();
		}

		protected override function addChildren():void
		{
			super.addChildren();

			background = new BackgroundSymbol();
			addChild(background);

			header = new HeaderBar();
			addChild(header);

			headerField = new HeaderField(this, "New Slideshow");

			cancelButton = new Button(this, "Cancel", onCancel);

			saveButton = new Button(this, "Save", onSave);

			nameLabelField = new LabelField(this, "Name:");

			nameInputText = new InputText(this);

			slidesLabelField = new LabelField(this, "Slides:");

			browseButton = new Button(this, "Browse", onBrowse);

			if(Capabilities.version.toLowerCase().indexOf("and") != -1)
				browseFolderButton = new Button(this, "Browse Folder", onBrowseFolder);

			slidesTextHeader = new TextHeader(null, "Slides");

			slidesList = new DraggableList();
			slidesList.itemRenderer = SlideEditItemRenderer;
			slidesList.addEventListener(SlideEditItemRendererEvent.DELETE_SLIDE, onDeleteSlide);

		}

		protected override function commitProperties():void
		{
			super.commitProperties();

		}

		public override function draw():void
		{
			super.draw();

			background.width = width;
			background.height = height;

			header.width = width;

			headerField.x = (width / 2) - ((headerField.textWidth + 4) / 2);
			headerField.y = header.y + (header.height / 2) - ((headerField.textHeight + 4) / 2);

			cancelButton.x = 8;
			cancelButton.y = header.y + (header.height / 2) - (cancelButton.height / 2);

			saveButton.x = width - saveButton.width - 8;
			saveButton.y = cancelButton.y;

			nameLabelField.x = 8;
			nameLabelField.y = header.y + header.height + 8;

			nameInputText.x = nameLabelField.x;
			nameInputText.y = nameLabelField.y + nameLabelField.textHeight + 4 + 8;
			nameInputText.width = width * .8 - nameInputText.x;

			slidesLabelField.x = nameLabelField.x;
			slidesLabelField.y = nameInputText.y + nameInputText.height + 8;

			browseButton.x = slidesLabelField.x;
			browseButton.y = slidesLabelField.y + slidesLabelField.height + 8;

			if(browseFolderButton)
				browseFolderButton.move(browseButton.x + browseButton.width + 8, browseButton.y);

			slidesTextHeader.y = browseButton.y + browseButton.height + 8;
			slidesTextHeader.width = width;

			slidesList.y = slidesTextHeader.y + slidesTextHeader.height;
			slidesList.setSize(width,  height - slidesList.y);

			if(progress)
				progress.move((width / 2) - (progress.width / 2), (height / 2) - (progress.height / 2));
		}

		private function onDeleteSlide(event:SlideEditItemRendererEvent):void
		{
			if(filesCollection)
				filesCollection.removeItemAt(filesCollection.getItemIndex(event.file));
		}


		private function onBrowse(event:MouseEvent):void
		{
			if(CameraRoll.supportsBrowseForImage)
			{
				browseCamera();
			}
			else
			{
				browseFilesystem();
			}
		}

		private function onBrowseFolder(event:MouseEvent):void
		{
			browseCameraFolder();
		}

		private function removeCameraListeners():void
		{
			 if(cameraRoll)
			 {
				cameraRoll.removeEventListener(ErrorEvent.ERROR, onCameraRollError);
				cameraRoll.removeEventListener(MediaEvent.SELECT, onCameraRollSelect);
			 	cameraRoll.removeEventListener(MediaEvent.SELECT, onCameraRollSelectFolder);
			 }
		}

		private function browseCamera():void
		{
			removeCameraListeners();
			if(cameraRoll == null)
			{
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener(ErrorEvent.ERROR, onCameraRollError);
				cameraRoll.addEventListener(MediaEvent.SELECT, onCameraRollSelect);
			}

			cameraRoll.browseForImage();
		}

		private function browseCameraFolder():void
		{
			if(cameraRoll == null)
			{
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener(ErrorEvent.ERROR, onCameraRollError);
				cameraRoll.addEventListener(MediaEvent.SELECT, onCameraRollSelectFolder);
			}

			cameraRoll.browseForImage();
		}

		private function onCameraRollError(event:ErrorEvent):void
		{
			Debug.error("CreateSlideshowView::onCameraRollError: " + event.text);
		}

		private function onCameraRollSelect(event:MediaEvent):void
		{
			if(files == null)
				files = [];

			if(filesCollection == null)
				filesCollection = new ArrayCollection(files);

			var imagePromise:MediaPromise = event.data;

			filesCollection.addItem(imagePromise.file);

			slidesList.items = filesCollection;
		}

		private function onCameraRollSelectFolder(event:MediaEvent):void
		{
			var file:File = event.data.file;
			if(file.isDirectory == false)
				file = file.parent;
			files = file.getDirectoryListing();
			if(files && files.length > 0)
			{
				filesCollection = new ArrayCollection(files);
				slidesList.items = filesCollection;
			}
		}

		private function onImageFailed(event:IOErrorEvent):void
		{
			Debug.error("CreateSlideshowView::onImageFailed: " + event.text);
		}

		private function browseFilesystem():void
		{
			if(file == null)
			{
				file = new File();
				file.addEventListener(Event.CANCEL, onFileCancel);
				file.addEventListener(Event.SELECT, onFileSelect);
				file.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
			}

			try
			{
				file.browseForDirectory("Slides Folder");
			}
			catch(err:Error)
			{
				Debug.error("CreateSlideshowView::onBrowse, err: " + err);
				currentState = STATE_BROWSE;
			}
		}

		private function onFileError(event:IOErrorEvent):void
		{
			Debug.error("CreateSlideshowView::onFileError: " + event.text);
			currentState = STATE_BROWSE;
		}

		private function onFileCancel(event:Event):void
		{
			currentState = STATE_BROWSE;
		}

		private function onFileSelect(event:Event):void
		{
			files = file.getDirectoryListing();
			if(files && files.length > 0)
			{
				filesCollection = new ArrayCollection(files);
				slidesList.items = filesCollection;
			}
		}

		/*
		private function browseCamera():void
		{
			if(cameraRoll == null)
			{
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener(ErrorEvent.ERROR, 	onCameraRollError);
				cameraRoll.addEventListener(Event.CANCEL, 		onCameraRollCancel);
				cameraRoll.addEventListener(MediaEvent.SELECT, 	onCameraRollSelect);
			}
		}
		*/

		private function onSave(event:MouseEvent):void
		{
			currentState 							= STATE_PROCESSING;

			var evt:NewSlideshowViewEvent 			= new NewSlideshowViewEvent(NewSlideshowViewEvent.CREATE_SLIDESHOW);
			evt.name								= nameInputText.text;
			evt.files								= files;
			dispatchEvent(evt);
		}

		private function onCancel(event:MouseEvent):void
		{
			dispatchEvent(new NewSlideshowViewEvent(NewSlideshowViewEvent.CANCEL_CREATE_SLIDESHOW));
		}

		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_BROWSE:
					safeAddChildren(cancelButton, saveButton, nameLabelField, nameInputText, slidesLabelField, browseButton, browseFolderButton, slidesTextHeader, slidesList);
				break;

				case STATE_PROCESSING:
					if(progress == null)
					{
						progress = new ProgressIndicator(this);
						progress.label = "Creating Slideshow...";
					}

					if(progress.parent == null)
						addChild(progress);


				break;
			}
			draw();
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_BROWSE:
					safeRemoveChildren(cancelButton, saveButton, nameLabelField, nameInputText, slidesLabelField, browseButton, browseFolderButton, slidesTextHeader, slidesList);

				break;

				case STATE_PROCESSING:
					if(progress && progress.parent)
						removeChild(progress);

				break;


			}
		}



		private function reset():void
		{
			if(filesCollection)
				filesCollection.removeAll();

			if(files)
				files.length = 0;

			nameInputText.text = "";
		}
	}
}
