class CurseForgeGameAssets {
    [string] $IconUrl
    [string] $TileUrl
    [string] $CoverUrl

    CurseForgeGameAssets() {}

    CurseForgeGameAssets([object] $Object) {
        $this.IconUrl = $Object.iconUrl
        $this.TileUrl = $Object.tileUrl
        $this.CoverUrl = $Object.coverUrl
    }
}
