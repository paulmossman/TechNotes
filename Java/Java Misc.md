# Java Misc

## String compare for value equality
```java
    new String("test").equals("test") // --> true 
```

## Sort using a custom Comparator
```java
    Integer [] integers = ArrayUtils.toObject(toSort);
    Arrays.sort(integers, new Comparator<Integer>() {
        @Override
        public int compare(Integer a, Integer b) {
            return Integer.compare(a, b);
        }
    });
```

[Source](https://www.baeldung.com/java-sorting).


## HashSet with custom Objects

If you don't want the default behaviour then you have to override equals(), but thenyou must also override hashCode().

```java
    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof CustomClass))
            return false;
        Voucher other = (CustomClass) o;
        
        return ...
    }

    // Equal objects must have the same Hash Code.

    @Override
    public final int hashCode() {
        int result = 17;
        if (city != null) {
            result = 31 * result + city.hashCode();
        }
        if (department != null) {
            result = 31 * result + department.hashCode();
        }
        return result;
    }

```

But really, use a 3rd-party implementation...

[Full Explanation](https://www.baeldung.com/java-equals-hashcode-contracts)


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