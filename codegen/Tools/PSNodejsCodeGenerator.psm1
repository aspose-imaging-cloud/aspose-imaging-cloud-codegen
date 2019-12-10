function Extract-TypeFromRef($ref) {
    return $ref -replace '#/definitions/', ''
}

function Get-ParamDescription($param) {
    return ($param.description -replace "\s+", ' ')
}

function Get-ParameterNotes($param) {
    if ($param.required) {
        return ''
    } else {
        return '[optional]'
    }
}

function Make-LowerFistChar([string] $str)
{
    $lower = $str.toCharArray()[0].tostring().toLower() + $str.remove(0, 1)
    return $lower
}

############################
function Get-NativeMethodCallDoc($method) {
    return "$(ConvertTo-NativeMethodName $method.Value.operationId)($(Get-NativeMethodParametersList $method))"
}
<#
function Get-NativeMethodReturnTypePlane($method) {
    if ($method.Value.responses.'200'.schema.'$ref') {
        return $method.Value.responses.'200'.schema.'$ref' -replace '#/definitions/', ''
    } else {
        return ConvertTo-NativePrimitiveType $method.Value.responses.'200'.schema.type
    }
}
#>
function Get-NativeMethodParametersList($method) {
    $mandatoryParams = @()
    $nullableParams = @()
    foreach ($param in $method.Value.Parameters) {
        $paramDoc = "$($param.name)"
        if ($param.required) {
            $mandatoryParams += $paramDoc
        } else {
            $nullableParams += $paramDoc
        }
    }
    return (($mandatoryParams + $nullableParams) -join ', ')
}

<#
function Get-NativeParameterType($param) {
    $nullableSuffix = ''
    if (!$param.required) {
        $nullableSuffix = '? = nil'
    }
    
    if ($param.schema) { # Parameter is DTO
        if ($param.schema.type -eq 'array') { # Parameter is array of DTO
            return "$(ConvertTo-NativeArray (Extract-TypeFromRef $param.schema.items.'$ref'))"
        } else { # Parameter is single DTO          
            return "$(Extract-TypeFromRef $param.schema.'$ref')$($nullableSuffix)"
        }

    } else { # Parameter is primitive
        if ($param.type -eq 'array') { # Parameter is array of primitives
            return "$(ConvertTo-NativeArray (ConvertTo-NativePrimitiveType $param.items.type))$($nullableSuffix)"
        } else { # Parameter is single primitive
            return "$(ConvertTo-NativePrimitiveType $param.type)$($nullableSuffix)"
        }
    }
}
#>



function Get-NativeMethodParametersTable($method) {
    $mandatoryParams = @()
    $nullableParams = @()
    foreach ($param in $method.Value.Parameters) {
        $paramTableRow = "**$($param.name)** | $(Get-NativeTypeRef $param) | $(Get-ParamDescription $param) | $(Get-ParameterNotes $param)"
        if ($param.required) {
            $mandatoryParams += $paramTableRow
        } else {
            $nullableParams += $paramTableRow
        }
    }
    return ((($mandatoryParams + $nullableParams) -join "`n") + "`n")
}

<#
function Get-NativeMethodParametersTable($method) {
    $ret =''
    foreach ($param in $method.Value.Parameters) {
        $ret += "**$($param.name)** | $(Get-NativeTypeRef $param) | $(Get-ParamDescription $param) | $(Get-ParameterNotes $param)`n"
    }
    return $ret
}
#>

function Get-NativeTypeRef($param) {
    if ($param.schema) { # Parameter is DTO
        if ($param.schema.type -eq 'array') { # Parameter is array of DTO
            return "[**$(ConvertTo-NativeArray (Extract-TypeFromRef $param.schema.items.'$ref'))**]($(Extract-TypeFromRef $param.schema.items.'$ref').md)"
        } else { # Parameter is single DTO          
            return "[**$(Extract-TypeFromRef $param.schema.'$ref')**]($(Extract-TypeFromRef $param.schema.'$ref').md)"
        }

    } elseif ($param.'x-schema') { # Parameter is DTO
        if ($param.'x-schema'.type -eq 'array') { # Parameter is array of DTO
            return "[**$(ConvertTo-NativeArray (Extract-TypeFromRef $param.'x-schema'.items.'$ref'))**]($(Extract-TypeFromRef $param.'x-schema'.items.'$ref').md)"
        } else { # Parameter is single DTO          
            return "[**$(Extract-TypeFromRef $param.'x-schema'.'$ref')**]($(Extract-TypeFromRef $param.'x-schema'.'$ref').md)"
        }

    } else { # Parameter is primitive
        if ($param.type -eq 'array') { # Parameter is array of primitives
            return "**$(ConvertTo-NativeArray  (ConvertTo-NativePrimitiveType $param.items.type))**"
        } else { # Parameter is single primitive
            return "**$(ConvertTo-NativePrimitiveType $param.type)**"
        }
    }
}

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

function Get-NativeClassName([string] $className) {
    return $className
}
#######################################

function Make-LowerFistChar([string] $str)
{
    $lower = $str.toCharArray()[0].tostring().toLower() + $str.remove(0, 1)
    return $lower
}


function ConvertTo-NativePropName([string] $propName) {
    return Make-LowerFistChar $propName
}


function ConvertTo-NativePrimitiveType($rawType) {
    if ($rawType -eq 'integer') {
        return 'number'
    } elseif ($rawType -eq 'file') {
        return 'Buffer'
    }
    return $rawType
}

function ConvertTo-NativeEnum($prop) {
    return $prop
}

function ConvertTo-NativeArray([string]$typeName) {
    return "Array&lt;$($typeName)&gt;"
}

function ConvertTo-NativeMethodName([string] $operationId) {
    return Make-LowerFistChar $operationId
}

function Get-NativePathFromModelDocToSourceFile ($model) { 
    return "../src/models/$(Make-LowerFistChar $model.Name).ts"
}

Export-ModuleMember -Function 'ConvertTo-*'
Export-ModuleMember -Function 'Get-*'