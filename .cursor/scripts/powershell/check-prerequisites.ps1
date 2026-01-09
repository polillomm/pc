#!/usr/bin/env pwsh

# Consolidated prerequisite checking script (PowerShell)
#
# This script provides unified prerequisite verification for the Spec-Driven Development workflow with AI,
# using Domain-Driven Development and Clean Architecture as the repository framework.
#
# Usage: ./check-prerequisites.ps1 [OPTIONS]
#
# OPTIONS:
# -Help, -h 	Show this help message
# -ProjectPath 	Path to the project
# -Silent 		Do not output any message
# -Overwrite 	Overwrite the existing directory

[CmdletBinding()]
param(
	[switch]$Help = $false,
	[string]$ProjectPath = (Get-Location).Path,
	[switch]$Silent = $false,
	[switch]$Overwrite = $false
)

. "$PSScriptRoot/utils.ps1"

if ($Help) {
	Write-Log "Usage: check-prerequisites.ps1 [OPTIONS]

Consolidated verification of the prerequisites for the AI-Assisted Spec-Driven Development workflow.

Manages the creation of the necessary directories and files to ensure that the architecture complies
with the principles of Domain-Driven Development + Clean Architecture.

OPTIONS:
  -Help, -h     Show this help message
  -ProjectPath  Path to the project (default: current directory)
  -Silent       Do not output any message (default: false)
  -Overwrite    Overwrite the existing directory (default: false)"
	exit 0
}

if (-not (Test-Path $ProjectPath)) {
	Write-Log "❌ Project path does not exist: $ProjectPath" -IsError
}

$projectRootPath = Resolve-Path $ProjectPath
$srcPath = Join-Path $projectRootPath "src"

if (Test-Path $srcPath) {
	$srcContent = Get-ChildItem $srcPath -Force | Where-Object { $_.Name -notin @('.gitkeep') }
    
	if ($srcContent.Count -gt 0 -and -not $Overwrite) {
		Write-Log "Cannot proceed! Source directory already contains content.`nUse -Overwrite to override, or remove content manually." -IsError
	}

	Write-Log "⚠️ Deleting existing source directory content...`n" "Yellow"
	Remove-Item $srcPath -Recurse -Force
}

Write-Log "🚀 Setting up repository structure..." "Magenta"

if (-not (Test-Path $srcPath)) {
	New-Item -ItemType Directory -Path $srcPath -Force | Out-Null
	Write-Log "  📁 Source directory created successfully!" "Green"
}
else {
	Write-Log "  📁 Source directory already exists!" "Yellow"
}

foreach ($layerName in @("Domain", "Infra", "Presentation")) {
	$layerPath = Join-Path $srcPath $layerName.ToLower()
	
	if (-not (Test-Path $layerPath)) {
		New-Item -ItemType Directory -Path $layerPath -Force | Out-Null
		Write-Log "  📐 $layerName layer created successfully!" "Green"
	}
 else {
		Write-Log "  📐 $layerName layer already exists!" "Yellow"
	}
}

$domainPath = Join-Path $srcPath "domain"
$domainSubdirs = [ordered]@{
	"dto"         = "# DTOs (Data Transfer Objects)
Classes for data transfer between layers. Mutable properties (not readonly). 
Can represent entities or simple data transit between layers."
	"entity"      = "# Entities
Immutable classes (readonly properties) typically mapped to database models.
Guarantees data reliability - cannot be altered after creation."
	"repository"  = "# Repository Interfaces
Dependency injection interfaces for data access. 
NO technology-specific names or methods (no DB, ORM, HTTP references)."
	"useCase"     = "# Use Cases
Business rule executors. Consume repository interfaces, transit DTOs.
Orchestrate domain logic and validations."
	"valueObject" = "# Value Objects
Immutable domain primitives. ONLY these can accept 'unknown' values for conversion.
Prevents repositories from using raw primitives without prior validation."
}

foreach ($subdir in $domainSubdirs.Keys) {
	$subdirPath = Join-Path $domainPath $subdir
	New-Item -ItemType Directory -Path $subdirPath -Force | Out-Null
	$domainSubdirs[$subdir] | Out-File -FilePath (Join-Path $subdirPath ".gitkeep") -Encoding UTF8
}

Write-Log "`nStructure:" "Cyan"
Write-Log "  📦 Domain" "Cyan"
Write-Log "	 $($PSStyle.Italic)Pure business logic only (entities, value objects, DTOs, use cases).$($PSStyle.Reset)"
Write-Log "	 $($PSStyle.Italic)Immutable, technology-agnostic 'WHAT'.$($PSStyle.Reset)"
Write-Log "  📦 Infrastructure" "Cyan"
Write-Log "	 $($PSStyle.Italic)External dependencies only (databases, APIs, third-party libs).$($PSStyle.Reset)"
Write-Log "	 $($PSStyle.Italic)Technology-specific 'HOW'.$($PSStyle.Reset)"
Write-Log "  📦 Presentation" "Cyan"
Write-Log "	 $($PSStyle.Italic)Entry points only (controllers, routes, agents).$($PSStyle.Reset)"
Write-Log "	 $($PSStyle.Italic)Orchestrates via dependency injection.$($PSStyle.Reset)"

Write-Log "`n🎉 Repository structure ready!" "Magenta"
