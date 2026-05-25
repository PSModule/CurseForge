function Invoke-CurseForgeAPI {
    [OutputType([object])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [CurseForgeContext] $Context,

        [Parameter(Mandatory)]
        [string] $Endpoint,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod] $Method = 'Get',

        [Parameter()]
        [hashtable] $Body,

        [Parameter()]
        [switch] $NoPagination
    )

    $baseUri = $Context.ApiBaseUri.TrimEnd('/')
    $uri = "$baseUri/$($Endpoint.TrimStart('/'))"

    $apiKeyPlain = [System.Net.NetworkCredential]::new('', $Context.ApiKey).Password

    $headers = @{
        'x-api-key' = $apiKeyPlain
        'Accept'    = 'application/json'
    }

    if ($NoPagination -or $Method -ne 'Get') {
        $invokeApiSplat = @{
            Uri         = $uri
            Method      = $Method
            Headers     = $headers
            ContentType = 'application/json'
        }

        if ($Body) {
            $invokeApiSplat.Body = ($Body | ConvertTo-Json -Depth 10)
        }

        try {
            $response = Invoke-RestMethod @invokeApiSplat
        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $errorMessage = "CurseForge API error [$statusCode] on $Method $Endpoint"
            throw $errorMessage
        }

        if ($null -ne $response.data) {
            return $response.data
        }
        return $response
    }

    # Auto-pagination for GET requests
    $pageSize = $script:CurseForge.DefaultConfig.PageSize
    $index = 0
    $allResults = [System.Collections.Generic.List[object]]::new()

    do {
        $separator = if ($uri.Contains('?')) { '&' } else { '?' }
        $pagedUri = "${uri}${separator}index=${index}&pageSize=${pageSize}"

        $invokeApiSplat = @{
            Uri         = $pagedUri
            Method      = 'Get'
            Headers     = $headers
            ContentType = 'application/json'
        }

        try {
            $response = Invoke-RestMethod @invokeApiSplat
        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $errorMessage = "CurseForge API error [$statusCode] on GET $Endpoint"
            throw $errorMessage
        }

        if ($null -ne $response.data) {
            foreach ($item in $response.data) {
                $allResults.Add($item)
            }
        }

        $pagination = $response.pagination
        if (-not $pagination) {
            break
        }

        $resultCount = $pagination.resultCount
        $index += $pageSize

        if ($resultCount -lt $pageSize) {
            break
        }

        if (($index + $pageSize) -gt 10000) {
            break
        }
    } while ($true)

    $allResults
}
