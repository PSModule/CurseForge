# CurseForge

A PowerShell module that interacts with the [CurseForge API](https://docs.curseforge.com/rest-api/).

Provides ergonomic commands for querying games, mods, files, categories, fingerprints, and Minecraft-specific data from the CurseForge Core API, with planned support for the Upload API.

## Prerequisites

- PowerShell 7.0 or later
- A CurseForge API key from the [CurseForge for Studios Console](https://console.curseforge.com/)
- The [PSModule framework](https://github.com/PSModule/Process-PSModule) for building, testing and publishing the module

## Installation

```powershell
Install-PSResource -Name CurseForge
Import-Module -Name CurseForge
```

## Usage

### Connect to the API

```powershell
$apiKey = Read-Host 'API Key' -AsSecureString
Connect-CurseForge -ApiKey $apiKey
```

### List all games

```powershell
Get-CurseForgeGame
```

### Get a specific game

```powershell
Get-CurseForgeGame -Id 432
```

### Get game version types

```powershell
Get-CurseForgeGameVersionType -GameId 432
```

### Get game versions

```powershell
Get-CurseForgeGameVersion -GameId 432
```

### Disconnect

```powershell
Disconnect-CurseForge
```

## Documentation

For more examples, see the [examples](examples) folder.

Use `Get-Command -Module CurseForge` to discover available commands and `Get-Help <CommandName> -Examples` for usage details.

## Contributing

Coder or not, you can contribute to the project! We welcome all contributions.

### For Users

If you don't code, you still sit on valuable information that can make this project even better. If you experience that the
product does unexpected things, throw errors or is missing functionality, you can help by submitting bugs and feature requests.
Please see the issues tab on this project and submit a new issue that matches your needs.

### For Developers

If you do code, we'd love to have your contributions. Please read the [Contribution guidelines](CONTRIBUTING.md) for more information.
You can either help by picking up an existing issue or submit a new one if you have an idea for a new feature or improvement.

## Acknowledgements

- [CurseForge API Documentation](https://docs.curseforge.com/rest-api/)
- [PSModule Framework](https://github.com/PSModule/Process-PSModule)
