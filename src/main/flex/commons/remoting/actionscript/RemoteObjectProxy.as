////////////////////////////////////////////////////////////////////////////////
//
//  T-MOBILE USA, Inc.  
//  Copyright (c) 2009-2010 T-Mobile USA, Inc.  
//  All Rights Reserved.  
//
////////////////////////////////////////////////////////////////////////////////

package commons.remoting.actionscript
{

   import commons.remoting.IPreprocessor;

   import flash.utils.flash_proxy;

   import mx.rpc.AsyncToken;
   import mx.rpc.IResponder;
   import mx.rpc.remoting.RemoteObject;

   import org.as3commons.lang.ArrayUtils;

   use namespace flash_proxy;

   public class RemoteObjectProxy extends RemoteObject
   {
      [ArrayElementType("commons.remoting.IPreprocessor")]
      private var _preprocessors:Array;

      public function get preprocessors():Array
      {
         return _preprocessors;
      }

      [ArrayElementType("mx.rpc.IResponder")]
      private var _responders:Array;

      public function get responders():Array
      {
         return _responders;
      }

      public function RemoteObjectProxy()
      {
         super();

         _preprocessors = [];
         _responders = [];
      }

      public function addPreprocessor(preprocessor:IPreprocessor):void
      {
         _preprocessors.push(preprocessor);
      }

      public function removePreprocessor(preprocessor:IPreprocessor):void
      {
         ArrayUtils.removeItem(_preprocessors, preprocessor);
      }

      public function addResponder(responder:IResponder):void
      {
         _responders.push(responder);

         if (responder is IPreprocessor)
         {
            // Add to the array of preprocessors.
            addPreprocessor(IPreprocessor(responder));
         }
      }

      public function removeResponder(responder:IResponder):void
      {
         ArrayUtils.removeItem(_responders, responder);

         if (responder is IPreprocessor)
         {
            // Remove from the array of preprocessors.
            removePreprocessor(IPreprocessor(responder));
         }
      }

      override flash_proxy function callProperty(name:*, ... parameters):*
      {
         // Pre-process the parameters for the method being called.
         if (_preprocessors)
         {
            for each (var preprocessor:IPreprocessor in _preprocessors)
            {
               preprocessor.preprocess(name as String, parameters);
            }
         }

         // Make the remote call.
         var token:AsyncToken=super.callProperty(name, parameters);

         // Add the responders.
         if (token && _responders)
         {
            var aggregateResponder:AggregateResponder = new AggregateResponder();
            for each (var responder:IResponder in _responders)
            {
               aggregateResponder.addResponder(responder);
            }
            token.addResponder(aggregateResponder);
         }
      }
   }
}


