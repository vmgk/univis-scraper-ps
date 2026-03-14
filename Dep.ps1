<#
.SYNOPSIS
    Here is script small description.

.DESCRIPTION
============================================
    Here is script long text description. 
    Paramenter -help this show text also.
    All Departments BFS
    Ver 0.35a
    Clean + Safe + Tree View + Statistics
============================================

.EXAMPLE 
    ./Dep.ps1 -output Filename.csv
    This run script and save CSV table to Filename.csv

.PARAMETER output
    Path to CSV filename for output 
#>

param (
    [string]$output,
    [switch]$ver,
    [switch]$help
    )

    # 1. Version (-ver)
if ($ver) {
    Write-Host "Script version: 0.35a"
    exit # stop script here
}

if ($help) {
    Get-Help $PSCommandPath
    exit # stop script here
}

# 3. variable filename
if ($output) {
    $filename = $output
    Write-Host "Output will be in the filename.csv written: $filename"
} else {
    Write-Host "Parameter -output no used."
}

if (-not $output) {
    $output = "All_Departments_BFS.csv"
}

#Start
Write-Host "Script started..." -ForegroundColor Green

# URL to scrape - please update this variables before running
$baseUrl = "https://INSERT_TARGET_URL_HERE"
$rootUrl = "https://INSERT_TARGET_ROOT_URL_HERE"


$visitedUrls = @{}
$visitedDirs = @{}

$queue   = New-Object System.Collections.Queue
$results = @()

# Add root manually
$queue.Enqueue([PSCustomObject]@{
    Url   = $rootUrl
    Dept  = "Telefonverzeichnis"
    Dir   = ""
    Level = 0
})

while ($queue.Count -gt 0) {

    $current = $queue.Dequeue()
    $url     = $current.Url
    $dept    = $current.Dept
    $dir     = $current.Dir
    $level   = $current.Level

    # Prevent URL cycles
    if ($visitedUrls.ContainsKey($url)) { continue }
    $visitedUrls[$url] = $true

    # Prevent DIR duplicates
    if ($visitedDirs.ContainsKey($dir)) { continue }
    $visitedDirs[$dir] = $true

    Write-Host "Processing Level $level -> $dept" -ForegroundColor Cyan

    # Save result
    $results += [PSCustomObject]@{
        Level = $level
        Dept  = $dept
        Dir   = $dir
        URL   = $url
    }

    try {
        Start-Sleep -Milliseconds 300
        $page = Invoke-WebRequest -Uri $url
        $html = $page.Content
    }
    catch {
        Write-Warning "Failed: $url"
        continue
    }

    # Find child department links
    $linkMatches = [regex]::Matches(
        $html,
        '<a href="form\?dsc=anew/tel&amp;dir=([^"&]+)[^"]*">(.*?)</a>',
        'Singleline'
    )

    foreach ($match in $linkMatches) {

        $childDir  = $match.Groups[1].Value
        $childName = ($match.Groups[2].Value -replace '<.*?>','').Trim()

        # Filtering
        if ([string]::IsNullOrWhiteSpace($childName)) { continue }
        if ($childName -match "Semester|freischalten|Zurück|Übersicht|Back|Home") { continue }
        if ($visitedDirs.ContainsKey($childDir)) { continue }

        $childUrl = "$baseUrl" + "form?dsc=anew/tel&dir=$childDir&anonymous=1&ref=tel&sem=2026s"
        if ($visitedUrls.ContainsKey($childUrl)) { continue }

        $queue.Enqueue([PSCustomObject]@{
            Url   = $childUrl
            Dept  = $childName
            Dir   = $childDir
            Level = $level + 1
        })
    }
}

# Remove duplicates (final safety)
$results = $results | Sort-Object URL -Unique

# -------------------------------
# TREE VISUALIZATION
# -------------------------------

Write-Host ""
Write-Host "========== DEPARTMENT TREE ==========" -ForegroundColor Yellow

foreach ($r in ($results | Sort-Object Level, Dept)) {

    $indent = " " * ($r.Level * 4)
    Write-Host ($indent + "|-- " + $r.Dept)
}

# -------------------------------
# STATISTICS
# -------------------------------

$totalCount = $results.Count
$maxLevel   = ($results | Measure-Object -Property Level -Maximum).Maximum

Write-Host ""
Write-Host "========== STATISTICS ==========" -ForegroundColor Yellow
Write-Host "Total Departments Found: $totalCount" -ForegroundColor Green
Write-Host "Maximum Depth Level:     $maxLevel" -ForegroundColor Green

# Export CSV
#$results | Export-Csv "All_Departments_BFS.csv" -NoTypeInformation -Encoding UTF8
$results | Export-Csv "$output" -NoTypeInformation -Encoding UTF8

Write-Host ""
#Write-Host "Finished. All_Departments_BFS.csv created." -ForegroundColor Green
Write-Host "$output created." -ForegroundColor Green
