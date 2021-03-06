cd .\codegen

set sdkfolder=..\SDKs\Python

copy /y Templates\python\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\asposeimagingcloud\api\" del /S /Q "%sdkfolder%\asposeimagingcloud\api\" || goto :error
if exist "%sdkfolder%\asposeimagingcloud\models\" del /S /Q "%sdkfolder%\asposeimagingcloud\models\" || goto :error
move %sdkfolder%\README.md %sdkfolder%\README.md.bak || goto :error
if exist "%sdkfolder%\docs\" del /S /Q "%sdkfolder%\docs\" || goto :error
java -jar Tools\swagger-codegen-cli-2.4.5.jar generate -i https://api-qa.aspose.cloud/v3.0/imaging/swagger/sdkspec -l python -t Templates\python -o %sdkfolder% -c config.python.json || goto :error
move %sdkfolder%\README.md %sdkfolder%\docs\API_README.md || goto :error
move %sdkfolder%\README.md.bak %sdkfolder%\README.md || goto :error
call Tools\RequestModelExtractor.exe %sdkfolder%\asposeimagingcloud\api\ %sdkfolder%\asposeimagingcloud\models\requests\ python || goto :error
call Tools\RequestModelPackageBuilder.exe %sdkfolder%\asposeimagingcloud\models\requests %sdkfolder%\asposeimagingcloud\__init__.py asposeimagingcloud.models.requests || goto :error
call Tools\RequestModelPackageBuilder.exe %sdkfolder%\asposeimagingcloud\models\requests %sdkfolder%\asposeimagingcloud\models\requests\__init__.py asposeimagingcloud.models.requests || goto :error
call Tools\CopyrightFixer.exe %sdkfolder%\asposeimagingcloud\models\ __init__.py

cd ..
exit /b 0

:error
echo Python SDK generation failed
exit 1
