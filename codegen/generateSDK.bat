call codegen\generateNetSDK ||  goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%








