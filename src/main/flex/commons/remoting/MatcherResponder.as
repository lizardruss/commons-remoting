package commons.remoting
{
	import org.hamcrest.Matcher;

	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	public class MatcherResponder extends ConditionalResponder
	{
		public var resultMatcher:Matcher;

		public var faultMatcher:Matcher;

		public function MatcherResponder()
		{
			super();
			resultCondition = resultMatches;
			faultCondition = faultMatchers;
		}

		private function resultMatches(data:Object):Boolean
		{
			return resultMatcher.matches(data);
		}

		private function faultMatchers(info:Object):Boolean
		{
			return faultMatcher.matches(info);
		}
	}
}

