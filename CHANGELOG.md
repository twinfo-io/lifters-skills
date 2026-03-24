# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [2.0.0] - 2026-03-23

### Added

- `/lf-briefing-ux` — nova skill que gera o Briefing UX/UI a partir do
  `discovery.md`. Produz `briefings/briefing-ux.v0.md` com 11 seções focadas
  exclusivamente no que o usuário vê e faz: personas, mapa de telas, especificação
  por tela (estados + wireframe ASCII), fluxos de usuário, microcopy prescritivo,
  regras de exibição e referências visuais. Audiência: time de UX/UI.
  Pré-requisito: `discovery.md` gerado pelo `/lf-discovery`.

- `skills/lf-briefing-ux/SKILL.md` — instrução completa da skill em 4 passos:
  localizar discovery + verificar design system + confirmar escopo + gerar briefing.

- `skills/lf-briefing-ux/templates/briefing-ux.md` — template com 11 seções e
  header com campo `Baseado em` referenciando o `discovery.md`.

- `ai/specs/20260323142630_google_docs/briefings/briefing-ux.v0.md` —
  referência canônica de qualidade para o Briefing UX/UI, preenchida com o
  contexto da feature Google Docs (todas as 11 seções).

- `README.md`: nova seção "Fluxo completo de uso" com diagrama ASCII, descrição
  de cada etapa com exemplos de uso, guia de refinamento conversacional e
  documentação da rastreabilidade entre artefatos.

### Changed

- `/lf-new-feature`: output do briefing técnico renomeado de `briefing.v0.md`
  para `briefing-tech.v0.md`. A skill agora detecta e lê `briefing-ux.vN.md`
  (a versão mais recente, se existir) para popular seções 3 (Personas) e 6
  (UX e Comportamento) do briefing técnico sem repetir perguntas. Ao final da
  geração, lista automaticamente decisões técnicas que possam impactar o
  Briefing UX/UI, para que o time decida se uma nova versão de UX é necessária.

- `skills/lf-new-feature/templates/briefing.md` renomeado para
  `briefing-tech.md`. O header do template agora inclui campos `Baseado em`
  para referenciar `briefing-ux.vN.md` e `discovery.md`. Conteúdo das 15 seções
  permanece intacto.

- Headers de todos os briefings gerados incluem referências cruzadas em links
  relativos: `briefing-ux.vN.md` referencia `../discovery.md`;
  `briefing-tech.vN.md` referencia `../briefings/briefing-ux.vN.md` e
  `../discovery.md`. Em refinamentos (v1, v2...), os headers apontam sempre
  para os arquivos mais recentes disponíveis no momento da geração.

- `skills.json`: versão atualizada para `2.0.0`, nova entrada `lf-briefing-ux`
  adicionada entre `lf-discovery` e `lf-new-feature`.

- `CLAUDE.md`: novo fluxo documentado, nova skill `lf-briefing-ux`, estrutura
  de diretórios atualizada (briefings bifásicos), seção "Cross-reference Headers"
  adicionada, seção "Spec Format" atualizada com as 11 seções do Briefing UX/UI.

### Breaking Change

- O arquivo gerado pelo `/lf-new-feature` mudou de nome:
  `briefings/briefing.v0.md` → `briefings/briefing-tech.v0.md`.
  Features existentes com `briefing.v0.md` não são afetadas — apenas
  novas execuções usam o novo nome.

---

## [1.3.0] - 2026-03-23

### Changed

- Todas as skills renomeadas com prefixo `lf-` para identificação da Lifters:
  - `discovery` → `lf-discovery` (diretório `skills/lf-discovery/`)
  - `new-feature` → `lf-new-feature` (diretório `skills/lf-new-feature/`)
  - `design-system` → `lf-design-system` (diretório `skills/lf-design-system/`)

- `skills.json`: campos `name` e `file` atualizados para os novos nomes.

- `skills/lf-discovery/SKILL.md`: campo `name` atualizado para `lf-discovery`; referência ao próximo passo atualizada para `/lf-new-feature`.

- `skills/lf-new-feature/SKILL.md`: campo `name` atualizado para `lf-new-feature`; referência ao discovery inline atualizada para `/lf-discovery`.

- `skills/lf-design-system/SKILL.md`: campo `name` atualizado para `lf-design-system`.

- `README.md` e `CLAUDE.md`: todas as referências de comandos e diagramas de estrutura atualizados para refletir os novos nomes.

---

## [1.2.0] - 2026-03-23

### Added

- `/design-system` — nova skill que conecta ao Figma via MCP Server e gera
  `specs/design-system.md` como fonte de verdade visual oficial do projeto.
  Extrai tipografia, cores, espaçamento, border radius e sombras diretamente
  do Figma usando `get_metadata`, `get_variable_defs` e `get_design_context`.
  Verifica conexão MCP antes de iniciar, detecta arquivo existente e pergunta
  se deve sobrescrever, e documenta ambiguidades em "Notas de interpretação".

- `skills/design-system/SKILL.md` — instrução completa da skill em 5 passos.

- `skills/design-system/templates/design-system.md` — template com 15 seções:
  Fonte de verdade, Uso obrigatório, Notas de interpretação, Famílias tipográficas,
  Importação recomendada, Escala tipográfica (Display/Headings + Body/UI),
  Cores Brand, Cores Neutras, Cores Status, Espaçamento, Border radius,
  Sombras/Elevation, CSS custom properties, Regras de implementação,
  Decisão em caso de dúvida.

- `skills.json` atualizado: nova entrada `design-system` com scope `user`.

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
