######################################################
## Generate Docs
######################################################

########
# Generate README.md
########
$readmePath = "$($pathToSdk)\docs\API_README.md"


# REST Methods
$apiEndpointsHeader = @'
## Documentation for API Endpoints

All URIs are relative to *https://api.aspose.cloud/v3.0/*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------

'@


function Update-ReadmeFile() {
	$modelsHeader = '## Documentation for Models'
	$content += "$($apiEndpointsHeader)$(Get-ApiEndpointsTable)`n$($modelsHeader)`n`nClass | Description`n----- | -----`n$(Get-ModelsTable)"
	$content | Set-Content -encoding UTF8 $readmePath
}

function Get-ModelsTable() {
    $modelRows = @()
    foreach ($model in $jsonSpec.definitions.PSObject.Properties) {
        $modelRows += Get-ModelTableRow $model
    }
    return ($modelRows | Sort-Object) -join "`n"
}

function Get-MethodSummary($m) {
    return ($m.Value.summary -replace "\s+", ' ')
}

function Get-ApiEndpointTableRow ($method, $methodPath, $docPath) {
    return ("*ImagingApi* | [**$(ConvertTo-NativeMethodName $method.Value.operationId)**]($($docPath)ImagingApi.md#$(ConvertTo-NativeMethodName $method.Value.operationId)) | " +
        "**$($method.Name.ToUpper())** $($path.Name -replace '{', '\{') | " +
        (Get-MethodSummary $method) + "`n")
}

function Get-ApiEndpointsTable($docPath)
{
    $apiEndpointsRows = @()
    foreach ($path in $jsonSpec.paths.PSObject.Properties) {
        foreach ($method in $path.Value.PSObject.Properties) {
            $apiEndpointsRows += (Get-ApiEndpointTableRow -method $method -methodPath $path -docPath $docPath)
        }    
    }
    # sort by method name
    return ($apiEndpointsRows | Sort-Object) -join ''
}

# Models

function Get-ModelRef($model) {
    return "[**$($model.Name)**]($($model.Name).md)"
}


function Get-ModelDescription($model) {
    return ($model.Value.description -replace "\s+", ' ')
}

function Get-ModelTableRow($model) {
    return "$(Get-ModelRef $model) | $(Get-ModelDescription $model)"
}

#####################
# Generate ImagingApi.md
#####################

# docs folder
$docsFolder = "$($pathToSdk)\docs"


$apiFileHeader = @'
# Aspose.Imaging.Cloud.Sdk.Api.ImagingApi


'@

function Generate-ImagingApiDoc() {
    $apiFileContent = $apiFileHeader
    $apiFileContent += Get-AllMethodsDoc
    $apiFileContent | Set-Content -encoding UTF8 "$($docsFolder)\ImagingApi.md"
}

function Get-AllMethodsDoc() {
    $methodsDocs = @()
    foreach ($path in $jsonSpec.paths.PSObject.Properties) {
        foreach ($method in $path.Value.PSObject.Properties) {
            $methodsDocs += Get-MethodDoc $method
        }    
    }
    return ($methodsDocs | Sort-Object) -join ''
}
# for delete
<#
function Get-MethodParametersList($method) {
    $ret = ''
    foreach ($param in $method.Value.Parameters) {
        if ($ret.Length) {
            $ret += ', '
        }
        $ret += $param.name
    }
    return $ret
}
#>


function Extract-TypeFromRef($ref) {
    return $ref -replace '#/definitions/', ''
}

<#
function Get-NativeTypeRef($param) {
    if ($param.schema) { # Parameter is DTO
        if ($param.schema.type -eq 'array') { # Parameter is array of DTO
            return "[**$(ConvertTo-NativeArray (Extract-TypeFromRef $param.schema.items.'$ref'))**]($(Extract-TypeFromRef $param.schema.items.'$ref').md)"
        } else { # Parameter is single DTO          
            return "[**$(Extract-TypeFromRef $param.schema.'$ref')**]($(Extract-TypeFromRef $param.schema.'$ref').md)"
        }

    } else { # Parameter is primitive
        if ($param.type -eq 'array') { # Parameter is array of primitives
            return "**$(ConvertTo-NativeArray  (ConvertTo-NativePrimitiveType $param.items.type))**"
        } else { # Parameter is single primitive
            return "**$(ConvertTo-NativePrimitiveType $param.type)**"
        }
    }
}
#>

<#
function Get-ParamDescription($param) {
    return ($param.description -replace "\s+", ' ')
}
#>

<#
function Get-NativeMethodParametersTable($method) {
    $ret =''
    foreach ($param in $method.Value.Parameters) {
        $ret += "**$($param.name)** | $(Get-NativeTypeRef $param) | $(Get-ParamDescription $param) | $(Get-ParameterNotes $param)`n"
    }
    return $ret
}
#>

function Get-MethodReturnTypeRef($method) {
    $type = ''
    if ($method.Value.responses.'200'.schema.'$ref') {
        $type = $method.Value.responses.'200'.schema.'$ref' -replace '#/definitions/', ''
        return "[**$(Get-NativeClassName $type)**]($($type).md)"
    } else {
        return "**$(ConvertTo-NativePrimitiveType $method.Value.responses.'200'.schema.type)**"
    }
    
}


 
# moved to native module
function Get-MethodReturnTypePlane($method) {
    if ($method.Value.responses.'200'.schema.'$ref') {
        return $method.Value.responses.'200'.schema.'$ref' -replace '#/definitions/', ''
    } else {
        return $method.Value.responses.'200'.schema.type
    }
}


<#
function Get-ParameterNotes($param) {
    if ($param.required) {
        return ''
    } else {
        return '[optional]'
    }
}
#>

function Get-MethodCosumesHeader($method) {
    if ($method.Value.consumes) {
        return $method.Value.consumes[0]
    }
    return 'application/json'
}

function Get-MethodProducesHeader($method) {
    if ($method.Value.produces) {
        return $method.Value.produces[0]
    }
    return 'application/json'
}


function Get-MethodDoc($method) {
    $ret = ''
    $ret += "<a name=""$(ConvertTo-NativeMethodName $method.Value.operationId)""></a>`n"
    $ret += "## **$(ConvertTo-NativeMethodName $method.Value.operationId)**`n"
    #$ret += "> $(ConvertTo-NativeMethodName $method.Value.operationId)($(Get-MethodParametersList $method)) : $(Get-MethodReturnTypePlane $method)`n`n"
    $ret += "> $(Get-NativeMethodCallDoc $method)`n`n"
    $ret += "$(Get-MethodSummary $method)`n`n"
    $ret += "### Parameters`n"
    $ret += "Name | Type | Description  | Notes`n"
    $ret += "------------- | ------------- | ------------- | -------------`n"
    $ret += Get-NativeMethodParametersTable $method
    $ret += "`n### Return type`n`n"
    $ret += "$(Get-MethodReturnTypeRef $method)`n`n"
    $ret += "### HTTP request headers`n`n"
    $ret += " - **Content-Type**: $(Get-MethodCosumesHeader $method)`n"
    $ret += " - **Accept**: $(Get-MethodProducesHeader $method)`n`n"
    return $ret
}




##################
# Generate Models
##################

function Get-ModelDocFooter($model) {
    return "`n[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md) [[View Source]]($(Get-NativePathFromModelDocToSourceFile $model))`n"
}

function Get-EnumTable($model) {
    $models = $jsonSpec.definitions.PSObject.Properties
    $enumDesc = $models.Item($model.Name).Value.'x-enumDescriptions'.PSObject.Properties
    $enumTableRows = @()
    foreach ($prop in $model.Value.enum) {
        $enumTableRows += "**$(ConvertTo-NativeEnum $prop)** | **$(ConvertTo-NativePrimitiveType $model.Value.type)** | '$($prop)' | $($enumDesc.Item($prop).Value)"
    }
    return ($enumTableRows | Sort-Object) -join "`n"
}

function Generate-EnumDoc($model) {
    $content = "# $($model.Name)`n"
    $content += "$($model.Value.description)`n`n"

    $content += "## Enum`n"
    $content += "Name | Type | Value | Description`n"
    $content += "------------ | ------------- | ------------- | -------------`n"
    $content += Get-EnumTable $model
    $content += "`n$(Get-ModelDocFooter $model)"
    $content | Set-Content -encoding UTF8 "$($docsFolder)\$($model.Name).md"
}

function Get-ModelByRefValue([string] $refValue) {
    return $jsonSpec.definitions.PSObject.Properties.Item("$(Extract-TypeFromRef $refValue)")
}

<#
function Get-NativePropertyTypeRef($model, $prop) {
    if ($prop.Value.type -eq 'array') {
        if ($prop.Value.items.type) {
            return "**$(ConvertTo-NativeArray (ConvertTo-NativePrimitiveType $prop.Value.items.type))**"
        } else {
            $className = Extract-TypeFromRef $prop.Value.items.'$ref'
            return "[**$(ConvertTo-NativeArray $className)**]($($className).md)"
        }
    } elseif ($prop.Value.type) {
        return "**$(ConvertTo-NativePrimitiveType $prop.Value.type)**"
    } elseif ($prop.Value.'$ref') {
        
        $className = Extract-TypeFromRef $prop.Value.'$ref'
        return "[**$($className)**]($($className).md)"
    }
}
#>

function Get-PropertyDescription ($prop, $model, $isParent) {
    $ret = ($prop.Value.description -replace "\s+", ' ')
    if ($isParent) {
        $ret += "<br />*Inherited from [$(Get-NativeClassName $model.Name)]($($model.Name).md)*"
    }
    return $ret
}

function Get-PropNotes($model, $prop) {
    if (($model.Value.allOf -and $model.Value.allOf[1].PSObject.Properties['required'] -and $model.Value.allOf[1].PSObject.Properties['required'].Value.Contains($prop.Name)) -or ($model.Value.required -and $model.Value.required.Contains($prop.Name))) {
        return ''
    } else {
        return '[optional]'
    }

}

function Get-PropertiesTable($model, $content, $isParent) {
    $properties = $null
    if ($model.Value.allof) {
        $properties = $model.Value.allof[1].PSObject.Properties['properties'].Value.PSObject.Properties
    } else {
        $properties = $model.Value.properties.PSObject.Properties
    }

    foreach ($prop in $properties) {
        $content += "**$(ConvertTo-NativePropName $prop.Name)** | $(Get-NativePropertyTypeRef -model $model -prop $prop) | $(Get-PropertyDescription -prop $prop -model $model -isParent $isParent) | $(Get-PropNotes -model $model -prop $prop)`n" 
    }

    if ($model.Value.allof) {
        return Get-PropertiesTable -model (Get-ModelByRefValue $model.Value.allOf[0].'$ref') -content $content -isParent $true
    }

    return $content
}

function Generate-ClassDoc($model) {
    Write-Output "class: $($model.Name)"
    $content = "# $($model.Name)`n"
    $content += "$($model.Value.description)`n`n"
    if ($model.Value.allof) {
        $parentClass = Extract-TypeFromRef $model.Value.allof[0].PSObject.Properties.Value
        $content += "*Inherited from [$(Get-NativeClassName $parentClass)]($($parentClass).md)*`n"    
    }
    $content += "## Properties`n"
    $content += "Name | Type | Description | Notes`n"
    $content += "------------ | ------------- | ------------- | -------------`n"
    $content += Get-PropertiesTable -model $model
    $content += Get-ModelDocFooter $model
    $content | Set-Content -encoding UTF8 "$($docsFolder)\$($model.Name).md"
}

function Generate-ModelsDoc {
    foreach ($model in $jsonSpec.definitions.PSObject.Properties) {
        if ($model.Value.enum) {
            Generate-EnumDoc $model
        } else {
            Generate-ClassDoc $model
        }
    }
}

function Clear-Docs {
    # Create doc folder if not exists
    New-Item -ItemType Directory -Force -Path $docsFolder
    # Clear doc folder 
    Remove-Item -Path "$($docsFolder)\*" -Force -Recurse
}

function Update-Doc {    
    Clear-Docs
	Update-ReadmeFile
    Generate-ImagingApiDoc
    Generate-ModelsDoc
}

Export-ModuleMember -Function 'Update-Doc'
