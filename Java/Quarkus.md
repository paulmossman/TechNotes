# Quarkus

[Misc useful info](https://jbcodeforce.github.io/java/quarkus/)


[Cheat Sheet](http://www.cheat-sheets.org/saved-copy/quarkus-cheat-sheet.pdf)

## Run in Production mode
```bash
java -jar target/quarkus-app/quarkus-run.jar
```

## Misc Maven

Development mode:
```
mvn quarkus:dev
```

### Extensions

   mvn quarkus:list-extensions
   
   mvn quarkus:add-extension -Dextensions="hibernate-validator"

### All Configuration Options

   https://quarkus.io/guides/all-config

## Dynamic Configuration (vs. application.properties)

Create a class that implements org.eclipse.microprofile.config.spi.ConfigSource.
List that class (full path) in src/main/resources/META-INF/services/org.eclipse.microprofile.config.spi.ConfigSource.

See also: https://quarkus.io/guides/config-extending-support and https://quarkus.io/guides/config-reference