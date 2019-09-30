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
3. Go inside the `ballerina-circuit-breaker-example` directory and execute following command in a terminal.

```bash
ballerina run weather_service
```

This will starts the weather service back ends. You can confirm the services are up and running when the following messages appear.
```
[ballerina/http] started HTTP/WS listener 0.0.0.0:9091
[ballerina/http] started HTTPS/WSS listener 0.0.0.0:9092
[ballerina/http] started HTTP/WS listener 0.0.0.0:9090
```

4. Then open a new terminal at the `ballerina-circuit-breaker-example` and execute the following command.

```bash
ballerina run circuit_breaker_service
```

This will start the circuit breaker client. It will show the following if the service is up and running.

```
[ballerina/http] started HTTP/WS listener 0.0.0.0:8080
[ballerina/http] started HTTP/WS listener 0.0.0.0:8081
[ballerina/http] started HTTPS/WSS listener 0.0.0.0:8082
```

5. Now you can invoke any client to send a request to the backend. There are three clients.

* http1_client - This is the basic HTTP/1 client
* http2_client - This is the basic HTTP/2 client
* http2_client_ssl - This client uses HTTP2 and SSL to connect with the backend

You can run one of the clients by opening a new terminal inside `ballerina-circuit-breaker-example` and running either of the following commands

```
ballerina run http1_client

ballerina run http2_client

ballerina run http2_client_ssl
```
