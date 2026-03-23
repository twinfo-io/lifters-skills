# Publicando no skills.sh

Guia para publicar e distribuir as skills deste repositório no registry [skills.sh](https://skills.sh).

Este repositório já segue o padrão **Agent Skills** (`agentskills.io`). Não é necessária nenhuma adaptação de estrutura.

---

## 1. Pré-requisitos

- [ ] Conta no **GitHub** com repositório público
- [ ] **Node.js** v18 ou superior
- [ ] `npx` disponível no terminal

```bash
node --version        # >= 18.0.0
npx skills --version
```

---

## 2. Testando Localmente

```bash
# Instala do diretório local
npx skills add ./

# Verifica instalação
npx skills list

# Testa com escopo global
npx skills add -g ./
```

---

## 3. Publicando no GitHub

### 3.1 Repositório público

O skills.sh só indexa repositórios públicos. Verifique em:
`Settings → General → Danger Zone → Change visibility → Public`

### 3.2 Commit e push

```bash
git add .
git commit -m "chore: migrate to Agent Skills standard"
git push origin main
```

### 3.3 Tópicos recomendados

No GitHub (`About → Topics`):
```
claude-code  agent-skills  skills-sh  ai-tools  product-development
```

### 3.4 Release tag semântica

```bash
git tag -a v1.1.0 -m "Migrate to Agent Skills standard"
git push origin v1.1.0
```

---

## 4. Registrando no skills.sh

### Método 1: Descoberta automática (recomendado)

O skills.sh rastreia o GitHub periodicamente. Após o push, o repositório será indexado em **24–48 horas**. Compartilhe o comando de instalação para acelerar:

```bash
npx skills add twinfo-io/lifters-skills
```

### Método 2: Submissão via Claude Skills Registry

1. Fork de `majiayu000/claude-skill-registry`
2. Edite `sources/community.json`:

```json
{
  "repository": "twinfo-io/lifters-skills",
  "description": "AI-native product development skills for feature discovery and spec generation",
  "category": "development",
  "tags": ["product", "discovery", "specs", "briefing", "work-packages"]
}
```

3. Abra um PR com o título: `Add: twinfo-io/lifters-skills`

---

## 5. Verificando a Publicação

```bash
npx skills find "lifters"
npx skills find "discovery"
npx skills add twinfo-io/lifters-skills
npx skills list
```

---

## 6. Atualizando

```bash
# Bump de versão
npm version patch   # 1.1.0 → 1.1.1

# Commit + tag + push
git add .
git commit -m "feat: descrição da mudança"
git tag -a v1.1.1 -m "descrição"
git push origin main --tags
```

Usuários atualizam com:
```bash
npx skills update
```

---

## 7. Adicionando Novas Skills

Para cada nova skill:

1. Crie `skills/nome/SKILL.md` com frontmatter YAML:
   ```yaml
   ---
   name: nome
   description: O que faz e quando usar (máx. 1024 chars)
   ---
   ```
2. Adicione templates em `skills/nome/templates/` se necessário
3. Atualize `skills.json` (versão + nova entrada)
4. Documente em `README.md` e `CHANGELOG.md`
5. Commit + tag + push

---

## Referências

| Recurso | URL |
|---|---|
| Registry oficial | https://skills.sh |
| CLI (npx skills) | https://github.com/vercel-labs/skills |
| Padrão Agent Skills | https://agentskills.io |
| Claude Skills Registry | https://github.com/majiayu000/claude-skill-registry |
| Claude Code Docs | https://code.claude.com/docs/en/skills |
| Best practices | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices |
