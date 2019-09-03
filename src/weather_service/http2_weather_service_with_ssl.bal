import ballerina/filepath;
import ballerina/http;
import ballerina/log;

http:ListenerSecureSocket secureSocketConfig = {
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

listener http:Listener http2WeatherListenerSsl = new(9092, {
    httpVersion: "2.0",
    secureSocket: secureSocketConfig
});

int http2CountSsl = 0;

@http:ServiceConfig {
    basePath: "/"
}
service Http2WeatherServiceSsl on http2WeatherListenerSsl {
    @http:ResourceConfig {
	    path: "getWeather"
	}
    resource function getWeather(http:Caller caller, http:Request req) {
        http:Response response = new;
        http2CountSsl += 1;
        if (http2CountSsl % 5 == 0) {
            log:printInfo("[HTTP/2 WeatherService] Trying to Send Temperature Response");
            string temperature = getTemperature().toString();
            response.setPayload(temperature);
            var result = caller->respond(response);
            handleResult(result);
        } else {
            log:printInfo("[HTTP/2 WeatherService] Trying to Send ERROR Response");
            response.statusCode = 501;
            response.setPayload("Internal error occurred.");
            var result = caller->respond(response);
            handleResult(result);
        }
    }
}
