# CMD and Batch

A good resource: https://www.tutorialspoint.com/batch_script/

## Store the stdout of a command in a variable
```
for /F %i IN ('date') DO set START_DATE=%i
echo START_DATE %START_DATE%
```
Limitation: Only a single list, so the last line of multi-line output.


## Check the exit status of the previous command
```
echo %errorlevel%
```

## Redirect output to STDERR
```
echo STDERR 1>&2
```

## Batch scripts

### Exit with an error code
```
EXIT /B  2
```

### Track start and finished time, with pause.
```
@echo off

TITLE %0

SET STARTED_TIME=%TIME%

timeout /t 1 /nobreak

echo.
echo Started : %STARTED_TIME%
SET FINISHED_TIME=%TIME%
echo Finished: %FINISHED_TIME%
echo.

```
