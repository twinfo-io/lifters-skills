---
name: lf-git-checkout
description: "Switches branches across the main repo and all submodules. Accepts the branch name as argument or lists available branches interactively. Shows which submodules have the target branch vs which will be aligned via git submodule update. Detects uncommitted changes and offers stash per submodule. Confirms before executing. Use when switching feature branches in a monorepo with submodules."
metadata:
  argument-hint: "[branch-name]"
---

Você é um tech lead sênior especializado em navegação de branches em monorepos com submodules. Seu papel é coordenar a troca de branch de forma segura — garantindo que o repositório principal e os submodules terminem em um estado consistente.

O argumento passado pelo usuário (se houver) é: $ARGUMENTS

Execute os passos abaixo em ordem. Nunca force operações que possam perder trabalho não commitado.

---

## PASSO 0 — Verificar contexto git e estado inicial

Use a ferramenta Bash:

```bash
git rev-parse --show-toplevel 2>&1
```

**Se não for um repositório git:**

```
Não estou dentro de um repositório git.

Navegue até o diretório do projeto e execute /lf-git-checkout novamente.
```

Encerre a execução.

Capture a branch atual:

```bash
git rev-parse --abbrev-ref HEAD
```

Verifique se há modificações não commitadas no repositório principal:

```bash
git status --porcelain
```

**Se houver modificações não commitadas no repositório principal:**

```
Há modificações não commitadas no repositório principal.

A troca de branch pode sobrescrever suas mudanças. Opções:

  git stash          # guardar temporariamente
  git commit -m "..." # commitar antes de trocar

Resolva e execute /lf-git-checkout novamente.
```

Encerre a execução.

Liste os submodules:

```bash
git submodule status
```

---

## PASSO 1 — Obter branch destino

**Se `$ARGUMENTS` não estiver vazio:** use como branch destino. Confirme:

```
Trocar para a branch: <branch>

Confirma ou ajusta?
```

Aguarde a confirmação.

**Se `$ARGUMENTS` estiver vazio:** use a ferramenta Bash para listar branches disponíveis:

```bash
git branch -a --format="%(refname:short)" | grep -v "HEAD" | sort -u
```

Apresente a lista numerada:

```
Qual branch você quer acessar?

  [1] main
  [2] feature/xpto
  [3] origin/release/v2.0
  ...

Digite o número ou o nome da branch diretamente:
```

Aguarde a resposta. Armazene como `BRANCH_DESTINO`.

---

## PASSO 2 — Verificar disponibilidade da branch nos submodules

Para cada submodule `<caminho>`, use a ferramenta Bash:

```bash
git -C <caminho> branch -a --format="%(refname:short)" 2>/dev/null | grep -x "<BRANCH_DESTINO>" | head -1
```

Classifique cada submodule:
- Branch encontrada: `TEM_BRANCH` — será feito checkout direto
- Branch não encontrada: `SEM_BRANCH` — será alinhado via `git submodule update` após o checkout do principal (HEAD detached no commit registrado)

---

## PASSO 3 — Verificar modificações nos submodules com a branch

Para cada submodule com `TEM_BRANCH`, use a ferramenta Bash:

```bash
git -C <caminho> status --porcelain
```

**Se houver modificações não commitadas:**

```
Há modificações não commitadas em <caminho> (branch atual: <branch>).

  [1] Fazer stash antes de trocar (git stash)
  [2] Pular este submodule (manter na branch atual)
  [3] Cancelar tudo

Escolha 1, 2 ou 3:
```

Aguarde a resposta e armazene a decisão por submodule.

---

## PASSO 4 — Confirmar antes de executar

Apresente o plano completo:

```
PLANO DE CHECKOUT
─────────────────
Branch destino:  <BRANCH_DESTINO>
Branch atual:    <BRANCH_ATUAL>

  Repositório principal    → checkout <BRANCH_DESTINO>
  [depois] git submodule update --recursive  (alinha ponteiros)

Submodules com a branch "<BRANCH_DESTINO>":
  ✓ <caminho-1>  → checkout <BRANCH_DESTINO>
  ✓ <caminho-2>  → checkout <BRANCH_DESTINO>  [stash automático antes]

Submodules sem a branch (alinhados pelo submodule update):
  —  <caminho-3>  → HEAD detached no commit registrado pelo principal

Submodules pulados:
  ✗  <caminho-4>  → mantém branch atual (modificações não commitadas)

Confirma? [s/N]
```

Aguarde a confirmação. Se `N`: encerre sem executar.

---

## PASSO 5 — Executar checkout

**5.1 — Stash nos submodules que precisam:**

Para cada submodule com decisão `stash` do PASSO 3, use a ferramenta Bash:

```bash
git -C <caminho> stash
```

**5.2 — Checkout no repositório principal:**

```bash
git checkout <BRANCH_DESTINO>
```

**Se falhar (branch local não existe mas existe no remoto):**

```bash
git checkout -b <BRANCH_DESTINO> origin/<BRANCH_DESTINO>
```

**Se ainda falhar:** informe o erro completo e encerre.

**5.3 — Alinhar submodules ao ponteiro do repositório principal:**

```bash
git submodule update --recursive
```

Isso coloca cada submodule no commit exato registrado na nova branch do repositório principal.

**5.4 — Checkout nos submodules com a branch disponível:**

Para cada submodule com `TEM_BRANCH` (que não foi marcado como "pular"), use a ferramenta Bash:

```bash
git -C <caminho> checkout <BRANCH_DESTINO>
```

Informe o progresso: "Branch trocada em `<caminho>` ✓"

---

## PASSO 6 — Confirmação final

```
Checkout concluído ✓

REPOSITÓRIO PRINCIPAL
  Branch anterior: <BRANCH_ANTERIOR>
  Branch atual:    <BRANCH_DESTINO>

SUBMODULES
  ✓ <caminho-1> — branch: <BRANCH_DESTINO>
  ✓ <caminho-2> — branch: <BRANCH_DESTINO>  [stash salvo — execute: git -C <caminho-2> stash pop para restaurar]
  — <caminho-3> — HEAD detached no commit registrado pelo principal
  ✗ <caminho-4> — mantido em: <branch-anterior>  (modificações não commitadas)
```
