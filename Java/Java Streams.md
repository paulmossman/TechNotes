# Java Streams

## Initialization

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

Set<String> set = new HashSet<String>(Arrays.asList("a", "b", "c"));
  
ArrayList<String> orderedUserVisits = new ArrayList<String>(
                Arrays.asList("a", "b", "c", "d"));

Map<String, Double> entries = Map.ofEntries(
   Map.entry("D", 1.5d),
   Map.entry("E", 3.0d)
);

## Misc

### toArray()
Primitive:
```java
ArrayList<Integer> src = new ArrayList<Integer>();
...
int[] result = src.stream().filter(i -> i != null).mapToInt(i -> i).toArray();
```
Object:
```java
ArrayList<String> src = new ArrayList<String>();
...
String[] result = src.toArray(String[]::new);
```

### Combine two Streams
```java
Stream<String> combinedStream = Stream.concat(
  collectionA.stream(),
  collectionB.stream());
String[] stringArray = combinedStream.toArray(String[]::new);
```

### Sort a Stream
```java
List<String> sortedList = list.stream()
			.sorted(___)
			.collect(Collectors.toList());
```
___ is a Comparator...
nothing - Natural Order
Comparator.reverseOrder() - Reverse natural order
Comparator.comparingInt(User::getAge) - Object method that returns int
new Comparator<Integer>() {
        @Override
        public int compare(Integer a, Integer b) {
            return Integer.compare(a, b);
        }
    })


## Imports that Eclipse has trouble auto-resolving

import static java.util.stream.Collectors.toSet;

