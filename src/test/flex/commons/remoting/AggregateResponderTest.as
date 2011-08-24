////////////////////////////////////////////////////////////////////////////////
//
//  T-MOBILE USA, Inc.  
//  Copyright (c) 2009-2010 T-Mobile USA, Inc.  
//  All Rights Reserved.  
//
////////////////////////////////////////////////////////////////////////////////

package commons.remoting.responder
{
	import mockolate.runner.MockolateRunner;
	MockolateRunner

	import mx.rpc.IResponder;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mockolate.mock;

	[RunWith("mockolate.runner.MockolateRunner")]
	public class AggregateResponderTest
	{
		private var fixture:AggregateResponder;

		[Mock]
		public var responder1:IResponder;

		[Mock]
		public var responder2:IResponder;

		[Before]
		public function setUp():void
		{
			fixture=new AggregateResponder();
			fixture.responders=[responder1, responder2];
		}

		[Test]
		public function testResult():void
		{
			mock(responder1).method("result").once();
			mock(responder2).method("result").once();

			var resultEvent:ResultEvent=ResultEvent.createEvent({success: true});
			fixture.result(resultEvent);
		}

		[Test]
		public function testResultResponderThrowsError():void
		{
			mock(responder1).method("result").once().throws(new Error("Responder exception."));
			mock(responder2).method("result").once();

			var resultEvent:ResultEvent=ResultEvent.createEvent({success: true});
			fixture.result(resultEvent);
		}

		[Test]
		public function testFault():void
		{
			mock(responder1).method("fault").once();
			mock(responder2).method("fault").once();

			var faultEvent:FaultEvent=FaultEvent.createEvent(new Fault("500", "Resource not found.", "Bad URL."));
			fixture.fault(faultEvent);
		}

		[Test]
		public function testFaultResponderThrowsError():void
		{
			mock(responder1).method("fault").once().throws(new Error("Responder exception."));
			mock(responder2).method("fault").once();

			var faultEvent:FaultEvent=FaultEvent.createEvent(new Fault("500", "Resource not found.", "Bad URL."));
			fixture.fault(faultEvent);
		}
	}
}


