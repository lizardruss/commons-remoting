package commons.remoting
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	public class ConditionalResponder extends EventDispatcher implements IResponder
	{
		public var resultCondition:Function;

		public var faultCondition:Function;

		public function ConditionalResponder()
		{
			super();
		}

		public function result(data:Object):void
		{
			var resultEvent:ResultEvent = data as ResultEvent;
			if (resultEvent && resultCondition(resultEvent))
			{
				dispatchEvent(resultEvent);
			}
		}

		public function fault(info:Object):void
		{
			var faultEvent:FaultEvent = info as FaultEvent;
			if (faultEvent && faultCondition(faultEvent))
			{
				dispatchEvent(faultEvent);
			}
		}
	}
}

