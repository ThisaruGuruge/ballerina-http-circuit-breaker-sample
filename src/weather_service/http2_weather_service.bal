import ballerina/http;

listener http:Listener http2WeatherService = new(9091, {
    httpVersion: "2.0"
});

int http2Count = 0;
string http2ServicePrefix = "[HTTP/2 WeatherService]";

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
        if (http2Count < 5) {
            sendTemperatureResponse(caller, response, http2ServicePrefix);
        } else if (http2Count < 10) {
            sendErrorResponse(caller, response, http2ServicePrefix);
        } else {
            sendTemperatureResponse(caller, response, http2ServicePrefix);
        }
    }
}
