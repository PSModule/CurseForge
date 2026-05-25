class CurseForgeGame {
    [int] $Id
    [string] $Name
    [string] $Slug
    [datetime] $DateModified
    [CurseForgeGameAssets] $Assets
    [CurseForgeGameStatus] $Status
    [CurseForgeGameApiStatus] $ApiStatus

    CurseForgeGame() {}

    CurseForgeGame([object] $Object) {
        $this.Id = $Object.id
        $this.Name = $Object.name
        $this.Slug = $Object.slug
        $this.DateModified = $Object.dateModified
        $this.Assets = [CurseForgeGameAssets]::new($Object.assets)
        $this.Status = [CurseForgeGameStatus]$Object.status
        $this.ApiStatus = [CurseForgeGameApiStatus]$Object.apiStatus
    }
}
