# Java Streams

## Overview



## Misc

### Various int sources
```java
IntStream.range(1, 5).forEach(System.out::print); // 1234

IntStream.rangeClosed(1, 4).forEach(System.out::print); // 1234

Stream.of(1, 2, 3, 4).forEach(System.out::print); // 1234

int nums[] = { 1, 2, 3, 4 };
Arrays.stream(nums).forEach(System.out::print); // 1234
```

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
Custom: new Comparator<Integer>() {
        @Override
        public int compare(Integer a, Integer b) {
            return Integer.compare(a, b);
        }
    })


### Map, Filter, Reduce, and Average
```java
int[] numbers = { 100, 20, 30, 50, 90, 121, 150 };

// 185.5
System.out.println("Sum of the halves of each number >= 100: "
      + Arrays.stream(numbers).filter(n -> n >= 100)
         .mapToDouble(n -> (double) n / 2)
         .reduce(0, (a, b) -> a + b));

// 0
System.out.println("Sum of the halves of each number >= 200: "
      + Arrays.stream(numbers).filter(n -> n >= 200)
         .mapToDouble(n -> (double) n / 2)
         .reduce(0, (a, b) -> a + b));

// 47.5
System.out.println("Average of all numbers <95: "
      + Arrays.stream(numbers).filter(n -> {
         return n < 95;
      }).average().orElseThrow());
```

## Map and Flat Map
```java
List<List<String>> list = Arrays.asList(
      Arrays.asList("e", "b", "c"),
      Arrays.asList("c", "d", "a"));
System.out.println(list);
// [[a, b, c], [c, d, e]]

System.out.println(list
      .stream()
      .flatMap(Collection::stream) // Stream of Lists of Strings -> Stream of Strings
      .collect(Collectors.toList())); // Stream of Strings -> List of Strings
// [e, b, c, c, d, a]

System.out.println( list
          .stream()
          .flatMap(Collection::stream)
          .map(String::toUpperCase)
          .collect(Collectors.toList()));
// [E, B, C, C, D, A]

System.out.println( list
          .stream()
          .flatMap(Collection::stream)
          .distinct()
          .map(String::toUpperCase)
          .collect(Collectors.toList()));
// [E, B, C, D, A]

System.out.println( list
          .stream()
          .flatMap(Collection::stream)
          .sorted()
          .distinct()
          .map(String::toUpperCase)
          .collect(Collectors.toList()));
// [A, B, C, D, E]

String[][] array = new String[][] { { "e", "b", "c" }, { "c", "d", "a" } };
System.out.println(Arrays.toString(Stream.of(array).flatMap(Arrays::stream) // Stream of String[] -> Stream of Strings
      .toArray(String[]::new)));
// [e, b, c, c, d, a]
```

## Imports that Eclipse has trouble auto-resolving

import static java.util.stream.Collectors.toSet;

import static java.util.Arrays.asList;

