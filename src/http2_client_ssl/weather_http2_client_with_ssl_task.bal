import ballerina/filepath;
import ballerina/http;
import ballerina/log;
import ballerina/task;

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

http:Client weatherClient = new("https://localhost:8082", {
    timeoutInMillis: 2000,
    httpVersion: "2.0",

    secureSocket: secureSocketConfig
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
