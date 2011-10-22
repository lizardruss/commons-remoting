package commons.remoting.mxml
{
   import commons.remoting.actionscript.RemoteObjectProxy;

   import mx.rpc.IResponder;

   [DefaultProperty("responders")]
   public class RemoteObjectProxy extends commons.remoting.actionscript.RemoteObjectProxy
   {
      public function set responders(value:Array):void
      {
         for each (var oldResponder:IResponder in super.responders)
         {
            removeResponder(oldResponder);
         }

         if (value)
         {
            for each (var newResponder:IResponder in super.responders)
            {
               addResponder(newResponder);
            }
         }
      }

      public function RemoteObjectProxy()
      {
         super();
      }
   }
}

