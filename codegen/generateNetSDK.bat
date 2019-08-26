cd .\codegen

set sdkfolder=..\SDKs\NET

copy /y Templates\csharp\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Api\" del /S /Q "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Api\" || goto :error
if exist "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Model\" del /S /Q "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Model\" || goto :error
move %sdkfolder%\README.md %sdkfolder%\README.md.bak || goto :error
if exist "%sdkfolder%\docs\" del /S /Q "%sdkfolder%\docs\" || goto :error
java -jar Tools\swagger-codegen-cli-2.4.5.jar generate -i https://api-qa.aspose.cloud/v3.0/imaging/swagger/sdkspec -l csharp -t Templates\csharp -o %sdkfolder% -c config.net.json || goto :error
move %sdkfolder%\README.md %sdkfolder%\docs\API_README.md || goto :error
move %sdkfolder%\README.md.bak %sdkfolder%\README.md || goto :error
Tools\RequestModelExtractor.exe %sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Api\ %sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Model\Requests\ csharp || goto :error

cd ..
exit /b 0

:error
echo .NET SDK generation failed
exit 1