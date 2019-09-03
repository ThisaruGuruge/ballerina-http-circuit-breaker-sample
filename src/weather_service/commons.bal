import ballerina/http;
import ballerina/log;
import ballerina/math;

# Returns current temperature
#
# + return - returns the current temperature value
public function getTemperature() returns float {
    return math:random() * 30;
}

# Handles the result of a caller respond function.
#
# + result - result from the `respond()` function
public function handleResult(error? result) {
    if (result is error) {
        log:printError("[WeatherService] Error occurred while sending the response", result);
    } else {
        log:printInfo("[WeatherService] Response sent successfully\n");
    }
}

function sendTemperatureResponse(http:Caller caller, http:Response response, string prefix) {
    log:printInfo(prefix + "Trying to Send Temperature Response");
    string temperature = getTemperature().toString();
    response.setPayload(temperature);
    var result = caller->respond(response);
    handleResult(result);
}

function sendErrorResponse(http:Caller caller, http:Response response, string prefix) {
    log:printInfo(prefix + "Trying to Send ERROR Response");
    response.statusCode = 501;
    response.setPayload("Internal error occurred.");
    var result = caller->respond(response);
}
