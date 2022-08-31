**<span style="font-size:3em;color:black">CloudWatch</span>**
***

# Export to Amazon S3

[See here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/S3ExportTasksConsole.html), but note:
- Skip the "Create an IAM user" step if you're already using an IAM user with sufficient permissions.
- For S3 Bucket Policy ```random-string```, just pick some string.
- CloudWatch export to S3: The above ```random-string``` value must be entered for *S3 Bucket prefix*.

Note: You can choose to export a single log stream.

Note: The log ntries in the resulting files might not be sorted by time.

# Logs Insights
[Query Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html)

Simiar to Regex.

CloudWatch Logs Insights can discover a maximum of 1000 log event fields in a log group. This quota can't be changed.   

Common:
```
fields @timestamp, @message, @logStream
    | limit 100
    | filter @message like /StringToSearchFor/
    | filter @logStream like /StreamsToSearch/
```

Wildcard:
```
fields @timestamp, @message, @logStream
      | filter @message like /bob@example.com.*400/
# Logs for this user with "400"
```

Complex:
```
fields @timestamp, @message, @latency, @status 
   | filter @message like 'Received response.'
   | parse @message /^.*Status\:\s(?<@status>\d*),\sIntegration\slatency\:\s(?<@latency>\d*)\sms$/
   | filter @latency > 100 and @status = 200
   | sort @latency desc
```

Note: "fields" is case insensitive, but "filter" is case sensitive.

Parse a logged value:
```
fields @message
   | filter @message like /1583791031847.+total execution time/
   | parse @message "total execution time : * milliseconds" as executiontime
```