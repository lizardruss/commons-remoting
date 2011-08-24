////////////////////////////////////////////////////////////////////////////////
//
//  T-MOBILE USA, Inc.  
//  Copyright (c) 2009-2010 T-Mobile USA, Inc.  
//  All Rights Reserved.  
//
////////////////////////////////////////////////////////////////////////////////

package commons.remoting
{

	import flash.utils.flash_proxy;

	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;

	use namespace flash_proxy;

	[DefaultProperty("responders")]
	public class RemoteObjectProxy extends RemoteObject
	{

		[Bindable]
		public var preprocessors:Array;

		[ArrayElementType("mx.rpc.IResponder")]
		[Bindable]
		public var responders:Array;

		public function RemoteObjectProxy()
		{
			super();
		}

		override flash_proxy function callProperty(name:*, ... parameters):*
		{
			// Pre-process the parameters for the method being called.
			if (preprocessors)
			{
				for each (var preprocessor:IPreprocessor in preprocessors)
				{
					preprocessor.preprocess(parameters);
				}
			}

			// Make the remote call.
			var token:AsyncToken=super.callProperty(name, parameters);

			// Add the responders.
			if (responders)
			{
				for each (var responder:IResponder in responders)
				{
					token.addResponder(responder);
				}
			}
		}
	}
}


