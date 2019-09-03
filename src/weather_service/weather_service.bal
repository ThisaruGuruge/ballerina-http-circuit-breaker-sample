import ballerina/http;

listener http:Listener weatherService = new(9090);

int count = 0;
string http1ServicePrefix = "[WeatherService]";

@http:ServiceConfig {
    basePath: "/"
}
service WeatherService on weatherService {
    @http:ResourceConfig {
	    path: "getWeather"
	}
    resource function getWeather(http:Caller caller, http:Request req) {
        http:Response response = new;
        count += 1;
        if (count < 5) {
            sendTemperatureResponse(caller, response, http1ServicePrefix);
        } else if (count < 10) {
            sendErrorResponse(caller, response, http1ServicePrefix);
        } else {
            sendTemperatureResponse(caller, response, http1ServicePrefix);
        }
    }
}
