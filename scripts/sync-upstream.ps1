<#
.SYNOPSIS
    Syncs Zeus repository with the upstream GymMane repository (InlitX/GymMane).
.DESCRIPTION
    Fetches the latest upstream commits, tags, and merges upstream/main into local main,
    then optionally guides syncing feature/google-drive.
#>

[CmdletBinding()]
param (
    [string]$UpstreamUrl = "https://github.com/InlitX/GymMane.git"
)

Write-Host "=== Zeus Upstream Synchronizer ===" -ForegroundColor Cyan

# 1. Verify / Configure remote
$remotes = git remote
if ($remotes -notcontains "upstream") {
    Write-Host "Adding upstream remote: $UpstreamUrl" -ForegroundColor Yellow
    git remote add upstream $UpstreamUrl
} else {
    Write-Host "Upstream remote found." -ForegroundColor Green
}

# 2. Fetch upstream
Write-Host "Fetching latest changes from upstream..." -ForegroundColor Cyan
git fetch upstream --tags

# 3. Check commits
$aheadCount = (git rev-list --count main..upstream/main).Trim()
Write-Host "Upstream/main has $aheadCount new commit(s) ahead of local main." -ForegroundColor $(if ($aheadCount -gt 0) { "Yellow" } else { "Green" })

if ($aheadCount -eq "0") {
    Write-Host "Zeus is already up to date with upstream/main!" -ForegroundColor Green
    exit 0
}

# 4. Prompt to merge
$reply = Read-Host "Would you like to merge upstream/main into local main now? (y/N)"
if ($reply -eq 'y' -or $reply -eq 'Y') {
    git checkout main
    Write-Host "Merging upstream/main into main..." -ForegroundColor Cyan
    git merge upstream/main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Merge successful! Running unit tests..." -ForegroundColor Green
        flutter test test/accent_color_test.dart test/tools_calculation_test.dart test/exercise_categories_test.dart
        
        Write-Host "`nTo update feature/google-drive with these changes, run:" -ForegroundColor Yellow
        Write-Host "  git checkout feature/google-drive" -ForegroundColor White
        Write-Host "  git merge main" -ForegroundColor White
    } else {
        Write-Host "Merge conflict detected. Please resolve conflicts, commit, and then merge into feature/google-drive." -ForegroundColor Red
    }
}
