package com.jxl.shareslides.vo
{
	import com.adobe.crypto.MD5;
	
	import flash.utils.ByteArray;
	
	import mx.utils.SHA256;

	[Bindable]
	public class SlideshowVO
	{
		public var name:String;
		public var slideBytes:Array = [];
		public var passcode:String;
		
		[Transient]
		public var slides:Array = [];
		
		[Transient]
		public var host:Boolean = false;

		[Transient]
		public var edit:Boolean = false;
		
		[Transient]
		public var hash:String;
		
		
		public function SlideshowVO()
		{
		}
		
		[Transient]
		public function hasPasscode():Boolean
		{
			if(passcode == null)
				return false;

			if(passcode.length < 1)
				return false;

			return true;
		}
		
		[Transient]
		public function updateHashIfNeeded():void
		{
			if(hash == null || hash == "")
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(this);
				//hash = SHA256.computeDigest(bytes);
				hash = MD5.hashBinary(bytes);
			}
		}

		/*
		public function decryptPasscode(userSubmittedKey:String):String
		{
			if(hasPasscode() == false)
				return null;

			var key:AESKey = new AESKey();
			var keyBits:ByteArray = genAESKeyBits();
			var status:uint = key.generateKeys(keyBits);
			if (status != AESErrors.OK)
			{
				Debug.error("testAES Key generation error : " + status.toString());
				return null;
			}

			var cipher:AES = new AES(false);
			var plaintext:ByteArray = new ByteArray();
			passcode.position = 0;
			var status:uint = cipher.decrypt(passcode, plaintext, key);
			if (status != AESErrors.OK)
			{
				Debug.error("testAES AES decrypt() failure : " + status.toString());
				return null;
			}
			else
			{
				return plaintext.readUTFBytes(plaintext.length);
			}
		}

		public function encryptPasscode(userSubmittedKey:String):Boolean
		{
			var key:AESKey = new AESKey();
			var keyBits:ByteArray = genAESKeyBits();
			var status:uint = key.generateKeys(keyBits);
			if (status != AESErrors.OK)
			{
				Debug.error("testAES Key generation error : " + status.toString());
				return false;
			}

			var plaintext:ByteArray = new ByteArray();
			plaintext.writeUTFBytes(userSubmittedKey);
			plaintext.position = 0;

			var cipher:AES = new AES(false);

			passcode = new ByteArray();
			status = cipher.encrypt(plaintext, passcode, key);
			if (status != AESErrors.OK)
			{
				Debug.error("testAES AES encrypt() failure : " + status.toString());
				passcode = null;
				return false;
			}
			else
			{
				return true;
			}
		}

		private function genAESKeyBits():ByteArray {
			var keyBits:ByteArray = new ByteArray();
			for (var i:uint = 0; i < 4; i++)
				keyBits.writeUnsignedInt(uint(Math.random() * 1000)) ;
			keyBits.position = 0;
			return keyBits;
		}
		*/
	}
}