# Cursor Directory ![Version Badge](https://img.shields.io/badge/version-alpha--v1.0.0-blue?style=flat-square)

## Summary
Text here.

## Agents
Text here.

## Commands
Text here.

_*Some commands were inspired by [github/spec-kit](https://github.com/github/spec-kit).*_

## Rules
Overview of all rules organized by responsibility.

_*Some rules were inspired by the `AGENTS.md` from the [goinfinite/tk](https://github.com/goinfinite/tk/blob/main/docs/AGENTS.md).*_ 

### File Structure
| File | Purpose | When Applied | Description |
| -- | -- | -- | -- |
| [`general.mdc`](rules/general.mdc) | Global engineering constraints | All code changes, refactoring, reviews | General engineering rules for this codebase. Apply to scope decisions, ambiguity, libraries. |
| [`architecture.mdc`](rules/architecture.mdc) | DDD + Clean Architecture layers | Domain/use case/infra changes | Architecture and domain constraints. Apply when designing domain models, use cases, infrastructure. |
| [`code-style.mdc`](rules/code-style.mdc) | Formatting and style conventions | All code files | Code style rules. Apply to TypeScript, JavaScript, configs, documentation. |
| [`testing.mdc`](rules/testing.mdc) | Test quality guidelines | Test writing/review | Testing guidelines for unit/integration tests. |

### Usage Guidelines
- **Single responsibility per file**: Each `.mdc` focuses on one concern.
- **`alwaysApply: false`**: Cursor activates rules contextually via descriptions.
- **Headings for routing**: Cursor uses `## Section` names to match relevant rules.
- **Markdown emphasis**: **Bold** for key concepts, _italic_ for qualifiers, `code` for literals.

### Rule Philosophy
- **Concise**: Principles over examples (save tokens, maximize generalization).
- **Actionable**: Imperative language (`MUST`, `NEVER`, `Prefer`).
- **Scalable**: Layered by responsibility for easy maintenance.
