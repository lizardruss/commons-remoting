package commons.remoting.responder
{
    import flash.utils.getQualifiedClassName;

    //import mx.logging.ILogger;
    //import mx.logging.Log;
    import mx.rpc.IResponder;

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

        //private static const logger:ILogger = Log.getLogger(getQualifiedClassName(AggregateResponder).
        //                                                    replace("::", "."));

        [ArrayElementType("mx.rpc.IResponder")]
        public var responders:Array;

        public function AggregateResponder()
        {
            super();
        }

        public function result(data:Object):void
        {
            if (responders)
            {
                for each (var responder:IResponder in responders)
                {
                    try
                    {
                        responder.result(data);
                    }
                    catch (e:Error)
                    {
                        // Log the error, but continue processing responders.
                        //logger.error(e.message + "\n{0}", e.getStackTrace());
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
                        responder.fault(info);
                    }
                    catch (e:Error)
                    {
                        // Log the error, but continue processing responders.
                        //logger.error(e.message + "\n{0}", e.getStackTrace());
                    }
                }
            }
        }
    }
}