package commons.remoting
{
	import mx.rpc.IResponder;

	import org.hamcrest.Matcher;

	public class MatchingResponder implements IResponder
	{
		private var resultHandlers:Array;
		private var faultHandlers:Array;

		public function MatchingResponder()
		{
			super();
			resultHandlers = [];
			faultHandlers = [];
		}

		public function addResultHandler(matcher:Matcher, handler:Function):void
		{
			resultHandlers.push(new MatcherHandler(matcher, handler));
		}

		public function removeResultHandler(matcher:Matcher, handler:Function):void
		{
			var matcherHandlerTemplate:MatcherHandler = new MatcherHandler(matcher, handler);
			removeHandler(resultHandlers, matcherHandlerTemplate);
		}

		public function addFaultHandler(matcher:Matcher, handler:Function):void
		{
			faultHandlers.push(new MatcherHandler(matcher, handler));
		}

		public function removeFaultHandler(matcher:Matcher, handler:Function):void
		{
			var matcherHandlerTemplate:MatcherHandler = new MatcherHandler(matcher, handler);
			removeHandler(faultHandlers, matcherHandlerTemplate);
		}

		public function result(data:Object):void
		{
			invokeHandlers(resultHandlers, data);
		}

		public function fault(info:Object):void
		{
			invokeHandlers(faultHandlers, info);
		}

		private function invokeHandlers(handlers:Array, data:Object):void
		{
			for each (var matcherHandler:MatcherHandler in handlers)
			{
				if (matcherHandler.matcher.matches(data))
				{
					matcherHandler.handler(data);
				}
			}
		}

		private function removeHandler(handlers:Array, matcherHandlerTemplate:MatcherHandler):void
		{
			for (var index:uint = 0; index < handlers.length; index++)
			{
				var currentMatcherHandler:MatcherHandler = handlers[index];
				if (currentMatcherHandler.equals(matcherHandlerTemplate))
				{
					handlers.splice(index, 1);
					break;
				}
			}
		}
	}
}

import org.as3commons.lang.IEquals;
import org.hamcrest.Matcher;

class MatcherHandler implements IEquals
{
	private var _matcher:Matcher;

	public function get matcher():Matcher
	{
		return _matcher;
	}

	private var _handler:Function;

	public function get handler():Function
	{
		return _handler;
	}

	public function MatcherHandler(matcher:Matcher, handler:Function)
	{
		super();
		_matcher = matcher;
		_handler = handler;
	}

	public function equals(object:Object):Boolean
	{
		var matcherHandler:MatcherHandler = object as MatcherHandler;
		var matcherHandlersEqual:Boolean = false;

		if (matcherHandler)
		{
			var matchersEqual:Boolean = _matcher != null && matcherHandler._matcher != null && _matcher === matcherHandler._matcher;
			var handlersEqual:Boolean = _handler != null && matcherHandler._handler != null && _handler === matcherHandler._handler;
			matcherHandlersEqual = matchersEqual && handlersEqual;
		}

		return matcherHandlersEqual;
	}
}

