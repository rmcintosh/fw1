component extends="mxunit.framework.TestCase" {

    public void function setUp() {
        variables.fw = new framework.one();
        request._fw1.requestDefaultsInitialized = false;
        request.failureCount = 0;
        request.outputContent = "";
        injectMethod(variables.fw, this, "exceptionCapture", "dumpException");
    }

    /**
	* Test with initialised framework - ensure error handler tries to render the main.error view
	*/
    public void function testError()
    {
        var exception = {
            type = "Testing",
            message = "Testing",
            detail = "Detail"
        };
        var event = "Test Event";
        variables.fw.onApplicationStart();
        savecontent variable="output" {
            variables.fw.onError(exception, event);
        };
        assertEquals(request.action, ":main.error");
        assertFalse(output contains "Unable to find a view for ':main.error' action.");
        assertTrue(output contains "Unable to find a view for &##x27;&##x3a;main.error&##x27;");
    }

    /**
    * Test with un-initialised framework - ensure internal error is not as prominent
    */
    public void function testEarlyError()
    {
        var exception = {
            type = "Testing",
            message = "Testing",
            detail = "Detail"
        };
        var event = "";
        savecontent variable="output" {
	        variables.fw.onError(exception, event);
        }
        assertFalse(output CONTAINS "Element FRAMEWORK.USINGSUBSYSTEMS is undefined in VARIABLES", "Didn't expect failure in early exception");
        assertTrue(output CONTAINS "Exception occured before FW/1 was initialized", "Expected message about early exception");
    }

    private void function exceptionCapture( any exception)
    {
        request.capturedException = arguments.exception;
    }
}
