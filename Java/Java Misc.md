# Java Misc

## String compare for value equality
```java
    new String("test").equals("test") // --> true
    new String("test") == "test" // --> false
```

## Sort using a custom Comparator
```java
    Integer[] integers = { 4, 6, 2, 9, 5 };
    Arrays.sort(integers, new Comparator<Integer>() {
        @Override
        public int compare(Integer a, Integer b) {
            return Integer.compare(a, b);
        }
    });
```

[Source](https://www.baeldung.com/java-sorting).


## AES encryption/decryption
https://www.baeldung.com/java-aes-encryption-decryption
https://mkyong.com/java/java-aes-encryption-and-decryption


## Simple HTTP GET
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpsGet {

   public static void main(String[] args) throws IOException {

      URL url = new URL("https://google.com");
      HttpURLConnection con = (HttpURLConnection) url.openConnection();
      con.setRequestMethod("GET");

      System.out.println("Response Code: " + con.getResponseCode());

      BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
      String inputLine;
      StringBuffer content = new StringBuffer();
      while ((inputLine = in.readLine()) != null) {
         content.append(inputLine);
      }
      in.close();
      con.disconnect();

      System.out.println(content);
   }
}
```

## Compile for an older JRE
```bash
javac --release 8 HttpsGet.java
```

## Show supported SSL Cipher Suites
```java
import javax.net.ssl.SSLSocketFactory;

public class SSLCipherSuites {
   public static void main(String[] args) {
      SSLSocketFactory sslsocketfactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
      System.out.println("CipherSuites:");
      for (String cipherSuite : sslsocketfactory.getSupportedCipherSuites()) {
         System.out.println(" - " + cipherSuite);
      }
   }
}
```

## Generic toString(), using reflection
```java
   public String toString() {
      StringBuilder result = new StringBuilder();
      String newLine = System.getProperty("line.separator");

      result.append( this.getClass().getName() );
      result.append( " Object {" );
      result.append(newLine);

      //determine fields declared in this class only (no fields of superclass)
      java.lang.reflect.Field[] fields = this.getClass().getDeclaredFields();

      //print field names paired with their values
      for ( java.lang.reflect.Field field : fields  ) {
        result.append("  ");
        try {
          result.append( field.getName() );
          result.append(": ");
          //requires access to private field:
          result.append( field.get(this) );
        } catch ( IllegalAccessException ex ) {
          System.out.println(ex);
        }
        result.append(newLine);
      }
      result.append("}");

      return result.toString();
    }
```

Modified from https://commons.apache.org/proper/commons-lang/apidocs/org/apache/commons/lang3/builder/ReflectionToStringBuilder.html
```java
   @Override
   public String toString()
   {
      return org.apache.commons.lang3.builder.ToStringBuilder.reflectionToString(this);
   }
```

# Catch Shutdown

```java

   Runtime.getRuntime().addShutdownHook(new Thread() {
      public void run() {

         // This method gets run.
      }
   });
```
