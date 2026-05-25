Describe 'CurseForge Module' {
    BeforeAll {
        $modulePath = Split-Path -Parent $PSScriptRoot
        $srcPath = Join-Path $modulePath 'src'

        # Dot-source enums first (order matters for class dependencies)
        Get-ChildItem -Path (Join-Path $srcPath 'enums') -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }

        # Dot-source classes
        Get-ChildItem -Path (Join-Path $srcPath 'classes') -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }

        # Dot-source variables
        Get-ChildItem -Path (Join-Path $srcPath 'variables') -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }

        # Dot-source private functions
        Get-ChildItem -Path (Join-Path $srcPath 'functions/private') -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }

        # Dot-source public functions
        Get-ChildItem -Path (Join-Path $srcPath 'functions/public') -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }
    }

    Context 'CurseForgeContext class' {
        It 'Creates a context with Name and ApiKey' {
            $key = ConvertTo-SecureString 'test-key' -AsPlainText -Force
            $context = [CurseForgeContext]::new('TestContext', $key)
            $context.Name | Should -Be 'TestContext'
            $context.ApiBaseUri | Should -Be 'https://api.curseforge.com'
        }

        It 'Creates a context with AuthorToken' {
            $key = ConvertTo-SecureString 'test-key' -AsPlainText -Force
            $token = ConvertTo-SecureString 'test-token' -AsPlainText -Force
            $context = [CurseForgeContext]::new('TestContext', $key, $token)
            $context.AuthorToken | Should -Not -BeNullOrEmpty
        }
    }

    Context 'CurseForgeGame class' {
        It 'Deserializes a game object from API response' {
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

    Context 'CurseForgeGameVersionType class' {
        It 'Deserializes a version type object from API response' {
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

    Context 'Resolve-CurseForgeContext' {
        It 'Throws when no context is established' {
            $script:CurseForge.Config = $null
            Mock Get-Context { $null }
            { Resolve-CurseForgeContext } | Should -Throw '*Run Connect-CurseForge first*'
        }

        It 'Returns cached context when available' {
            $key = ConvertTo-SecureString 'cached-key' -AsPlainText -Force
            $cachedContext = [CurseForgeContext]::new('Test', $key)
            $script:CurseForge.Config = $cachedContext
            $result = Resolve-CurseForgeContext
            $result | Should -Be $cachedContext
            $script:CurseForge.Config = $null
        }
    }

    Context 'Invoke-CurseForgeAPI pagination' {
        It 'Stops paginating when resultCount is less than pageSize' {
            $key = ConvertTo-SecureString 'test-key' -AsPlainText -Force
            $context = [CurseForgeContext]::new('Test', $key)

            $pageResponse = [pscustomobject]@{
                data       = @(
                    [pscustomobject]@{ id = 1 },
                    [pscustomobject]@{ id = 2 }
                )
                pagination = [pscustomobject]@{
                    index       = 0
                    pageSize    = 50
                    resultCount = 2
                    totalCount  = 2
                }
            }

            Mock Invoke-RestMethod { $pageResponse }

            $results = Invoke-CurseForgeAPI -Context $context -Endpoint '/v1/games'
            $results.Count | Should -Be 2
            Should -Invoke Invoke-RestMethod -Times 1 -Exactly
        }
    }

    Context 'Get-CurseForgeGame' {
        BeforeEach {
            $key = ConvertTo-SecureString 'test-key' -AsPlainText -Force
            $testContext = [CurseForgeContext]::new('Test', $key)
            $script:CurseForge.Config = $testContext
        }

        AfterEach {
            $script:CurseForge.Config = $null
        }

        It 'Returns a list of games' {
            $listResponse = [pscustomobject]@{
                data       = @(
                    [pscustomobject]@{
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
                )
                pagination = [pscustomobject]@{
                    index       = 0
                    pageSize    = 50
                    resultCount = 1
                    totalCount  = 1
                }
            }

            Mock Invoke-RestMethod { $listResponse }

            $games = Get-CurseForgeGame
            $games | Should -HaveCount 1
            $games[0].Name | Should -Be 'Minecraft'
            $games[0] | Should -BeOfType 'CurseForgeGame'
        }

        It 'Returns a single game by ID' {
            $singleResponse = [pscustomobject]@{
                data = [pscustomobject]@{
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
            }

            Mock Invoke-RestMethod { $singleResponse }

            $game = Get-CurseForgeGame -Id 432
            $game.Id | Should -Be 432
            $game | Should -BeOfType 'CurseForgeGame'
        }
    }
}
