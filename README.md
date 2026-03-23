# lifters-skills

Skills de Claude Code para times de produto da Lifters. Padroniza o processo de criação de features — do discovery inicial à geração de briefing, especificações e work packages — em todos os projetos da empresa.

Segue o padrão [Agent Skills](https://agentskills.io) — compatível com Claude Code, Cursor, GitHub Copilot e 30+ outros agentes.

---

## Instalação

**Via registry (recomendado):**
```bash
npx skills add twinfo-io/lifters-skills
```

**Com escopo global (disponível em todos os projetos):**
```bash
npx skills add -g twinfo-io/lifters-skills
```

**Via script (fallback):**
```bash
curl -sSL https://raw.githubusercontent.com/twinfo-io/lifters-skills/main/install.sh | bash
```

**Via clone local (para contribuição):**
```bash
git clone https://github.com/twinfo-io/lifters-skills.git ~/.lifters-skills
bash ~/.lifters-skills/install.sh
```

---

## Atualização

```bash
npx skills update
```

---

## Skills

### `/discovery [feature description]`

Inicia o processo de discovery de uma nova feature. Conduz uma entrevista estruturada em 7 fases e gera `discovery.md` como artefato base.

```bash
/discovery "Cobrança recorrente com Stripe"
# ou sem argumento — a skill pergunta o nome
/discovery
```

**O que acontece:**
1. Coleta documentos de entrada (URL, paste, múltiplos arquivos) **antes** de criar qualquer pasta
2. Cria a estrutura `ai/specs/NNNNN_nome/` com os inputs salvos
3. Extrai contexto dos documentos e apresenta o entendimento para confirmação
4. Conduz entrevista adaptada: brownfield (produto existente) ou greenfield (projeto novo)
5. Faz perguntas apenas sobre lacunas — o que já foi respondido pelos inputs é ignorado
6. Pesquisa automaticamente referências de mercado (WebSearch) e valida com o usuário
7. Gera `ai/specs/NNNNN_nome/discovery.md`

**Regra crítica:** campos não respondidos viram `⚠️ Ponto em aberto` — a skill nunca inventa valores.

---

### `/new-feature`

Gera os três artefatos canônicos da feature a partir do `discovery.md` existente. Se não houver discovery prévio, conduz o discovery inline.

```bash
/new-feature
```

**O que gera:**
```
ai/specs/NNNNN_nome/
├── briefings/
│   └── briefing.v0.md    ← 15 seções canônicas
├── specs.md              ← SPECs com critérios de aceite DADO/QUANDO/ENTÃO
└── wps.md                ← Work packages com estimativas e dependências
```

---

## Estrutura gerada por feature

```
ai/specs/NNNNN_nome_da_feature/
├── inputs/                     ← documentos de entrada fornecidos pelo PM
│   ├── input-01.md             ← conteúdo de URL ou paste (salvo pela skill)
│   └── input-02.md
├── briefings/
│   ├── briefing.v0.md          ← gerado pelo /new-feature
│   └── briefing.v1.md          ← refinamento após review do time
├── plans/                      ← planos de execução (opcional)
├── discovery.md                ← gerado pelo /discovery
├── specs.md                    ← especificações formais
└── wps.md                      ← work packages com dependências e estimativas
```

---

## Estrutura do repositório

```
lifters-skills/
├── skills.json                  ← manifesto para npx skills add
├── install.sh                   ← instalação via curl | bash
├── README.md
├── CHANGELOG.md
├── PUBLISHING.md                ← guia de publicação no skills.sh
├── skills/
│   ├── discovery/
│   │   ├── SKILL.md             ← /discovery (frontmatter + lógica da skill)
│   │   └── templates/
│   │       └── discovery.md     ← estrutura do artefato discovery
│   └── new-feature/
│       ├── SKILL.md             ← /new-feature (frontmatter + lógica da skill)
│       └── templates/
│           ├── briefing.md      ← 15 seções canônicas do briefing
│           ├── specs.md         ← 12 seções por SPEC-XX
│           └── wps.md           ← campos e seções por Wp-XX
└── ai/specs/                    ← specs internas do próprio repositório
    └── 00001_google_docs/       ← referência canônica de qualidade (não modificar)
```

---

## Contribuindo

Para adicionar uma nova skill ao repositório:

1. Crie `skills/nome-da-skill/SKILL.md` com frontmatter YAML e as instruções da skill
2. Adicione templates em `skills/nome-da-skill/templates/` se necessário
3. Adicione a entrada correspondente em `skills.json`
4. Documente no `README.md` e no `CHANGELOG.md`
5. Abra um PR — o time revisa antes de publicar

**Frontmatter obrigatório em todo `SKILL.md`:**
```yaml
---
name: nome-da-skill
description: O que a skill faz e quando usá-la (máx. 1024 chars)
---
```

Convenção de nomes: `kebab-case`, verbos no imperativo em inglês (`gen-docs`, `review-pr`, `update-spec`).

---

## Referências canônicas

Os templates e skills usam os arquivos abaixo como exemplos de qualidade — **não modificar**:

- `ai/specs/00001_google_docs/briefings/briefing.v0.md`
- `ai/specs/00001_google_docs/specs.md`
- `ai/specs/00001_google_docs/wps.md`
