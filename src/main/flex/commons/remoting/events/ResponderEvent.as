package commons.remoting.events
{
   import flash.events.Event;

   import mx.rpc.IResponder;

   public class ResponderEvent extends Event
   {
      private var _responder:IResponder;

      public function get responder():IResponder
      {
         return _responder;
      }

      public function ResponderEvent(type:String, responder:IResponder, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
         _responder = responder;
      }
   }
}

