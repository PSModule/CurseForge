#Requires -Modules @{ ModuleName = 'Context'; ModuleVersion = '8.0.0'; MaximumVersion = '8.999.999' }

function Disconnect-CurseForge {
    <#
        .SYNOPSIS
        Disconnect from the CurseForge API and remove stored credentials.

        .DESCRIPTION
        Removes the stored CurseForge context from the vault, clearing all persisted credentials.

        .EXAMPLE
        Disconnect-CurseForge

        Removes the stored CurseForge credentials.

        .INPUTS
        None.

        .OUTPUTS
        None.

        .NOTES
        This removes the context from the PSModule.CurseForge vault.

        .LINK
        https://psmodule.io/CurseForge/Functions/Auth/Disconnect-CurseForge/
    #>
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess)]
    param()

    begin {}

    process {
        $contextName = $script:CurseForge.ContextVault

        if ($PSCmdlet.ShouldProcess($contextName, 'Remove CurseForge context')) {
            Remove-Context -ID $contextName
            $script:CurseForge.Config = $null
        }
    }

    end {}
}
