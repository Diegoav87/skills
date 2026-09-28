<#
Copy this repo's skills into a project so Claude Code loads them there.

    .\sync.ps1 C:\path\to\project

Mirrors .agents\skills into <project>\.claude\skills: adds new skills,
replaces existing ones, and removes skills this script installed earlier
that no longer exist here. Skills the project has that never came from this
repo (project-local skills) are left alone. Writes .skills-version with the
source commit and the list of managed skills. Re-run after any change here.
#>
param([Parameter(Mandatory)][string]$Project)

$src = Join-Path $PSScriptRoot '.agents\skills'
$dst = Join-Path (Resolve-Path $Project) '.claude\skills'
if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst | Out-Null }
$stamp = Join-Path $dst '.skills-version'

# Skills installed by a previous run, so we know which ones we may delete.
$previous = @()
if (Test-Path $stamp) {
    $previous = Get-Content $stamp | Select-Object -Skip 1 | Where-Object { $_ }
}

$names = Get-ChildItem $src -Directory | ForEach-Object Name

$removed = @()
foreach ($n in $previous) {
    if ($n -notin $names) {
        $target = Join-Path $dst $n
        if (Test-Path $target) { Remove-Item $target -Recurse -Force; $removed += $n }
    }
}

foreach ($n in $names) {
    $target = Join-Path $dst $n
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    Copy-Item (Join-Path $src $n) $target -Recurse
}

$hash = git -C $PSScriptRoot rev-parse --short HEAD
$dirty = if (git -C $PSScriptRoot status --porcelain -- .agents/skills) { ' (with uncommitted changes)' } else { '' }
@("$hash$dirty  $(Get-Date -Format s)") + $names | Set-Content $stamp

$msg = "Synced $($names.Count) skills to $dst at $hash$dirty"
if ($removed) { $msg += "; removed: $($removed -join ', ')" }
$msg
