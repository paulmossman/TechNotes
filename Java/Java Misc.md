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
