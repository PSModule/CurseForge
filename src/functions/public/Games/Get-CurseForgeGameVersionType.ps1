function Get-CurseForgeGameVersionType {
    <#
        .SYNOPSIS
        Get game version types for a specific game.

        .DESCRIPTION
        Retrieves all available version types of the specified game from the CurseForge API.

        .EXAMPLE
        Get-CurseForgeGameVersionType -GameId 432

        Gets all version types for game ID 432.

        .INPUTS
        None.

        .OUTPUTS
        [CurseForgeGameVersionType]

        .NOTES
        Requires an active CurseForge connection via Connect-CurseForge.

        .LINK
        https://psmodule.io/CurseForge/Functions/Games/Get-CurseForgeGameVersionType/
    #>
    [OutputType([CurseForgeGameVersionType])]
    [CmdletBinding()]
    param(
        # The unique game ID to get version types for.
        [Parameter(Mandatory)]
        [int] $GameId
    )

    begin {}

    process {
        $response = Invoke-CurseForgeAPI -Endpoint "/v1/games/$GameId/version-types" -NoPagination
        foreach ($versionType in $response) {
            [CurseForgeGameVersionType]::new($versionType)
        }
    }

    end {}
}
