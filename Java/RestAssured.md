# RestAssured


## Imports
```java
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;
```

## Log

   In the ".then()" (RESPONSE) section:

      .log().ifError()
      .log().body()
      .log().all()
      
   In the ".when()" (REQUEST) section:
   
      .log().body()
      .log().all()

## Log the Curl equivalent of the Request

   (Custom config factory...)

   https://stackoverflow.com/questions/54541562/get-the-curl-operation-from-each-rest-assured-test-and-print-in-the-console-wh
   
## Array contains an element
```java
body("path.to.array",
    hasItem(
          allOf(
              hasEntry("firstName", "test"),
              hasEntry("lastName", "test")
          )
    )
)
```