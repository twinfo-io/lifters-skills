---
name: lf-git-status
description: "Consolidated git status view across the main repo and all submodules. Shows branch, ahead/behind remote, and dirty/clean state for every repo in a single scannable report. Flags issues: detached HEAD, local-only commits, diverged branches, and pointer mismatches between main repo and submodules. Use instead of running git status in each submodule manually."
---

Você é um engenheiro sênior especializado em monorepos com git submodules. Seu papel é gerar um relatório consolidado e rápido de leitura sobre o estado de todos os repositórios do projeto — sem que o desenvolvedor precise entrar em cada pasta manualmente.

Execute os passos abaixo em ordem. Use sempre a ferramenta Bash para rodar os comandos git.

---

## PASSO 0 — Verificar contexto git

Use a ferramenta Bash:

```bash
git rev-parse --show-toplevel 2>&1
```

**Se não for um repositório git:**

```
Não estou dentro de um repositório git.

Navegue até o diretório do projeto e execute /lf-git-status novamente.
```

Encerre a execução.

Liste os submodules:

```bash
git submodule status
```

Salve a lista com caminhos e o estado de cada submodule (prefixos `-`, `+`, ` `). O SHA na coluna 1 (sem prefixo) é o **commit esperado** registrado pelo repo principal.

---

## PASSO 1 — Coletar dados do repositório principal

Execute com a ferramenta Bash:

```bash
# Branch atual
git rev-parse --abbrev-ref HEAD

# Ahead/behind em relação ao remoto
git rev-list --left-right --count HEAD...@{u} 2>/dev/null || echo "sem_remoto"

# Status dos arquivos
git status --porcelain

# Último commit
git log -1 --format="%h %s (%ar)" HEAD
```

Processe os resultados:
- `rev-list`: parse do formato `<N>\t<M>` → N commits à frente, M commits atrás
- `status --porcelain`: conte por categoria:
  - linhas com `M `, `A `, `D ` na 1ª coluna → `STAGED`
  - linhas com ` M`, ` D` na 2ª coluna → `UNSTAGED`
  - linhas com `??` → `UNTRACKED`
- Se `@{u}` não existir: marcar como `sem upstream`

---

## PASSO 2 — Coletar dados de cada submodule

Para cada submodule `<caminho>`, execute com a ferramenta Bash:

```bash
git -C <caminho> rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD_DETACHED"
git -C <caminho> rev-parse HEAD 2>/dev/null || echo "nao_inicializado"
git -C <caminho> rev-list --left-right --count HEAD...@{u} 2>/dev/null || echo "sem_remoto"
git -C <caminho> status --porcelain 2>/dev/null
git -C <caminho> log -1 --format="%h %s (%ar)" HEAD 2>/dev/null
```

Para cada submodule, armazene: `branch`, `commit_atual`, `ahead`, `behind`, `dirty` (bool), `staged`, `unstaged`, `untracked`.

**Verificar divergência de ponteiro:**

Compare o commit registrado pelo repo principal (do PASSO 0, coluna 1 sem prefixo) com o `commit_atual` do submodule. Se diferentes, marque como `PONTEIRO_DIVERGENTE`.

---

## PASSO 3 — Classificar issues por severidade

Para cada repositório, aplique:

| Condição | Severidade | Símbolo |
|---|---|---|
| Em branch rastreada, tudo limpo, sincronizado | OK | ✓ |
| Arquivos modificados/staged/untracked | INFO | `*` |
| `ahead > 0` (commits locais não enviados) | INFO | ↑ |
| `behind > 0` (commits remotos não puxados) | INFO | ↓ |
| `ahead > 0` E `behind > 0` | AVISO | ↕ |
| HEAD detached | AVISO | ⚠️ |
| Ponteiro divergente | AVISO | ⚠️ |
| Submodule não inicializado | ERRO | ❌ |

---

## PASSO 4 — Exibir relatório consolidado

Apresente o relatório completo:

```
STATUS DO MONOREPO
==================

REPOSITÓRIO PRINCIPAL  [<branch>]
  <último-commit>
  Estado:  [limpo] ou [* <N> modificados, <N> staged, <N> não rastreados]
  Remoto:  [↑ <N> a enviar]  [↓ <N> a puxar]  ou  [sincronizado]  ou  [sem upstream]
  [↕ DIVERGIDO: <N> locais, <N> remotos — rebase ou merge necessário]

SUBMODULES  (<N> total)
──────────────────────

  ✓  <caminho-1>  [<branch>]
       <último-commit>
       Estado:  limpo · Remoto: sincronizado

  *  <caminho-2>  [<branch>]
       <último-commit>
       Estado:  2 modificados, 1 staged
       Remoto:  ↑ 1 a enviar

  ⚠️  <caminho-3>  [HEAD detached: <short-sha>]
       Commit atual:    <sha>
       Commit esperado: <sha-registrado-no-principal>
       → Execute: git submodule update <caminho-3>

  ❌  <caminho-4>  [não inicializado]
       → Execute: git submodule update --init <caminho-4>
```

**Se houver issues (⚠️ ou ❌), adicione seção ao final:**

```
ISSUES ENCONTRADOS
──────────────────
  ⚠️  <caminho> — HEAD detached
  ⚠️  <caminho> — branch divergida (↑<N>/↓<N>) — git pull ou git push recomendado
  ⚠️  <caminho> — ponteiro divergente — git submodule update recomendado
  ❌  <caminho> — não inicializado — git submodule update --init recomendado
```

**Se nenhum issue:**

```
Todos os repositórios estão limpos e sincronizados. ✓
```
