# JUnit

## Misc

### Repeat a test N times
```java
import org.junit.jupiter.api.RepeatedTest;

@RepeatedTest(N)
```

### Skip a test (or part) based on condition
```java
import static org.junit.jupiter.api.Assumptions.assumeTrue;

...

   @Test
   public void testMaybe() {
      assumeTrue(someBooleanValue);

      ...
   }

```

### assertEquals with "delta"
```java
e.g. assertEquals(double expected, double actual, double delta)
```
vs. closeTo()

## Array contains, same order
```java
import static org.assertj.core.api.Assertions.assertThat;
...
ArrayList<String> items = new ArrayList<String>(Arrays.asList("one", "two"));
assertThat(items).containsExactly("one", "two");
```