cd .\codegen

set sdkfolder=..\SDKs\Ruby

copy /y Templates\ruby\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\lib\aspose-imaging-cloud" del /S /Q "%sdkfolder%\aspose-imaging-cloud" || goto :error
move %sdkfolder%\README.md %sdkfolder%\README.md.bak || goto :error
if exist "%sdkfolder%\docs\" del /S /Q "%sdkfolder%\docs\" || goto :error
java -jar Tools\swagger-codegen-cli-2.4.5.jar generate -i https://api-qa.aspose.cloud/v3.0/imaging/swagger/sdkspec -l ruby -t Templates\ruby -o %sdkfolder% -c config.ruby.json || goto :error
move %sdkfolder%\README.md %sdkfolder%\docs\API_README.md || goto :error
move %sdkfolder%\README.md.bak %sdkfolder%\README.md || goto :error
call Tools\RequestModelExtractor.exe %sdkfolder%\lib\aspose-imaging-cloud\api\ %sdkfolder%\lib\aspose-imaging-cloud\models\requests\ ruby || goto :error
call Tools\RequestModelPackageBuilder.exe %sdkfolder%\lib\aspose-imaging-cloud\models\requests %sdkfolder%\lib\aspose-imaging-cloud.rb aspose-imaging-cloud || goto :error
call Tools\CopyrightFixer.exe %sdkfolder%\lib\aspose-imaging-cloud\models

cd ..
exit /b 0

:error
echo Ruby SDK generation failed
exit 1
