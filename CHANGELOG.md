# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

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

- `skills.json` — manifesto para distribuição via `npx skills add lifters/lifters-ai`.
