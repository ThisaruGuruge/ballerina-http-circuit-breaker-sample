import ballerina/log;

public function handleResult(error? result) {
    if (result is error) {
        log:printError("[CircuitBreakerService] Error occurred while sending the response", result);
    } else {
        log:printInfo("[CircuitBreakerService] Response sent successfully");
    }
}
