import ballerina/log;
import ballerina/http;
import ballerina/runtime;

http:Client weatherClient = new("http://localhost:8080", {
    timeoutInMillis: 2000
});

public function main() {
    int count = 0;

    while (count < 10) {
        var weatherResponse = weatherClient->get("/getWeather");
        if (weatherResponse is http:Response) {
            var payload = weatherResponse.getTextPayload();
            if (payload is error) {
                log:printError("Error occurred while retrieving the payload from the response", payload);
            } else {
                log:printInfo(payload);
            }
        } else {
            log:printError("Error returned while attempting to retrieve weather data", weatherResponse);
        }
        count += 1;
        runtime:sleep(1000);
    }
}
