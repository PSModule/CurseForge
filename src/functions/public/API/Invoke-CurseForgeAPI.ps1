function Invoke-CurseForgeAPI {
    <#
        .SYNOPSIS
        Call the CurseForge API directly.

        .DESCRIPTION
        Sends a request to any CurseForge API endpoint. Useful for endpoints that are not yet
        wrapped by a dedicated function, or for accessing new API endpoints as they are released.
        GET requests are automatically paginated unless -NoPagination is specified.

        .EXAMPLE
        Invoke-CurseForgeAPI -Endpoint '/v1/games'

        Returns the raw data array for all games.

        .EXAMPLE
        Invoke-CurseForgeAPI -Endpoint '/v1/games/432/versions'

        Returns all versions for game 432.

        .EXAMPLE
        Invoke-CurseForgeAPI -Endpoint '/v1/mods/search' -Body @{ gameId = 432; searchFilter = 'jei' }

        Searches for mods matching 'jei' on game 432.

        .EXAMPLE
        Invoke-CurseForgeAPI -Endpoint '/v1/mods' -Method Post -Body @{ modIds = @(238222, 60089) } -NoPagination

        POSTs to the bulk mods endpoint and returns the result without pagination.

        .INPUTS
        None.

        .OUTPUTS
        [object]

        .NOTES
        Full API reference: https://docs.curseforge.com/
        Requires an active CurseForge connection via Connect-CurseForge.

        .LINK
        https://psmodule.io/CurseForge/Functions/API/Invoke-CurseForgeAPI/
    #>
    [OutputType([object])]
    [CmdletBinding()]
    param(
        # The API endpoint path, e.g. '/v1/games' or '/v1/mods/search'.
        [Parameter(Mandatory)]
        [string] $Endpoint,

        # The HTTP method to use. Defaults to GET.
        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod] $Method = 'Get',

        # Optional request body. Serialized to JSON automatically.
        [Parameter()]
        [hashtable] $Body,

        # Skip automatic pagination and return only the first page of results.
        [Parameter()]
        [switch] $NoPagination
    )

    begin {
        $context = Resolve-CurseForgeContext
    }

    process {
        $invokeAPISplat = @{
            Context      = $context
            Endpoint     = $Endpoint
            Method       = $Method
            NoPagination = $NoPagination
        }

        if ($Body) {
            $invokeAPISplat.Body = $Body
        }

        Invoke-CurseForgeAPI @invokeAPISplat
    }

    end {}
}
