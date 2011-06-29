package commons.remoting.proxy
{
    import commons.remoting.preprocessor.IPreprocessor;

    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    import mx.rpc.AsyncToken;
    import mx.rpc.remoting.RemoteObject;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;

    use namespace flash_proxy;

    public class RemoteObjectProxy extends RemoteObject
    {

        [Bindable]
        public var preprocessors:Array;

        [Bindbale]
        public var responders:Array;

        public function RemoteObjectProxy()
        {
            super();
        }

        override flash_proxy function callProperty(name:*, ... parameters):*
        {
            // Pre-process the parameters for the method being called.
            var method:org.as3commons.reflect.Method = Type.forInstance(this).getMethod(name);
            if (method)
            {
                if (preprocessors)
                {
                    for each (var preprocessor:IPreprocessor in preprocessors)
                    {
                        preprocessor.preprocess(method, parameters);
                    }
                }
            }

            // Make the remote call.
            var token:AsyncToken = super.callProperty(name, parameters);

            // Add the responders.
            if (responders)
            {
                for each (var responder:IResponder in responders)
                {
                    token.addResponder(responder);
                }
            }
        }
    }
}