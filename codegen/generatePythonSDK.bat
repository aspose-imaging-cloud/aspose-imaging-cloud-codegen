set sdkfolder=..\SDKs\Python

copy /y Templates\python\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\asposeimagingcloud\api\" del /S /Q "%sdkfolder%\asposeimagingcloud\api\"
if exist "%sdkfolder%\asposeimagingcloud\models\" del /S /Q "%sdkfolder%\asposeimagingcloud\models\"
java -jar Tools\swagger-codegen-cli-2.3.1.jar generate -i https://api-qa.aspose.cloud/v3.0/imaging/swagger/sdkspec -l python -t Templates\python -o %sdkfolder% -c config.python.json
start /b /wait Tools\RequestModelExtractor.exe %sdkfolder%\asposeimagingcloud\api\ %sdkfolder%\asposeimagingcloud\models\requests\ python
start /b /wait Tools\RequestModelPythonPackageBuilder.exe %sdkfolder%\asposeimagingcloud\models\requests %sdkfolder%\asposeimagingcloud\__init__.py asposeimagingcloud.models.requests
start /b /wait Tools\RequestModelPythonPackageBuilder.exe %sdkfolder%\asposeimagingcloud\models\requests %sdkfolder%\asposeimagingcloud\models\requests\__init__.py asposeimagingcloud.models.requests
