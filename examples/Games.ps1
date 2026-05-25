# Connect to the CurseForge API
$apiKey = Read-Host 'Enter your CurseForge API key' -AsSecureString
Connect-CurseForge -ApiKey $apiKey

# List all games
Get-CurseForgeGame

# Get a specific game (Minecraft = 432)
Get-CurseForgeGame -Id 432

# Get game version types
Get-CurseForgeGameVersionType -GameId 432

# Get game versions (V2 with rich data)
Get-CurseForgeGameVersion -GameId 432

# Disconnect when done
Disconnect-CurseForge
