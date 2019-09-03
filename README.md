# ballerina-http-circuit-breaker-sample
Sample test for Ballerina HTTP circuit breaker functionality

This is a sample code for test the ballerina HTTP circuit breaker functionality.

## Modules

### Weather Service
The `weather_service` module mocking a weather service, which will send the current temperature for a client who sends a `GET` request.
This service is created to send the temperature service once in a while, to mock a failing service. It sends an `500_INTERNAL_ERROR` response, most of the time.

### Circuit Breaker Service
This service acts as the gateway for the temperature service. Clients sends the request to this service and it will forward the requests, through a __Ballerina circuit breaker client__.
As the temperature service fails, the circuit breaker client will stop sending the requests to the upstream service, instead it sends error response to the client directly, until the reset time reaches.

### Client 
This module has a simple client which will send a Get request to the circuit breaker service periodically, using Ballerina task.


## How to run
1. Download and Install [ballerina](https://ballerina.io/downloads/).
2. Pull this repository
3. Go inside the `ballerina-circuit-breaker-example` directory and execute following commands in three different terminals. (Use the same order)

```bash
ballerina run weather_service

ballerina run circuit_breaker_service

ballerina run clients
```
