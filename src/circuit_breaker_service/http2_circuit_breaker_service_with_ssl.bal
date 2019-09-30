import ballerina/filepath;
import ballerina/http;
import ballerina/log;

http:RollingWindow http2RollingWindowConfigSsl = {
    requestVolumeThreshold: 3,
	timeWindowInMillis: 10000,
	bucketSizeInMillis: 1000 // 10 Buckets, window slides by 1 second
};

http:CircuitBreakerConfig http2CircuitBreakerConfigSsl = {
    rollingWindow: http2RollingWindowConfigSsl,
    resetTimeInMillis: 10000,
    failureThreshold: 0.3, // If more than 3 requests failed among 10 requests, circuit trips.
    statusCodes: [400, 401, 402, 403, 404, 500, 501, 502, 503]
};

http:ClientSecureSocket secureSocketConfig = {
        keyStore: {
            path: "resources" + filepath:getPathSeparator() + "ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "resources" + filepath:getPathSeparator() + "ballerinaTruststore.p12",
            password: "ballerina"
        },
        protocol: {
            name: "TLSv1.2",
            versions: ["TLSv1.2","TLSv1.1"]
        },
        ciphers:["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
};

http:ClientConfiguration http2ClientConfigSsl = {
    circuitBreaker: http2CircuitBreakerConfigSsl,
    timeoutInMillis: 2000,
    httpVersion: "2.0",
    secureSocket: secureSocketConfig
};

http:Client http2WeatherClientSsl = new("https://localhost:9092", http2ClientConfigSsl);

listener http:Listener http2CircuitBreakerListenerSsl = new(8082, {
    httpVersion: "2.0",
    secureSocket: {
        keyStore: {
            path: "resources" + filepath:getPathSeparator() + "ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "resources" + filepath:getPathSeparator() + "ballerinaTruststore.p12",
            password: "ballerina"
        },
        protocol: {
            name: "TLSv1.2",
            versions: ["TLSv1.2","TLSv1.1"]
        },
        ciphers:["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
    }
});

@http:ServiceConfig {
    basePath: "/"
}
service CallBackendHttp2ServiceSsl on http2CircuitBreakerListenerSsl {
    @http:ResourceConfig {
        methods: ["GET"]
	}
    resource function getWeather(http:Caller caller, http:Request request) {
        log:printInfo("[HTTP/2 CircuitBreakerService] Request received from the client");
        var backendResponse = http2WeatherClientSsl->get("/getWeather");
        if (backendResponse is http:ClientError) {
            var result = caller->respond(backendResponse.toString());
            handleResult(result);
        } else {
            var result = caller->respond(backendResponse);
            handleResult(result);
        }
	}
}
