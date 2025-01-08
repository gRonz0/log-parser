echo "<#
.SYNOPSIS
    Advanced Log Parser Script

.DESCRIPTION
    This script parses log files and extracts useful information based on filters such as date, severity, and keyword.

.PARAMETER LogFilePath
    The path to the log file to be parsed.

.PARAMETER StartDate
    The start date for filtering logs (optional).

.PARAMETER EndDate
    The end date for filtering logs (optional).

.PARAMETER Severity
    The severity level to filter logs (optional).

.PARAMETER Keyword
    A keyword to search for in the logs (optional).

.EXAMPLE
    .\logParser.ps1 -LogFilePath \"C:\logs\example.log\" -StartDate \"2023-01-01\" -EndDate \"2023-01-31\" -Severity \"ERROR\" -Keyword \"Exception\"

.NOTES
    Author: Your Name
    Date: Today's Date
#>

param (
    [string]$LogFilePath,
    [datetime]$StartDate,
    [datetime]$EndDate,
    [string]$Severity,
    [string]$Keyword
)

function Parse-Log {
    param (
        [string]$LogFilePath,
        [datetime]$StartDate,
        [datetime]$EndDate,
        [string]$Severity,
        [string]$Keyword
    )

    if (-Not (Test-Path $LogFilePath)) {
        Write-Error \"Log file not found: $LogFilePath\"
        return
    }

    $logContent = Get-Content -Path $LogFilePath
    foreach ($line in $logContent) {
        $includeLine = $true

        if ($StartDate -and $EndDate) {
            $datePattern = \"\d{4}-\d{2}-\d{2}\"
            if ($line -match $datePattern) {
                $logDate = [datetime]::ParseExact($matches[0], \"yyyy-MM-dd\", $null)
                if ($logDate -lt $StartDate -or $logDate -gt $EndDate) {
                    $includeLine = $false
                }
            }
        }

        if ($Severity -and $line -notmatch $Severity) {
            $includeLine = $false
        }

        if ($Keyword -and $line -notmatch $Keyword) {
            $includeLine = $false
        }

        if ($includeLine) {
            Write-Output $line
        }
    }
}

Parse-Log -LogFilePath $LogFilePath -StartDate $StartDate -EndDate $EndDate -Severity $Severity -Keyword $Keyword" > logParser.ps1