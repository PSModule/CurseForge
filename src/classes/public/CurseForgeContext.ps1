class CurseForgeContext {
    [string] $Name
    [securestring] $ApiKey
    [securestring] $AuthorToken
    [string] $ApiBaseUri

    CurseForgeContext() {
        $this.ApiBaseUri = 'https://api.curseforge.com'
    }

    CurseForgeContext([string] $Name, [securestring] $ApiKey) {
        $this.Name = $Name
        $this.ApiKey = $ApiKey
        $this.ApiBaseUri = 'https://api.curseforge.com'
    }

    CurseForgeContext([string] $Name, [securestring] $ApiKey, [securestring] $AuthorToken) {
        $this.Name = $Name
        $this.ApiKey = $ApiKey
        $this.AuthorToken = $AuthorToken
        $this.ApiBaseUri = 'https://api.curseforge.com'
    }
}
