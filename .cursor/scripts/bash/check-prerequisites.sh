#!/usr/bin/env bash
#
# Consolidated prerequisite checking script (Bash)
#
# This script provides unified prerequisite verification for the Spec-Driven Development workflow with AI,
# using Domain-Driven Development and Clean Architecture as the repository framework.
#
# Usage: ./check-prerequisites.sh [OPTIONS]
#
# OPTIONS:
# --help, -h           Show this help message
# --project-path, -p   Path to the project
# --silent, -s         Do not output any message
# --overwrite, -o      Overwrite the existing directory

set -e
PROJECT_PATH="$(pwd)"
SILENT=false
OVERWRITE=false

for arg in "$@"; do
    case "$arg" in
        --help|-h)
            cat << 'EOF'
Usage: check-prerequisites.sh [OPTIONS]

Consolidated verification of the prerequisites for the AI-Assisted Spec-Driven Development workflow.

Manages the creation of the necessary directories and files to ensure that the architecture complies
with the principles of Domain-Driven Development + Clean Architecture.

OPTIONS:
  -h, --help        Show this help message
  -p, --project     Path to the project (default: current directory)
  -d, --docs        Path to the docs directory (default: src/docs)
  -s, --silent      Do not output any message (default: false)
  -o, --overwrite   Overwrite the existing directory (default: false)
EOF
            exit 0
            ;;
        --project-path|-p)
            PROJECT_PATH="$2"
            shift
            ;;
        --silent|-s)
            # shellcheck disable=SC2034
            SILENT=true
            shift
            ;;
        --overwrite|-o)
            OVERWRITE=true
            shift
            ;;
        *)
            echo "ERROR: Unknown option '$arg'. Use --help for usage information." >&2
            exit 1
            ;;
    esac
done

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

# Validate project path
[ ! -d "${PROJECT_PATH}" ] && write_log "❌ Project path does not exist: ${PROJECT_PATH}" Red 1

PROJECT_ROOT_PATH="$(cd "${PROJECT_PATH}" && pwd)"
SRC_PATH="${PROJECT_ROOT_PATH}/src"

# Validate src directory
if [ -d "${SRC_PATH}" ]; then
  SRC_CONTENT_COUNT=$(find "${SRC_PATH}" -mindepth 1 -not -name '.gitkeep' | wc -l)
  
  [ "${SRC_CONTENT_COUNT}" -gt 0 ] && [ "${OVERWRITE}" -eq 0 ] && {
    write_log "Cannot proceed! Source directory already contains content." Red 1
    write_log "Use --overwrite to override, or remove content manually." Red 1
  }
  
  write_log "⚠️  Deleting existing source directory content..." Yellow
  rm -rf "${SRC_PATH}"
fi

write_log "🚀 Setting up repository structure..." Magenta

mkdir -p "${SRC_PATH}"
write_log "  📁 Source directory created successfully!" Green

for layer in @("Domain", "Infra", "Presentation"); do
  layer_path="${SRC_PATH}/$(echo "${layer}" | tr '[:upper:]' '[:lower:]')"
  
  if [ ! -d "${layer_path}" ]; then
    mkdir -p "${layer_path}"
    write_log "  📐 ${layer} layer created successfully!" Green
  else
    write_log "  📐 ${layer} layer already exists!" Yellow
  fi
done

# Domain subdirectories with documentation
DOMAIN_PATH="${SRC_PATH}/domain"
declare -A DOMAIN_SUBDIRS=(
  [dto]='# DTOs (Data Transfer Objects)
Classes for data transfer between layers. Mutable properties (not readonly).
Can represent entities or simple data transit between layers.'
  [entity]='# Entities
Immutable classes (readonly properties) typically mapped to database models.
Guarantees data reliability - cannot be altered after creation.'
  [repository]='# Repository Interfaces
Dependency injection interfaces for data access.
NO technology-specific names or methods (no DB, ORM, HTTP references).'
  [useCase]='# Use Cases
Business rule executors. Consume repository interfaces, transit DTOs.
Orchestrate domain logic and validations.'
  [valueObject]='# Value Objects
Immutable domain primitives. ONLY these can accept '"'"'unknown'"'"' values for conversion.
Prevents repositories from using raw primitives without prior validation.'
)

for subdir in "${!DOMAIN_SUBDIRS[@]}"; do
  subdir_path="${DOMAIN_PATH}/${subdir}"
  mkdir -p "${subdir_path}"
  printf '%s\n' "${DOMAIN_SUBDIRS[${subdir}]}" > "${subdir_path}/.gitkeep"
done

# Structure summary
write_log ""
write_log "📁 Structure:" Cyan
write_log "  � Domain" Cyan
write_log "    Pure business logic only (entities, value objects, DTOs, use cases)." Cyan
write_log "    Immutable, technology-agnostic 'WHAT'." Cyan
write_log "  ⚙️ Infrastructure" Cyan
write_log "    External dependencies only (DB, APIs, third-party libs)." Cyan
write_log "    Technology-specific 'HOW'." Cyan
write_log "  � Presentation" Cyan
write_log "    Entry points only (controllers, routes, agents)." Cyan
write_log "    Orchestrates via dependency injection." Cyan
write_log ""
write_log "🎉 Repository structure ready!" Magenta
