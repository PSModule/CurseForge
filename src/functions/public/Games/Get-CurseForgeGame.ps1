function Get-CurseForgeGame {
    <#
        .SYNOPSIS
        Get games from the CurseForge API.

        .DESCRIPTION
        Retrieves all available games or a single game by ID from the CurseForge API.

        .EXAMPLE
        Get-CurseForgeGame

        Lists all games available to the API key.

        .EXAMPLE
        Get-CurseForgeGame -Id 432

        Gets a single game by its unique ID.

        .INPUTS
        None.

        .OUTPUTS
        [CurseForgeGame]

        .NOTES
        Requires an active CurseForge connection via Connect-CurseForge.

        .LINK
        https://psmodule.io/CurseForge/Functions/Games/Get-CurseForgeGame/
    #>
    [OutputType([CurseForgeGame])]
    [CmdletBinding(DefaultParameterSetName = 'List all games')]
    param(
        # The unique game ID to retrieve.
        [Parameter(Mandatory, ParameterSetName = 'Get a game by ID')]
        [int] $Id
    )

    begin {}

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Get a game by ID' {
                $response = Invoke-CurseForgeAPI -Endpoint "/v1/games/$Id" -NoPagination
                [CurseForgeGame]::new($response)
            }
            'List all games' {
                $response = Invoke-CurseForgeAPI -Endpoint '/v1/games'
                foreach ($game in $response) {
                    [CurseForgeGame]::new($game)
                }
            }
        }
    }

    end {}
}
