function Get-CurseForgeContext {
    <#
        .SYNOPSIS
        Retrieve the active CurseForge context.

        .DESCRIPTION
        Returns the currently active CurseForge context containing API credentials and configuration.

        .EXAMPLE
        Get-CurseForgeContext

        Returns the stored CurseForge context.

        .INPUTS
        None.

        .OUTPUTS
        [CurseForgeContext]

        .NOTES
        Returns null if no context has been established via Connect-CurseForge.

        .LINK
        https://psmodule.io/CurseForge/Functions/Auth/Get-CurseForgeContext/
    #>
    [OutputType([CurseForgeContext])]
    [CmdletBinding()]
    param()

    begin {}

    process {
        Resolve-CurseForgeContext
    }

    end {}
}
