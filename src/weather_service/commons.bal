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
        log:printInfo("[WeatherService] Response sent successfully");
    }
}
