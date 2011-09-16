package commons.remoting
{
	import flash.utils.getQualifiedClassName;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.IResponder;
	import mx.utils.ArrayUtil;

	import org.as3commons.lang.ArrayUtils;

	[DefaultProperty("responders")]
	/**
	 * <p>
	 * This is a responder that aggregates other responders. This can be used to
	 * create reuseable responder implementations with a singular focus. For example,
	 * IResponders for logging, notifications, or other cross-cutting concerns can
	 * be implemented separately, then grouped together under an AggregateResponder.
	 * </p>
	 * <p>
	 * If any responder in the set of responders throws an error, it will be caught
	 * and logged using the mx.logging.ILogger framework. This allows all responders
	 * to receive the result or fault.
	 * </p>
	 *
	 * @author russellcentanni
	 */
	public class AggregateResponder implements IResponder
	{

		private static const logger:ILogger=Log.getLogger(getQualifiedClassName(AggregateResponder).
			replace("::", "."));

		[ArrayElementType("mx.rpc.IResponder")]
		[Bindable]
		public var responders:Array;

		public function AggregateResponder()
		{
			super();
			responders = [];
		}

		public function addResponder(responder:IResponder):void
		{
			responders.push(responder);
		}

		public function removeResponder(responder:IResponder):void
		{
			ArrayUtils.removeItem(responders, responder);
		}

		public function result(data:Object):void
		{
			if (responders)
			{
				for each (var responder:IResponder in responders)
				{
					try
					{
						if (Log.isInfo())
						{
							logger.info("Invoking responder.result {0} with data {1}", responder, data);
						}
						responder.result(data);
					}
					catch (e:Error)
					{
						// Log the error, but continue processing responders.
						if (Log.isError())
						{
							logger.error(e.message + "\n{0}", e.getStackTrace());
						}
					}
				}
			}
		}

		public function fault(info:Object):void
		{
			if (responders)
			{
				for each (var responder:IResponder in responders)
				{
					try
					{
						if (Log.isInfo())
						{
							logger.info("Invoking responder.fault {0} with data {1}", responder, info);
						}
						responder.fault(info);
					}
					catch (e:Error)
					{
						// Log the error, but continue processing responders.
						if (Log.isError())
						{
							logger.error(e.message + "\n{0}", e.getStackTrace());
						}
					}
				}
			}
		}
	}
}


