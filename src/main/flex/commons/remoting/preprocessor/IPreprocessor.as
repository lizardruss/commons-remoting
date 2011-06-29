package commons.remoting.preprocessor
{
    import org.as3commons.reflect.Method;

    public interface IPreprocessor
    {
        function preprocess(method:Method, args:Array):void;
    }
}