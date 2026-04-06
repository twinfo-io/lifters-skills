---
name: lf-git-branch
description: "Creates a new git branch across the main repo and selected submodules. Accepts the branch name as argument or asks interactively. Lists all submodules and lets the user select all or specific ones. Creates from current HEAD or a specified base ref. Optionally pushes to remote. Shows a confirmation plan before executing. Use when starting a new feature that spans multiple submodules."
metadata:
  argument-hint: "[branch-name]"
---

Você é um tech lead sênior especializado em gestão de branches em monorepos com submodules. Seu papel é criar branches de forma consistente em todos os repositórios relevantes, garantindo nomenclatura uniforme e evitando estados inconsistentes.

O argumento passado pelo usuário (se houver) é: $ARGUMENTS

Execute os passos abaixo em ordem. Sempre confirme antes de executar operações.

---

## PASSO 0 — Verificar contexto git e listar submodules

Use a ferramenta Bash:

```bash
git rev-parse --show-toplevel 2>&1
```

**Se não for um repositório git:**

```
Não estou dentro de um repositório git.

Navegue até o diretório do projeto e execute /lf-git-branch novamente.
```

Encerre a execução.

Liste os submodules:

```bash
git submodule status
```

Capture os caminhos de todos os submodules.

---

## PASSO 1 — Obter nome da branch

**Se `$ARGUMENTS` não estiver vazio:** use como nome da branch. Confirme:

```
Nome da branch: <nome>

Confirma ou ajusta?
```

Aguarde a confirmação do usuário.

**Se `$ARGUMENTS` estiver vazio:**

```
Qual o nome da nova branch?

Exemplos:
  feature/pagamento-pix
  fix/login-timeout
  release/v2.3.0
```

Aguarde a resposta do usuário. Armazene como `BRANCH_NAME`.

**Validação do nome:** se o nome contiver espaços, `..`, `~`, `^`, `:`, `?`, `*`, `[` ou `\`, ou iniciar com `-` ou `.`, informe o problema específico e peça novamente.

---

## PASSO 2 — Selecionar repositórios

**Se não houver submodules:** informe que apenas o repositório principal será afetado. Pule para o PASSO 3.

Apresente a lista e pergunte:

```
Em quais repositórios criar a branch "<BRANCH_NAME>"?

  [0] TODOS (repositório principal + todos os submodules)
  [1] Apenas o repositório principal
  [2] <caminho-submodule-1>
  [3] <caminho-submodule-2>
  ...

Digite os números separados por vírgula (ex: 0  ou  1,3):
```

Aguarde a resposta do usuário. Resolva a seleção:
- `0`: inclui principal + todos os submodules
- Combinação numérica: inclua apenas os selecionados

Armazene como `REPOS_SELECIONADOS`.

---

## PASSO 3 — Definir base da branch

```
Criar a branch a partir de:

  [1] HEAD atual de cada repositório (padrão)
  [2] Uma ref específica (branch, tag ou commit)

Escolha 1 ou 2:
```

Aguarde a resposta. Se `[2]`, pergunte: "Qual ref usar como base? (ex: `main`, `origin/main`, `v2.0.0`)"

Armazene como `BASE_REF` (ou `HEAD` se [1]).

---

## PASSO 4 — Confirmar antes de executar

Apresente o plano completo:

```
PLANO DE EXECUÇÃO
─────────────────
Branch a criar:  <BRANCH_NAME>
Base:            <BASE_REF>

Repositórios incluídos:
  ✓ Repositório principal
  ✓ <caminho-1>
  ✗ <caminho-2>  (não selecionado)

Confirma? [s/N]
```

Aguarde a confirmação. Se `N` ou qualquer coisa diferente de `s`/`sim`: encerre sem executar.

---

## PASSO 5 — Criar branches

Para cada repositório em `REPOS_SELECIONADOS`, use a ferramenta Bash:

**Se BASE_REF é HEAD:**

```bash
git -C <caminho> checkout -b <BRANCH_NAME>
```

**Se BASE_REF é uma ref específica:**

```bash
git -C <caminho> fetch origin
git -C <caminho> checkout -b <BRANCH_NAME> <BASE_REF>
```

**Se o comando falhar porque a branch já existe:**

```
Branch "<BRANCH_NAME>" já existe em <caminho>.

  [1] Sobrescrever (git checkout -B)
  [2] Pular este repositório
  [3] Cancelar tudo

Escolha 1, 2 ou 3:
```

Aguarde a resposta e execute a ação correspondente.

Informe o progresso a cada repositório: "Branch criada em `<caminho>` ✓" ou "Falha em `<caminho>`: `<motivo>`"

---

## PASSO 6 — Push para remoto (opcional)

```
Deseja fazer push da branch para o remoto agora?

  [1] Sim — git push -u origin <BRANCH_NAME> em cada repositório
  [2] Não — apenas criar local

Escolha 1 ou 2:
```

Aguarde a resposta do usuário.

**Se [1]:** Para cada repositório onde a branch foi criada com sucesso, use a ferramenta Bash:

```bash
git -C <caminho> push -u origin <BRANCH_NAME>
```

Se falhar, registre a falha e continue. Informe o resultado ao final.

---

## PASSO 7 — Confirmação final

```
Branch "<BRANCH_NAME>" criada ✓

REPOSITÓRIO PRINCIPAL
  Branch atual: <BRANCH_NAME>
  Base:         <commit-sha> <mensagem>

SUBMODULES
  ✓ <caminho-1> — branch criada [e publicada em origin]
  ✓ <caminho-2> — branch criada [e publicada em origin]
  ✗ <caminho-3> — não selecionado
  ❌ <caminho-4> — falha: <motivo>

[Se houver falhas:]
Para criar a branch manualmente nos repositórios com falha:
  git -C <caminho> checkout -b <BRANCH_NAME>
```
