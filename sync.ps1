<#
Copy this repo's skills into a project so Claude Code loads them there.

    .\sync.ps1 C:\path\to\project

Copies every skill in .agents\skills into <project>\.claude\skills\<name>,
replacing what was there. Skills the project has that this repo does not
(project-local skills) are left alone. Writes .skills-version with the
commit this copy came from. Re-run after any change here.
#>
param([Parameter(Mandatory)][string]$Project)

$src = Join-Path $PSScriptRoot '.agents\skills'
$dst = Join-Path (Resolve-Path $Project) '.claude\skills'
if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst | Out-Null }

$names = Get-ChildItem $src -Directory | ForEach-Object Name
foreach ($n in $names) {
    $target = Join-Path $dst $n
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    Copy-Item (Join-Path $src $n) $target -Recurse
}

$hash = git -C $PSScriptRoot rev-parse --short HEAD
$dirty = if (git -C $PSScriptRoot status --porcelain -- .agents/skills) { ' (with uncommitted changes)' } else { '' }
"$hash$dirty  $(Get-Date -Format s)" | Set-Content (Join-Path $dst '.skills-version')

"Synced $($names.Count) skills to $dst at $hash$dirty"
