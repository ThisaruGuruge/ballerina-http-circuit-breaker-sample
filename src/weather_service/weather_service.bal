import ballerina/http;
import ballerina/log;

listener http:Listener weatherService = new(9090);

int count = 0;

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
        if (count % 5 == 0) {
            log:printInfo("[WeatherService] Trying to Send Temperature Response");
            string temperature = getTemperature().toString();
            response.setPayload(temperature);
            var result = caller->respond(response);
            handleResult(result);
        } else {
            log:printInfo("[WeatherService] Trying to Send ERROR Response");
            response.statusCode = 501;
            response.setPayload("Internal error occurred.");
            var result = caller->respond(response);
        }
    }
}
