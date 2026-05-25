$script:CurseForge = [pscustomobject]@{
    ContextVault  = 'PSModule.CurseForge'
    DefaultConfig = @{
        ApiBaseUri = 'https://api.curseforge.com'
        ApiVersion = 'v1'
        PageSize   = 50
    }
    Config        = $null
}
