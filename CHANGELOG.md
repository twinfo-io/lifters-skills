# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [1.1.0] - 2026-03-23

### Changed

- Migração completa para o padrão **Agent Skills** (`agentskills.io`), compatível com
  skills.sh, Claude Code, Cursor, GitHub Copilot e 30+ outros agentes.

- `commands/discovery.md` e `commands/new-feature.md` migrados para
  `skills/discovery/SKILL.md` e `skills/new-feature/SKILL.md` com frontmatter
  YAML padronizado (`name`, `description`, `argument-hint`).

- Templates movidos de `templates/` global para dentro de cada skill:
  - `skills/discovery/templates/discovery.md`
  - `skills/new-feature/templates/briefing.md`
  - `skills/new-feature/templates/specs.md`
  - `skills/new-feature/templates/wps.md`

- Referências de template dentro das skills atualizadas para usar `$CLAUDE_SKILL_DIR/templates/`
  (resolução correta independente do diretório de instalação).

- `install.sh` atualizado: instala de `skills/*/` para `~/.claude/skills/<nome>/`
  (padrão Agent Skills) em vez do legado `~/.claude/commands/`.

- `skills.json` atualizado: versão `1.1.0`, caminhos apontam para `skills/*/SKILL.md`.

- `README.md` e `CLAUDE.md` atualizados com a nova estrutura.

### Removed

- Diretório `commands/` (conteúdo migrado para `skills/`)
- Diretório `templates/` (conteúdo migrado para `skills/*/templates/`)

---

## [1.0.0] - 2025-03-23

### Added

- `/discovery` — discovery interativo de features com 7 fases:
  coleta de inputs (URL, paste, múltiplos documentos), criação automática
  de estrutura de pastas, extração de contexto, entrevista
  greenfield/brownfield, pesquisa de mercado automática via WebSearch,
  e geração do artefato `discovery.md`.

- `/new-feature` — geração de briefing, specs e work packages a partir
  do `discovery.md` existente ou via discovery inline. Gera os três
  arquivos canônicos: `briefing.v0.md`, `specs.md`, `wps.md`.

- `templates/` — templates canônicos para todos os artefatos gerados:
  `discovery.md`, `briefing.md`, `specs.md`, `wps.md`.

- `install.sh` — script de instalação via symlinks para `~/.claude/commands/`.

- `skills.json` — manifesto para distribuição via `npx skills add twinfo-io/lifters-skills`.
