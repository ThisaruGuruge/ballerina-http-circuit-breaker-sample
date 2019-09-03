import ballerina/http;
import ballerina/log;

http:RollingWindow http2RollingWindowConfig = {
    requestVolumeThreshold: 3,
	timeWindowInMillis: 20000,
	bucketSizeInMillis: 20000 // 5 Buckets
};

http:CircuitBreakerConfig http2CircuitBreakerConfig = {
    rollingWindow: rollingWindowConfig,
    resetTimeInMillis: 20000,
    failureThreshold: 0.3, // If more than 3 requests failed among 10 requests, circuit trips.
    statusCodes: [400, 401, 402, 403, 404, 500, 501, 502, 503]
};

http:ClientEndpointConfig http2ClientConfig = {
    circuitBreaker: circuitBreakerConfig,
    timeoutInMillis: 2000,
    httpVersion: "2.0"
};

http:Client http2WeatherClient = new("http://localhost:9090", clientConfig);

listener http:Listener http2CircuitBreakerListener = new(8081, {
    httpVersion: "2.0"
});

@http:ServiceConfig {
    basePath: "/"
}
service CallBackendHttp2Service on http2CircuitBreakerListener {
    @http:ResourceConfig {
        methods: ["GET"]
	}
    resource function getWeather(http:Caller caller, http:Request request) {
        log:printInfo("[HTTP/2 CircuitBreakerService] Request received from the client");
        var backendResponse = weatherClient->get("/getWeather");
        if (backendResponse is http:ClientError) {
            var result = caller->respond(backendResponse.toString());
            handleResult(result);
        } else {
            var result = caller->respond(backendResponse);
            handleResult(result);
        }
	}
}
