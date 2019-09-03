import ballerina/filepath;
import ballerina/http;

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
string http2ServicePrefixSsl = "[HTTP/2 WeatherService]";

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
        if (http2CountSsl < 5) {
            sendTemperatureResponse(caller, response, http2ServicePrefixSsl);
        } else if (http2CountSsl < 10) {
            sendErrorResponse(caller, response, http2ServicePrefixSsl);
        } else {
            sendTemperatureResponse(caller, response, http2ServicePrefixSsl);
        }
    }
}
