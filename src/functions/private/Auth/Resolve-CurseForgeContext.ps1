#Requires -Modules @{ ModuleName = 'Context'; ModuleVersion = '8.0.0'; MaximumVersion = '8.999.999' }

function Resolve-CurseForgeContext {
    [OutputType([CurseForgeContext])]
    [CmdletBinding()]
    param()

    if ($script:CurseForge.Config) {
        return $script:CurseForge.Config
    }

    $contextData = Get-Context -ID $script:CurseForge.ContextVault

    if (-not $contextData) {
        throw 'No CurseForge context found. Run Connect-CurseForge first.'
    }

    $context = [CurseForgeContext]::new()
    $context.Name = $script:CurseForge.ContextVault
    $context.ApiKey = $contextData.ApiKey
    $context.ApiBaseUri = $contextData.ApiBaseUri

    if ($contextData.AuthorToken) {
        $context.AuthorToken = $contextData.AuthorToken
    }

    $script:CurseForge.Config = $context
    $context
}
