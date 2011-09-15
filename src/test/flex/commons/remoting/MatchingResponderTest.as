package commons.remoting
{
	import flash.events.EventDispatcher;

	import mx.messaging.errors.ChannelError;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.hamcrest.Matcher;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.hamcrest.object.instanceOf;

	public class MatchingResponderTest
	{
		private var fixture:MatchingResponder;

		private var dispatcher:EventDispatcher;

		[Before]
		public function setUp():void
		{
			fixture = new MatchingResponder();
			dispatcher = new EventDispatcher();
		}

		[Test(async)]
		public function testFaultHandlerCalledOnMatchingFaultEvent():void
		{
			Async.proceedOnEvent(this, dispatcher, FaultEvent.FAULT);

			var handler:Function = function(faultEvent:FaultEvent):void
			{
				dispatcher.dispatchEvent(faultEvent);
			};

			var fault:Fault = new Fault("500", "Test", "Test Error");
			fault.rootCause = new Error();

			fixture.addFaultHandler(hasPropertyWithValue("fault", hasPropertyWithValue("rootCause", instanceOf(Error))), handler);
			fixture.fault(FaultEvent.createEvent(fault));
		}

		[Test(async)]
		public function testFaultHandlerNotCalledOnNonMatchingFaultEvent():void
		{
			Async.failOnEvent(this, dispatcher, FaultEvent.FAULT);

			var handler:Function = function(faultEvent:FaultEvent):void
			{
				dispatcher.dispatchEvent(faultEvent);
			};

			var fault:Fault = new Fault("500", "Test", "Test Error");
			fault.rootCause = new Error();

			fixture.addFaultHandler(hasPropertyWithValue("fault", hasPropertyWithValue("rootCause", instanceOf(ChannelError))), handler);
			fixture.fault(FaultEvent.createEvent(fault));
		}

		[Test(async)]
		public function testFaultHandlerNotCalledOnResultEvent():void
		{
			Async.failOnEvent(this, dispatcher, FaultEvent.FAULT);

			var handler:Function = function(faultEvent:FaultEvent):void
			{
				dispatcher.dispatchEvent(faultEvent);
			};

			var result:Object = {message:"Hello World"};

			fixture.addFaultHandler(hasPropertyWithValue("fault", hasPropertyWithValue("rootCause", instanceOf(Error))), handler);
			fixture.result(ResultEvent.createEvent(result));
		}

		[Test(async)]
		public function testFaultHandlerNotCalledWhenRemoved():void
		{
			Async.failOnEvent(this, dispatcher, FaultEvent.FAULT);

			var handler:Function = function(faultEvent:FaultEvent):void
			{
				dispatcher.dispatchEvent(faultEvent);
			};

			var fault:Fault = new Fault("500", "Test", "Test Error");
			fault.rootCause = new Error();

			var faultMatcher:Matcher = anything();
			fixture.addFaultHandler(faultMatcher, handler);
			fixture.removeFaultHandler(faultMatcher, handler);
			fixture.fault(FaultEvent.createEvent(fault));
		}

		[Test(async)]
		public function testResultHandlerCalledOnMatchingResultEvent():void
		{
			Async.proceedOnEvent(this, dispatcher, ResultEvent.RESULT);

			var handler:Function = function(resultEvent:ResultEvent):void
			{
				dispatcher.dispatchEvent(resultEvent);
			};

			var result:Object = {message:"Hello World"};

			fixture.addResultHandler(hasPropertyWithValue("result", hasPropertyWithValue("message", "Hello World")), handler);
			fixture.result(ResultEvent.createEvent(result));
		}

		[Test(async)]
		public function testResultHandlerNotCalledOnNonMatchingResultEvent():void
		{
			Async.failOnEvent(this, dispatcher, ResultEvent.RESULT);

			var handler:Function = function(resultEvent:ResultEvent):void
			{
				dispatcher.dispatchEvent(resultEvent);
			};

			var result:Object = {message:"Hello World"};

			fixture.addResultHandler(hasPropertyWithValue("result", hasPropertyWithValue("message", "Hello Earth")), handler);
			fixture.result(ResultEvent.createEvent(result));
		}

		[Test(async)]
		public function testResultHandlerNotCalledOnFaultEvent():void
		{
			Async.failOnEvent(this, dispatcher, ResultEvent.RESULT);

			var handler:Function = function(resultEvent:ResultEvent):void
			{
				dispatcher.dispatchEvent(resultEvent);
			};

			var fault:Fault = new Fault("500", "Test", "Test Error");
			fault.rootCause = new Error();

			fixture.addResultHandler(hasPropertyWithValue("result", hasPropertyWithValue("message", "Hello World")), handler);
			fixture.fault(FaultEvent.createEvent(fault));
		}

		[Test(async)]
		public function testResultHandlerNotCalledWhenRemoved():void
		{
			Async.failOnEvent(this, dispatcher, ResultEvent.RESULT);

			var handler:Function = function(resultEvent:ResultEvent):void
			{
				dispatcher.dispatchEvent(resultEvent);
			};

			var result:Object = {message:"Hello World"};

			var resultMatcher:Matcher = anything();
			fixture.addResultHandler(resultMatcher, handler);
			fixture.removeResultHandler(resultMatcher, handler);
			fixture.result(ResultEvent.createEvent(result));
		}
	}
}

