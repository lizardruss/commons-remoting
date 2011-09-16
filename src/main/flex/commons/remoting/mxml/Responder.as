package commons.remoting.mxml
{
	import flash.events.EventDispatcher;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	public class Responder extends EventDispatcher implements IResponder
	{
		public function Responder()
		{
			super();
		}

		public function result(data:Object):void
		{
			var resultEvent:ResultEvent = data as ResultEvent;
			dispatchEvent(resultEvent);
		}

		public function fault(info:Object):void
		{
			var faultEvent:FaultEvent = info as FaultEvent;
			dispatchEvent(faultEvent);
		}
	}
}

