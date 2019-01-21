@echo off

For /F "useback tokens=2 delims=*\" %%I in (`TASKLIST /FI "IMAGENAME eq explorer.exe" /NH /v`) Do (
    For /F "useback tokens=1 delims= " %%b in (`echo %%I`) Do (
        set name=%%b
        )
    )

echo %name%
