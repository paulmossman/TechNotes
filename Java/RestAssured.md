# RestAssured


## Imports
   import static io.restassured.RestAssured.*;
   import static org.hamcrest.Matchers.*;

## Log

   In the ".then()" (RESPONSE) section:

      .log().ifError()
      
      .log().body()
      
   In the ".when()" (REQUEST) section:
   
      .log().all() 

## Log the Curl equivalent of the Request

   (Custom config factory...)

   https://stackoverflow.com/questions/54541562/get-the-curl-operation-from-each-rest-assured-test-and-print-in-the-console-wh