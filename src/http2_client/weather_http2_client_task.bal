import ballerina/http;
import ballerina/log;
import ballerina/task;

http:Client weatherClient = new("http://localhost:8081", {
    timeoutInMillis: 2000,
    httpVersion: "2.0"
});

listener task:Listener weatherTimer = new({ intervalInMillis: 1000 });

service WeatherReceiverTimerService on weatherTimer {
    resource function onTrigger() {
        var weatherResponse = weatherClient->get("/getWeather");
        if (weatherResponse is http:Response) {
            var payload = weatherResponse.getTextPayload();
            if (payload is error) {
                log:printError("Error occurred while retrieving the payload from the response", payload);
            } else {
                log:printInfo("[Payload]: " + payload);
            }
        } else {
            log:printError("Error returned while attempting to retrieve weather data", weatherResponse);
        }
    }
}
