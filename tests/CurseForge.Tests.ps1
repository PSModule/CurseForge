[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSReviewUnusedParameter', '',
    Justification = 'Required for Pester tests'
)]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Required for Pester tests'
)]
[CmdletBinding()]
param()

BeforeAll {
    # TEST_USER_PAT is the slot Process-PSModule uses to forward CURSEFORGE_API_KEY into the test job.
    if ($env:TEST_USER_PAT -and -not $env:CURSEFORGE_API_KEY) {
        $env:CURSEFORGE_API_KEY = $env:TEST_USER_PAT
    }
}

Describe 'CurseForge' {
    Describe 'CurseForgeContext' {
        Context 'CurseForgeContext - create with Name and ApiKey' {
            It 'CurseForgeContext - creates a context with Name and ApiKey' {
                $key = ConvertTo-SecureString 'test-key' -AsPlainText -Force
                $context = [CurseForgeContext]::new('TestContext', $key)
                $context.Name | Should -Be 'TestContext'
                $context.ApiBaseUri | Should -Be 'https://api.curseforge.com'
            }
        }

        Context 'CurseForgeContext - create with AuthorToken' {
            It 'CurseForgeContext - creates a context with AuthorToken' {
                $key = ConvertTo-SecureString 'test-key' -AsPlainText -Force
                $token = ConvertTo-SecureString 'test-token' -AsPlainText -Force
                $context = [CurseForgeContext]::new('TestContext', $key, $token)
                $context.AuthorToken | Should -Not -BeNullOrEmpty
            }
        }
    }

    Describe 'CurseForgeGame' {
        Context 'CurseForgeGame - deserialize from API response' {
            It 'CurseForgeGame - deserializes a game object from API response' {
                $rawGame = [pscustomobject]@{
                    id           = 432
                    name         = 'Minecraft'
                    slug         = 'minecraft'
                    dateModified = '2024-01-15T10:30:00Z'
                    assets       = [pscustomobject]@{
                        iconUrl  = 'https://example.com/icon.png'
                        tileUrl  = 'https://example.com/tile.png'
                        coverUrl = 'https://example.com/cover.png'
                    }
                    status       = 6
                    apiStatus    = 2
                }

                $game = [CurseForgeGame]::new($rawGame)
                $game.Id | Should -Be 432
                $game.Name | Should -Be 'Minecraft'
                $game.Slug | Should -Be 'minecraft'
                $game.Status | Should -Be 'Live'
                $game.ApiStatus | Should -Be 'Public'
                $game.Assets.IconUrl | Should -Be 'https://example.com/icon.png'
            }
        }
    }

    Describe 'CurseForgeGameVersionType' {
        Context 'CurseForgeGameVersionType - deserialize from API response' {
            It 'CurseForgeGameVersionType - deserializes a version type object from API response' {
                $rawVersionType = [pscustomobject]@{
                    id         = 1
                    gameId     = 432
                    name       = 'Java'
                    slug       = 'java'
                    isSyncable = $true
                    status     = 1
                }

                $versionType = [CurseForgeGameVersionType]::new($rawVersionType)
                $versionType.Id | Should -Be 1
                $versionType.GameId | Should -Be 432
                $versionType.Name | Should -Be 'Java'
                $versionType.IsSyncable | Should -BeTrue
                $versionType.Status | Should -Be 'Normal'
            }
        }
    }

    Describe 'Resolve-CurseForgeContext' {
        Context 'Resolve-CurseForgeContext - throws when no context is established' {
            It 'Resolve-CurseForgeContext - throws when no context is established' {
                $script:CurseForge.Config = $null
                { Resolve-CurseForgeContext } | Should -Throw '*Run Connect-CurseForge first*'
            }
        }

        Context 'Resolve-CurseForgeContext - returns cached context' {
            It 'Resolve-CurseForgeContext - returns cached context when available' {
                $key = ConvertTo-SecureString 'cached-key' -AsPlainText -Force
                $cachedContext = [CurseForgeContext]::new('Test', $key)
                $script:CurseForge.Config = $cachedContext
                $result = Resolve-CurseForgeContext
                $result | Should -Be $cachedContext
                $script:CurseForge.Config = $null
            }
        }
    }

    Describe 'Get-CurseForgeGame' {
        BeforeEach {
            if ($env:CURSEFORGE_API_KEY) {
                Connect-CurseForge
            }
        }

        AfterEach {
            $script:CurseForge.Config = $null
        }

        Context 'Get-CurseForgeGame - list all games' {
            It 'Get-CurseForgeGame - returns a list of games' -Skip:(-not $env:CURSEFORGE_API_KEY) {
                $games = Get-CurseForgeGame
                $games | Should -Not -BeNullOrEmpty
                $games[0].GetType().Name | Should -Be 'CurseForgeGame'
            }
        }

        Context 'Get-CurseForgeGame - get game by ID' {
            It 'Get-CurseForgeGame - returns a single game by ID' -Skip:(-not $env:CURSEFORGE_API_KEY) {
                $game = Get-CurseForgeGame -Id 432
                $game.Id | Should -Be 432
                $game.GetType().Name | Should -Be 'CurseForgeGame'
            }
        }
    }

    Describe 'Get-CurseForgeGameVersionType' {
        BeforeEach {
            if ($env:CURSEFORGE_API_KEY) {
                Connect-CurseForge
            }
        }

        AfterEach {
            $script:CurseForge.Config = $null
        }

        Context 'Get-CurseForgeGameVersionType - list version types by game ID' {
            It 'Get-CurseForgeGameVersionType - returns version types for a game' -Skip:(-not $env:CURSEFORGE_API_KEY) {
                $versionTypes = Get-CurseForgeGameVersionType -GameId 432
                $versionTypes | Should -Not -BeNullOrEmpty
                $versionTypes[0].GetType().Name | Should -Be 'CurseForgeGameVersionType'
            }
        }
    }

    Describe 'Get-CurseForgeGameVersion' {
        BeforeEach {
            if ($env:CURSEFORGE_API_KEY) {
                Connect-CurseForge
            }
        }

        AfterEach {
            $script:CurseForge.Config = $null
        }

        Context 'Get-CurseForgeGameVersion - list versions by game ID' {
            It 'Get-CurseForgeGameVersion - returns versions for a game' -Skip:(-not $env:CURSEFORGE_API_KEY) {
                $versions = Get-CurseForgeGameVersion -GameId 432
                $versions | Should -Not -BeNullOrEmpty
                $versions[0].Type | Should -Not -BeNullOrEmpty
            }
        }
    }

    Describe 'Invoke-CurseForgeAPI' {
        BeforeEach {
            if ($env:CURSEFORGE_API_KEY) {
                Connect-CurseForge
            }
        }

        AfterEach {
            $script:CurseForge.Config = $null
        }

        Context 'Invoke-CurseForgeAPI - GET endpoint' {
            It 'Invoke-CurseForgeAPI - returns raw data from a GET endpoint' -Skip:(-not $env:CURSEFORGE_API_KEY) {
                $result = Invoke-CurseForgeAPI -Endpoint '/v1/games'
                $result | Should -Not -BeNullOrEmpty
            }
        }

        Context 'Invoke-CurseForgeAPI - GET endpoint with NoPagination' {
            It 'Invoke-CurseForgeAPI - returns raw data without pagination' -Skip:(-not $env:CURSEFORGE_API_KEY) {
                $result = Invoke-CurseForgeAPI -Endpoint '/v1/games' -NoPagination
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}
