# Maven

## Dependencies

### Dependency Analysis
```
mvn dependency:analyze-report ---> target/dependency-analysis.html
```

### Print dependency tree
```
mvn dependency:tree
```

### Which dependencies have newer versions available?
```
mvn versions:display-dependency-updates
```

## Maven wrapper

Run Maven, even when Maven isn't installed.  (Still requires Java.)

[Great resource.](https://www.baeldung.com/maven-wrapper)

### Generate a new Maven wrapper
```
mvn -N wrapper:wrapper
```

NOTE: Running this under Windows does update the 'mvnw' bash script.  Running it under Linux does not update the 'mvnw.cmd' Batch script.

## Parameters

Don't show progress bars, good for non-interactive terminals:
```
--batch-mode | -B
```

Quiet:
```
--quiet
```
   
## Miscellaneous

### Run a main() method
```
mvn --quiet exec:java -Dexec.mainClass="\<Full name of Class with main()\>" -Dexec.args="\<cmd-line arguments\>"
```

### Use an alternate pom.xml
```   
mvn -f \<alternate pom.xml\>
```

### Print the M2 dir path
```
mvn help:evaluate -Dexpression=settings.localRepository
```

## Tests
Compile the tests, but don't execute them:
```
-DskipTests
```

Skip both test compilation and test execution:
```
-Dmaven.test.skip=true
```

Run specific test(s):
```
-Dtest=TestSquare,TestCi\*le test
```

Exclude specific test(s):
```
-Dtest=\!TestNotToBeRun
```
   
## Profiles

[Good reference](https://mkyong.com/maven/maven-profiles-example/)

Note that "\<packaging>" can't go into a profile, but you CAN use a property value from a profile.

