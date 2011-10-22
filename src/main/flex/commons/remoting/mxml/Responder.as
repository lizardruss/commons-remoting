package commons.remoting.mxml
{
   import flash.events.EventDispatcher;

   import mx.rpc.IResponder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;

   /**
    * The result event is dispatched when a service call successfully returns.
    */
   [Event(name="result", type="mx.rpc.events.ResultEvent")]

   /**
    * The fault event is dispatched when a service call fails
    */
   [Event(name="fault", type="mx.rpc.events.FaultEvent")]

   /**
    * Responder implementation that allows inline handler definitions via MXML.
    */
   public class Responder extends EventDispatcher implements IResponder
   {
      public function Responder()
      {
         super();
      }

      /**
       * Result handler that re-dispatches the ResultEvent, so that
       * handlers can be defined via MXML.
       *
       * @param data the data returned by the remote service.
       */
      public function result(data:Object):void
      {
         var resultEvent:ResultEvent = data as ResultEvent;
         dispatchEvent(resultEvent);
      }

      /**
       * Fault handler that re-dispatches the FaultEvent, so that
       * handlers can be defined via MXML.
       *
       * @param info the info returned by the remote service.
       */
      public function fault(info:Object):void
      {
         var faultEvent:FaultEvent = info as FaultEvent;
         dispatchEvent(faultEvent);
      }
   }
}

