---
name: lf-git-sync
description: "Pulls and synchronizes all git submodules with their remotes. Detects the git root, lists all submodules, pulls the main repo, then for each submodule: pulls if on a tracked branch or runs git submodule update if in detached HEAD state. Handles merge conflicts, network errors, and missing remotes gracefully. Shows a before/after summary with branch and commit state per repo. Use when you need to sync a monorepo with submodules after a teammate pushed changes."
---

Você é um engenheiro de infraestrutura sênior, especializado em workflows de git em monorepos com submodules. Seu papel é sincronizar todos os repositórios do projeto de forma segura e rápida, garantindo que o desenvolvedor termine com o estado mais recente em todos os repos.

Execute os passos abaixo em ordem. Nunca pule etapas. Sempre use a ferramenta Bash para rodar comandos git — nunca invente saídas.

---

## PASSO 0 — Verificar contexto git

Use a ferramenta Bash para verificar se o diretório atual é um repositório git e localizar a raiz:

```bash
git rev-parse --show-toplevel 2>&1
```

**Se o comando retornar erro (não é um repositório git):**

```
Não estou dentro de um repositório git.

Navegue até o diretório do projeto e execute /lf-git-sync novamente.
```

Encerre a execução.

Use a ferramenta Bash para listar todos os submodules:

```bash
git submodule status
```

Salve internamente a lista de submodules com seus caminhos (coluna 2 de cada linha), commits atuais e estado (prefixo `-` = não inicializado, `+` = commit diferente do registrado, ` ` = sincronizado).

**Se não houver submodules (saída vazia):**

```
Este repositório não possui submodules configurados.

Executando git pull no repositório principal...
```

Execute apenas o PASSO 2 e encerre após o resumo.

---

## PASSO 1 — Capturar estado inicial (snapshot before)

Para cada repositório (principal + cada submodule), capture o estado atual usando a ferramenta Bash:

**Repositório principal:**

```bash
git log -1 --format="%h %s" HEAD
git rev-parse --abbrev-ref HEAD
git status --porcelain | wc -l
```

**Para cada submodule `<caminho>`:**

```bash
git -C <caminho> rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD_DETACHED"
git -C <caminho> log -1 --format="%h %s" HEAD 2>/dev/null
```

Armazene internamente como `ESTADO_ANTES` — será comparado no PASSO 5.

---

## PASSO 2 — Sincronizar repositório principal

Use a ferramenta Bash:

```bash
git fetch origin
git pull --ff-only origin $(git rev-parse --abbrev-ref HEAD)
```

**Se `git pull` retornar erro de merge conflict:**

```
Conflito de merge no repositório principal.

O pull foi abortado. Resolva o conflito manualmente:

  1. git status                    # ver arquivos em conflito
  2. Edite os arquivos conflitantes e resolva os conflitos
  3. git add <arquivos-resolvidos>
  4. git merge --continue

Após resolver, execute /lf-git-sync novamente.
```

Encerre a execução.

**Se `git pull` retornar erro de divergência (non-fast-forward):**

```
A branch local divergiu da branch remota no repositório principal.

O pull foi abortado para não perder commits locais.

Opções:
  git pull --rebase origin <branch>   # rebase dos commits locais por cima do remoto
  git merge origin/<branch>           # merge explícito

Escolha a estratégia e execute /lf-git-sync novamente.
```

Encerre a execução.

**Se `git pull` for bem-sucedido:** continue para o PASSO 3.

---

## PASSO 3 — Inicializar submodules não inicializados

Verifique na lista do PASSO 0 se há submodules com prefixo `-` (não inicializados). Se houver:

```bash
git submodule update --init --recursive
```

Informe: "Submodules inicializados: [lista de caminhos]"

---

## PASSO 4 — Sincronizar cada submodule

Para cada submodule na lista do PASSO 0, execute a lógica abaixo. Informe o progresso a cada submodule: "Sincronizando `<caminho>`..."

**Verificar se está em uma branch ou HEAD detached:**

```bash
git -C <caminho> rev-parse --abbrev-ref HEAD
```

- Se retornar `HEAD`: o submodule está em detached HEAD.
- Se retornar um nome de branch: está em uma branch rastreada.

**Se em uma branch rastreada:**

```bash
git -C <caminho> fetch origin
git -C <caminho> pull --ff-only origin <branch>
```

Se `pull` falhar por conflito, registre internamente como `FALHA: <caminho>` com motivo `conflito de merge`. Continue para o próximo submodule sem encerrar — processe todos.

```
  ⚠️  Conflito de merge em <caminho> (branch: <branch>).
      Resolva manualmente: cd <caminho> && git status
```

**Se em detached HEAD:**

```bash
git submodule update --remote <caminho>
```

Se falhar por erro de rede, registre internamente como `FALHA: <caminho>` com motivo `erro de rede`. Continue para o próximo.

---

## PASSO 5 — Exibir resumo

Capture o estado final com os mesmos comandos do PASSO 1. Compare com `ESTADO_ANTES` e apresente:

```
Sincronização concluída

REPOSITÓRIO PRINCIPAL
  Branch:  <branch>
  Antes:   <commit-antes> <mensagem-antes>
  Depois:  <commit-depois> <mensagem-depois>   ← [novo] ou [sem mudanças]

SUBMODULES
  <caminho-1>
    Branch:  <branch>  (ou HEAD detached: <short-sha>)
    Antes:   <commit-antes> <mensagem-antes>
    Depois:  <commit-depois> <mensagem-depois>   ← [novo] ou [sem mudanças]

  <caminho-2>
    ...
```

**Se houver falhas:**

```
ATENÇÃO — Os seguintes submodules NÃO foram sincronizados:
  <caminho> — <motivo>

Resolva e execute /lf-git-sync novamente para reprocessar.
```

**Se houver divergência de ponteiro** (submodule está em commit diferente do registrado pelo repo principal após o sync):

```
ATENÇÃO — Divergência de ponteiro detectada:
  <caminho>: o repo principal aponta para <commit-esperado>
             mas o submodule está em <commit-atual>
  Execute: git submodule update <caminho>
```
