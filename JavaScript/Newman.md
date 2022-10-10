**<span style="font-size:3em;color:black">Newman</span>**
***

Run Postman collections from JavaScript.

# Misc

[API Reference](https://github.com/postmanlabs/newman#api-reference)

## run() Return Value

Returns a Summary with *much* data on the result.  e.g.:
```bash
newmanSummary.run.executions[3].response.code
```

## Call order of the "folder" entries

The library doesn't respect the order of the entries in the "folder" array. It runs each of the specified entries, but in the order that they appear in the Postman collection file.
