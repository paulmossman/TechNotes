# CMD and Batch

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
