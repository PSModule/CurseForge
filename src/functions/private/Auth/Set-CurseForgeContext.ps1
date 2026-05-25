#Requires -Modules @{ ModuleName = 'Context'; ModuleVersion = '8.0.0'; MaximumVersion = '8.999.999' }

function Set-CurseForgeContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [CurseForgeContext] $Context
    )

    $contextData = @{
        ApiKey     = $Context.ApiKey
        ApiBaseUri = $Context.ApiBaseUri
    }

    if ($Context.AuthorToken) {
        $contextData.AuthorToken = $Context.AuthorToken
    }

    Set-Context -ID $script:CurseForge.ContextVault -Context $contextData
    $script:CurseForge.Config = $Context
}
