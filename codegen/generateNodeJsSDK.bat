cd .\codegen

set sdkfolder=..\SDKs\NodeJS

copy /y Templates\nodejs\.swagger-codegen-ignore %sdkfolder%\.swagger-codegen-ignore
if exist "%sdkfolder%\lib\api.ts" del /S /Q "%sdkfolder%\lib\api.ts" || goto :error
if exist "%sdkfolder%\lib\model\model.ts" del /S /Q "%sdkfolder%\lib\model\model.ts" || goto :error
java -jar Tools\swagger-codegen-cli-2.4.5.jar generate -i https://api-qa.aspose.cloud/v3.0/imaging/swagger/sdkspec -l typescript-node -t Templates\nodejs -o %sdkfolder% || goto :error
if NOT EXIST %sdkfolder%\lib mkdir %sdkfolder%\lib || goto :error
move /y %sdkfolder%\api.ts %sdkfolder%\lib\api.ts || goto :error
move /y %sdkfolder%\git_push.sh %sdkfolder%\lib\model\model.ts || goto :error

cd Tools
powershell -NoProfile -ExecutionPolicy Bypass -Command ". '.\nodejs.ps1' '$sdkfolder\'" || goto :error
cd ..

cd ..
echo OK
exit /b 0

:error
echo Node.js SDK generation failed
exit 1
