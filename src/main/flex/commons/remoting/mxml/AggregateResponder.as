package commons.remoting.mxml
{
   import commons.remoting.actionscript.AggregateResponder;

   import mx.rpc.IResponder;

   [DefaultProperty("responders")]
   /**
   * Extension of the actionscript AggregateResponse that is MXML friendly.
   */
   public class AggregateResponder extends commons.remoting.actionscript.AggregateResponder
   {
      public function set responders(value:Array):void
      {
         if (value !== super.responders)
         {
            for each (var oldResponder:IResponder in super.responders)
            {
               removeResponder(oldResponder);
            }

            if (value)
            {
               for each (var newResponder:IResponder in value)
               {
                  addResponder(newResponder);
               }
            }
         }
      }

      public function AggregateResponder()
      {
         super();
      }
   }
}

