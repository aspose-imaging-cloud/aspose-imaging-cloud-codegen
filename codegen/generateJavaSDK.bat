cd .\codegen

set sdkfolder=..\SDKs\Java

copy /y Templates\java\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\api\" del /S /Q "%sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\api\" || goto :error
if exist "%sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\model\" del /S /Q "%sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\model\" || goto :error
java -jar Tools\swagger-codegen-cli-2.3.1.jar generate -i %ApiEndpoint%v2/imaging/swagger/spec -l java -DsupportJava6=true -t Templates\Java -o %sdkfolder% -c config.java.json || goto :error
Tools\RequestModelExtractor.exe %sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\api\ %sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\model\requests\ java || goto :error
if exist "%sdkfolder%\src\test\java\com\aspose\imaging\cloud\sdk" rmdir /S /Q "%sdkfolder%\src\test\java\com\aspose\imaging\cloud\sdk" || goto :error
if exist "%sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\invoker\auth\" rmdir /S /Q "%sdkfolder%\src\main\java\com\aspose\imaging\cloud\sdk\invoker\auth\" || goto :error
if exist "%sdkfolder%\gradle\" rmdir /S /Q "%sdkfolder%\gradle\" || goto :error

cd ..
exit /b 0

:error
echo Java SDK generation failed
exit 1