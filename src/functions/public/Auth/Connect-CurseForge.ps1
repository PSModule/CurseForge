function Connect-CurseForge {
    <#
        .SYNOPSIS
        Connect to the CurseForge API and store credentials.

        .DESCRIPTION
        Stores the CurseForge API key (and optionally an Author Token for the Upload API)
        in a named vault via the Context module. The credentials persist across sessions.

        .EXAMPLE
        $key = Read-Host 'API Key' -AsSecureString
        Connect-CurseForge -ApiKey $key

        Connects to the CurseForge Core API using the provided key.

        .EXAMPLE
        $key = Read-Host 'API Key' -AsSecureString
        $token = Read-Host 'Author Token' -AsSecureString
        Connect-CurseForge -ApiKey $key -AuthorToken $token

        Connects with both Core API and Upload API credentials.

        .INPUTS
        None.

        .OUTPUTS
        [CurseForgeContext]

        .NOTES
        The API key is obtained from https://authors-old.curseforge.com/account/api-tokens.
        If the ApiKey parameter is omitted, the value of the CURSEFORGE_API_KEY environment variable is used.

        .LINK
        https://psmodule.io/CurseForge/Functions/Auth/Connect-CurseForge/
    #>
    [OutputType([CurseForgeContext])]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The CurseForge Core API key. If omitted, the CURSEFORGE_API_KEY environment variable is used.
        [Parameter()]
        [securestring] $ApiKey,

        # The CurseForge Upload API author token.
        [Parameter()]
        [securestring] $AuthorToken
    )

    begin {}

    process {
        if (-not $ApiKey) {
            if ($env:CURSEFORGE_API_KEY) {
                $ApiKey = ConvertTo-SecureString $env:CURSEFORGE_API_KEY -AsPlainText -Force
            } else {
                throw 'No API key provided. Pass -ApiKey or set the CURSEFORGE_API_KEY environment variable. ' +
                'Obtain a key from https://authors-old.curseforge.com/account/api-tokens.'
            }
        }

        $contextName = $script:CurseForge.ContextVault

        $context = [CurseForgeContext]::new()
        $context.Name = $contextName
        $context.ApiKey = $ApiKey
        $context.ApiBaseUri = $script:CurseForge.DefaultConfig.ApiBaseUri

        if ($AuthorToken) {
            $context.AuthorToken = $AuthorToken
        }

        if ($PSCmdlet.ShouldProcess($contextName, 'Store CurseForge context')) {
            Set-CurseForgeContext -Context $context
            $context
        }
    }

    end {}
}
