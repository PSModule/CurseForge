class CurseForgeGameVersionType {
    [int] $Id
    [int] $GameId
    [string] $Name
    [string] $Slug
    [bool] $IsSyncable
    [CurseForgeGameVersionTypeStatus] $Status

    CurseForgeGameVersionType() {}

    CurseForgeGameVersionType([object] $Object) {
        $this.Id = $Object.id
        $this.GameId = $Object.gameId
        $this.Name = $Object.name
        $this.Slug = $Object.slug
        $this.IsSyncable = $Object.isSyncable
        $this.Status = [CurseForgeGameVersionTypeStatus]$Object.status
    }
}
