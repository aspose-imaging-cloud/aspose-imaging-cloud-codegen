cd .\codegen

setlocal
set sdkfolder=..\SDKs\NET

copy /y Templates\csharp\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Api\" del /S /Q "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Api\" || goto :error
if exist "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Model\" del /S /Q "%sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Model\" || goto :error
java -jar Tools\swagger-codegen-cli-2.3.1.jar generate -i http://api-dev.aspose.cloud/v1.1/imaging/swagger/spec -l csharp -t Templates\csharp -o %sdkfolder% -c config.json || goto :error
Tools\CSharpRequestModelExtractor.exe %sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Api\ %sdkfolder%\src\Aspose.Imaging.Cloud.Sdk\Model\Requests\ || goto :error

cd ..