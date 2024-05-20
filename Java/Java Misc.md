# Java Misc

# Date
```java
DateFormat formatter = new SimpleDateFormat( "YYYY-MM-dd HH:mm:ss" );
System.out.println( formatter.format( new Date() ) );
// 2024-02-03 10:46:50
```
HH is 00-23.
MM is the Month, so don't use it for Minutes.
DD and D are the day count of the year, so don't use it for Day of the Month.

## Map initialization
```java
Map<String, Double> entries = Map.ofEntries(
   Map.entry("D", 1.5d),
   Map.entry("E", 3.0d)
);
```

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


## Arrays (the class)
- sort
- binarySearch (sorted arrays only)
- equals
- fill
- copyOf
- copyOfRange
- setAll - uses a generator function
- stream
- compare
- mismatch

### Simple print of a primitive array / Print Array / Print an Array
```java
int nums[] = { 1, 2, 3, 4 };
System.out.println(Arrays.toString(nums));
// [1, 2, 3, 4]
```

## @FunctionalInterface
```java
  // Two input arguments, then the return value.
  BiFunction<Integer, Integer, String> sumAsString = (x, y) -> Integer.toString(x + y);
  System.out.println(sumAsString.apply(2, 2)); // "4"

  // No input argument, only a return value.
  Supplier<String> suppliedString = () -> "Supplied string";
  System.out.println(suppliedString.get()); // Supplied string

  // One input argument, no return value.
  Consumer<String> printlnString2 = System.out::println;
  printlnString2.accept("Accepted string"); // Accepted string

  List<String> acceptedStrings = new ArrayList<String>();
  Consumer<String> printlnString = s -> acceptedStrings.add(s);
  printlnString.accept("1");
  printlnString.accept("2");
  printlnString.accept("3");
  System.out.println(acceptedStrings); // [1, 2, 3]

  Predicate<Integer> isEven = i -> i % 2 == 0;
  System.out.println(isEven.test(2)); // true
  System.out.println(isEven.test(3)); // false
  
  String[] strings = { "A", "B", "C", "D" };
  BinaryOperator<String> stringConcatinator = (s1, s2) -> s1 + "," + s2;
  // Note: BinaryOperator<T> extends BiFunction<T, T, T>
  System.out.println(Arrays.stream(strings)
    .reduce(stringConcatinator).orElse("Empty")); // A,B,C,D

   // BinaryOperator<T> extends BiFunction<T,T,T>
   // Parameter #2 in reduce(), which calls BiFunction.apply().
   BinaryOperator<String> combineStrings = (a, b) -> {
      if (a.isEmpty()) {
         return b;
      }
      if (b.isEmpty()) {
         return a;
      }
      return a + "~" + b;
   };
   System.out.println(Stream.of("1", "2", "3", "4").reduce("", combineStrings));
   // 1~2~3~4
   
   BiFunction<Float, Float, Boolean> floatEquals = Float::equals;
   BiFunction<String, String, Boolean> stringEquals = String::equals;

  // IntBinaryOperator: Operates on primative int only.
  // i.e. IntBinaryOperator does *not* extend BinaryOperator/BiFunction.
  IntBinaryOperator add = (i, j) -> i + j;
  System.out.println(add.applyAsInt(2, 2)); // 4

  IntBinaryOperator subtract = (i, j) -> i - j;
  System.out.println(subtract.applyAsInt(10, 4)); // 6

  IntBinaryOperator multiply = (i, j) -> i * j;
  System.out.println(multiply.applyAsInt(2, 6)); // 12
```

Advanced examples: https://mkyong.com/java8/java-8-bifunction-examples/

### Shorthand
Equivalents:
```java
Function<String, String> f1 = String::toUpperCase;
UnaryOperator<String> f2 = String::toUpperCase;
Function<String, String> f3 = s -> s.toUpperCase();
Function<String, String> f4 = new Function<String, String>() {
   @Override
   public String apply(String s) {
      return s.toUpperCase();
   }
};
```

### Composition

#### Simple
```Function.andThen()``` to string two functions together into a new function.

```java
   // Parameter #1 is the input type, and parameter #2 is the return type.
   Function<Integer, Integer> addFour = a -> a + 4;
   Function<Integer, Integer> multiplyByTwo = a -> a * 2;
   Function<Integer, Integer> addFourThenMultipleByTwo = addFour.andThen(multiplyByTwo);

   System.out.println(addFourThenMultipleByTwo.apply(4)); // 16
```

#### Predicates have more
```java
int ages[] = { 72, 18, 20, 6, 12, 50, 65, 29 };

IntPredicate adult = i -> i >= 18;
IntPredicate seniorCitizen = i -> i >= 65;

List<Integer> seniorsAndChildren = Arrays.stream(ages)
   .filter(adult.negate().or(seniorCitizen)).boxed()
   .collect(Collectors.toList());
System.out.println(seniorsAndChildren);
// [ 72, 6, 12, 65 ]
```

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

## Catch Shutdown

```java

   Runtime.getRuntime().addShutdownHook(new Thread() {
      public void run() {

         // This method gets run.
      }
   });
```
