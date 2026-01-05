#!/usr/bin/env pwsh

# Utils PowerShell functions to be used in the other scripts.

function Write-Log {
    param (
        [string]$Message,
        [string]$ForegroundColor = "White",
        [switch]$IsError = $false
    )

    if ($Silent) {
        return
    }

    if ($IsError) {
        Write-Host "$Message" -ForegroundColor "Red"
        exit 1
    }

    Write-Host $Message -ForegroundColor $ForegroundColor
}