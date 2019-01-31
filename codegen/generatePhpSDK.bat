cd .\codegen

set sdkfolder=..\SDKs\PHP

if NOT exist %sdkfolder%\SwaggerClient-php mkdir %sdkfolder%\SwaggerClient-php
copy /y Templates\php\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore

if exist "%sdkfolder%\lib\Aspose\Imaging\Model\" del /S /Q "%sdkfolder%\lib\Aspose\Imaging\Model\" || goto :error
if exist "%sdkfolder%\lib\Aspose\Imaging\ImagingApi.php" del /Q "%sdkfolder%\lib\Aspose\Imaging\ImagingApi.php" || goto :error

java -jar Tools\swagger-codegen-cli-2.3.1.jar generate -i %ApiEndpoint%v2/imaging/swagger/spec -l php -t Templates\php -o %sdkfolder% --invoker-package Aspose\Imaging --model-package Model --api-package Api --import-mappings SaaSposeResponse=SaaSposeResponse --import-mappings HttpStatusCode=HttpStatusCode || goto :error

move "%sdkfolder%\SwaggerClient-php\lib" "%sdkfolder%\SwaggerClient-php\copy-lib"
xcopy /s /y %sdkfolder%\SwaggerClient-php %sdkfolder%
rmdir /s /q "%sdkfolder%\SwaggerClient-php\"
mkdir %sdkfolder%\lib\Aspose\Imaging
xcopy /s /y %sdkfolder%\copy-lib %sdkfolder%\lib\Aspose\Imaging
rmdir /s /q %sdkfolder%\copy-lib

Tools\RequestModelExtractor.exe %sdkfolder%\lib\Aspose\Imaging\Api\ %sdkfolder%\lib\Aspose\Imaging\Model\Requests\ php

move "%sdkfolder%\lib\Aspose\Imaging\Api\ImagingApi.php" "%sdkfolder%\lib\Aspose\Imaging\ImagingApi.php"
rmdir /s /q %sdkfolder%\lib\Aspose\Imaging\Api

copy /y Templates\php\ImagingRequest.php %sdkfolder%\lib\Aspose\Imaging\Model\Requests\ImagingRequest.php
copy /y Templates\php\SaaSposeResponse.php %sdkfolder%\lib\Aspose\Imaging\Model\SaaSposeResponse.php

cd ..
echo OK
exit /b 0

:error
echo PHP SDK generation failed
exit 1