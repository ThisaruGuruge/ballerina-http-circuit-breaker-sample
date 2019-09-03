import ballerina/http;
import ballerina/log;

listener http:Listener http2WeatherService = new(9091, {
    httpVersion: "2.0"
});

int http2Count = 0;

@http:ServiceConfig {
    basePath: "/"
}
service Http2WeatherService on http2WeatherService {
    @http:ResourceConfig {
	    path: "getWeather"
	}
    resource function getWeather(http:Caller caller, http:Request req) {
        http:Response response = new;
        http2Count += 1;
        if (http2Count % 5 == 0) {
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
