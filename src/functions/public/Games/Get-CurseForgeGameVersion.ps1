function Get-CurseForgeGameVersion {
    <#
        .SYNOPSIS
        Get game versions for a specific game.

        .DESCRIPTION
        Retrieves all available versions for each known version type of the specified game
        using the V2 endpoint which returns richer version data including IDs and slugs.

        .EXAMPLE
        Get-CurseForgeGameVersion -GameId 432

        Gets all versions for game ID 432.

        .INPUTS
        None.

        .OUTPUTS
        [pscustomobject]

        .NOTES
        Uses the V2 endpoint (GET /v2/games/{gameId}/versions) for richer version data.

        .LINK
        https://psmodule.io/CurseForge/Functions/Games/Get-CurseForgeGameVersion/
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        # The unique game ID to get versions for.
        [Parameter(Mandatory)]
        [int] $GameId
    )

    begin {
        $context = Resolve-CurseForgeContext
    }

    process {
        $response = Invoke-CurseForgeAPI -Context $context -Endpoint "/v2/games/$GameId/versions" -NoPagination
        foreach ($versionGroup in $response) {
            [pscustomobject]@{
                Type     = $versionGroup.type
                Versions = $versionGroup.versions
            }
        }
    }

    end {}
}
