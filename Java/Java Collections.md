# Java Collections

## Initialization

```java
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

Set<String> set = new HashSet<String>(Arrays.asList("a", "b", "c"));
  
ArrayList<String> orderedUserVisits = new ArrayList<String>(
                Arrays.asList("a", "b", "c", "d"));

```

## PriorityQueue

Like a sorted Set (e.g. TreeSet), except that it *allows* duplicates.
So of course it's not a FIFO queue.

```java
      List<Integer> A = new ArrayList<Integer>(Arrays.asList(4, 6, 2, 9, 5, 2));
      Queue<Integer> sortedQueue = new PriorityQueue<Integer>(A);
      System.out.println(sortedQueue);
      // Note: [2, 5, 2, 9, 6, 4] is not sorted, nor is it the initial order.

      while (sortedQueue.size() != 0) {
         System.out.print(sortedQueue.poll() + " ");
      }
      // 2 2 4 5 6 9
```

## HashSet with custom Objects

If you don't want the default behaviour then you have to override equals(), but then you must also override hashCode().

The general contract for hashCode(): Equal objects must have equal hash codes.

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

Use [EqualsVerifier](https://jqno.nl/equalsverifier/) to test equals() and hashCode().
