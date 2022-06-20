# Resources

Put resource files into the src/main/resources/ or src/test/resources/ directory.

## Load into a String

```
ClassLoader loader = Thread.currentThread().getContextClassLoader();
InputStream testResource = loader.getResourceAsStream("file.json");
String content = new String(testResource.readAllBytes())
```      

## In Eclipse, why the delay?

If you add the resource file directly on the file system (instead of via Eclipse) then getResourceAsStream() returns null, until Eclipse has the project refreshed and does a build.  This copies the resource file to target/classes/ or target/test-classes/.