# Lifters Skills

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

### `/lf-discovery [feature description]`

Inicia o processo de discovery de uma nova feature. Conduz uma entrevista estruturada em 7 fases e gera `discovery.md` como artefato base.

```bash
/lf-discovery "Cobrança recorrente com Stripe"
# ou sem argumento — a skill pergunta o nome
/lf-discovery
```

**O que acontece:**

1. Coleta documentos de entrada (URL, paste, múltiplos arquivos) **antes** de criar qualquer pasta
2. Cria a estrutura `ai/specs/YYYYMMDDHHmmSS_nome/` com os inputs salvos
3. Extrai contexto dos documentos e apresenta o entendimento para confirmação
4. Conduz entrevista adaptada: brownfield (produto existente) ou greenfield (projeto novo)
5. Faz perguntas apenas sobre lacunas — o que já foi respondido pelos inputs é ignorado
6. Pesquisa automaticamente referências de mercado (WebSearch) e valida com o usuário
7. Gera `ai/specs/YYYYMMDDHHmmSS_nome/discovery.md`

**Regra crítica:** campos não respondidos viram `⚠️ Ponto em aberto` — a skill nunca inventa valores.

---

### `/lf-briefing-ux`

Gera o Briefing UX/UI a partir do `discovery.md` existente e um protótipo HTML navegável com mocks para revisão visual imediata. Produz artefatos focados exclusivamente no que o usuário vê e faz — sem ruído técnico de backend ou infraestrutura. Desenhado para o time de UX/UI iniciar a prototipação sem depender do briefing técnico completo.

```bash
/lf-briefing-ux
```

**Pré-requisitos:**
- `discovery.md` gerado pelo `/lf-discovery`
- `specs/design-system.md` gerado pelo `/lf-design-system` (**obrigatório** — a skill aborta sem ele)

**O que gera:**

```
ai/specs/YYYYMMDDHHmmSS_nome/
├── briefings/
│   └── briefing-ux.v0.md  ← 11 seções: personas, mapa de telas, especificação
│                              por tela (estados + wireframe ASCII), fluxos,
│                              microcopy prescritivo, regras de exibição
└── prototype/
    └── index.html          ← protótipo HTML navegável com todas as telas e
                               estados descritos no briefing, usando os tokens
                               do design system
```

---

### `/lf-new-feature`

Gera os três artefatos canônicos da feature a partir do `discovery.md` existente. Se não houver discovery prévio, conduz o discovery inline. Se `briefing-ux.vN.md` existir, usa-o para popular personas e UX do briefing técnico sem repetir perguntas.

```bash
/lf-new-feature
```

**O que gera:**

```
ai/specs/YYYYMMDDHHmmSS_nome/
├── briefings/
│   └── briefing-tech.v0.md  ← 15 seções canônicas
├── specs.md                 ← SPECs com critérios de aceite DADO/QUANDO/ENTÃO
└── wps.md                   ← Work packages com estimativas e dependências
```

---

### `/lf-design-system ["Nome do DS" figma-url]`

Conecta ao Figma via MCP Server, extrai todos os tokens de design (tipografia, cores, espaçamento, border radius, sombras) e gera `specs/design-system.md` — a fonte de verdade visual oficial do projeto.

```bash
/lf-design-system "Atlas" https://figma.com/design/abc123/Atlas?node-id=3-281
# ou sem argumentos — a skill pergunta nome e URL
/lf-design-system
```

**Pré-requisito:** o Figma MCP Server deve estar configurado e autenticado nas configurações do Claude Code.

**O que acontece:**

1. Verifica a conexão com o Figma MCP (`whoami`) — aborta com orientação de setup se não conectado
2. Coleta nome do design system e URL do Figma (via argumento ou interativamente)
3. Avisa se `specs/design-system.md` já existe e pergunta se deve sobrescrever ou abortar
4. Extrai dados do Figma: mapa estrutural (`get_metadata`), tokens formalizados (`get_variable_defs`) e contexto detalhado nos nodes de tipografia e cores (`get_design_context`)
5. Gera `specs/design-system.md` com 15 seções, incluindo os node IDs utilizados e notas de interpretação para ambiguidades encontradas

**O que gera:**

```
specs/
└── design-system.md    ← fonte de verdade com tipografia, cores, espaçamento,
                           border radius, sombras e CSS custom properties
```

**Regra crítica:** em caso de conflito entre implementação local e o `design-system.md`, o Figma e este arquivo vencem.

---

## Fluxo completo de uso

O fluxo AI-Native da Lifters segue quatro etapas sequenciais. Cada etapa gera um artefato que alimenta a próxima — nenhuma skill precisa repetir perguntas já respondidas anteriormente.

```
/lf-discovery
      │
      ▼
 discovery.md ────────────────────────────────────────────────┐
      │                                                        │
      ▼                                                        │
/lf-briefing-ux ◄── specs/design-system.md (obrigatório)     │
      │                                                        │
      ▼                                                        ▼
briefing-ux.v0.md ───────────────────────────► /lf-new-feature
prototype/index.html   [revisão UX/UI → v1]          │
      │                                               ▼
      │                                   briefing-tech.v0.md
      │                                   specs.md
      │                                   wps.md
      │
      └── /lf-design-system (deve rodar antes do /lf-briefing-ux)
```

### Etapa 1 — Discovery `/lf-discovery`

Conduza o discovery antes de qualquer outra skill. O `discovery.md` é o ponto único de entrada de contexto — tudo que as skills seguintes geram parte dele.

```bash
/lf-discovery "Cobrança recorrente com Stripe"
```

Colete documentos existentes (Google Docs, Notion, texto colado), responda as perguntas sobre greenfield vs. brownfield, lacunas técnicas e personas. A skill pesquisa referências de mercado automaticamente.

**Resultado:** `ai/specs/YYYYMMDDHHmmSS_nome/discovery.md`

---

### Etapa 2 — Briefing UX/UI `/lf-briefing-ux`

Execute após ter o `discovery.md` **e** o `specs/design-system.md`. Gera o briefing para o time de UX/UI e um protótipo HTML navegável com mocks para apresentação imediata — sem precisar ler o discovery completo nem esperar o briefing técnico.

```bash
/lf-briefing-ux
```

A skill lê o `discovery.md` e o `specs/design-system.md` automaticamente, gera o briefing UX com todas as telas, wireframes ASCII e microcopy prescritivo, e em seguida gera o `prototype/index.html` com todas as telas navegáveis, todos os estados e os tokens do design system aplicados.

**Resultado:**
- `ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-ux.v0.md`
- `ai/specs/YYYYMMDDHHmmSS_nome/prototype/index.html`

---

### Etapa 3 — Briefing Técnico + Specs + WPs `/lf-new-feature`

Execute após o `briefing-ux.v0.md` estar revisado e aprovado pelo time de UX. A skill detecta e lê automaticamente o briefing UX mais recente para popular as seções de personas e UX do briefing técnico.

```bash
/lf-new-feature
```

Ao final, a skill lista automaticamente decisões técnicas que possam impactar o Briefing UX/UI, para que você decida se uma nova versão de UX é necessária antes de prototipar.

**Resultado:**

```
briefings/briefing-tech.v0.md  ← 15 seções técnicas
specs.md                       ← SPECs por domínio
wps.md                         ← Work Packages com dependências
```

---

### Iterações e refinamentos

Não há skill dedicada para refinamento — basta pedir ao Claude na conversa:

**Refinar o Briefing UX (gerar v1):**

```
Leia ai/specs/.../briefings/briefing-ux.v0.md e gere a v1 com:
1. Adicionar tela "Confirmação de Criação" no mapa de telas (seção 3)
2. Mudar texto do botão de "Criar" para "Criar e publicar" (seção 8)
O restante permanece igual.
```

**Refinar o Briefing Técnico (gerar v1):**

```
Leia briefing-tech.v0.md e briefing-ux.v1.md e gere briefing-tech.v1.md com:
1. Adicionar mecanismo de fila Redis+Bull na seção 5 (rate limit da API externa)
2. Adicionar cenário de erro "rate limit atingido" na seção 9
Verifique se essas mudanças impactam o briefing-ux — se sim, liste o que atualizar.
```

Claude cria o novo arquivo (`v1`, `v2`...) sem apagar o anterior. O histórico completo fica no repositório.

---

### Rastreabilidade entre artefatos

Todos os briefings gerados incluem headers com referências cruzadas:

```
discovery.md
    ↑ referenciado por
briefing-ux.v1.md  →  "Baseado em: ../discovery.md (2026-03-20)"
    ↑ referenciado por
briefing-tech.v1.md → "Baseado em: ../briefings/briefing-ux.v1.md + ../discovery.md"
```

Isso permite que qualquer IA (ou colega) que encontre um briefing saiba imediatamente de onde ele veio e qual era o estado aprovado dos artefatos anteriores — sem precisar varrer o projeto inteiro.

---

## Estrutura gerada por feature

```
ai/specs/YYYYMMDDHHmmSS_nome_da_feature/
├── inputs/                       ← documentos de entrada fornecidos pelo PM
│   ├── input-01.md               ← conteúdo de URL ou paste (salvo pela skill)
│   └── input-02.md
├── briefings/
│   ├── briefing-ux.v0.md         ← gerado pelo /lf-briefing-ux
│   ├── briefing-ux.v1.md         ← refinamento após review do time UX
│   ├── briefing-tech.v0.md       ← gerado pelo /lf-new-feature
│   └── briefing-tech.v1.md       ← refinamento após review técnico
├── prototype/
│   └── index.html                ← protótipo HTML navegável (gerado pelo /lf-briefing-ux)
├── plans/                        ← planos de execução (opcional)
├── discovery.md                  ← gerado pelo /lf-discovery
├── specs.md                      ← especificações formais
└── wps.md                        ← work packages com dependências e estimativas
```

---

## Estrutura do repositório

```
lifters-skills/
├── skills.json                       ← manifesto para npx skills add
├── install.sh                        ← instalação via curl | bash
├── README.md
├── CHANGELOG.md
├── skills/
│   ├── lf-discovery/
│   │   ├── SKILL.md                  ← /lf-discovery (frontmatter + lógica da skill)
│   │   └── templates/
│   │       └── discovery.md          ← estrutura do artefato discovery
│   ├── lf-briefing-ux/
│   │   ├── SKILL.md                  ← /lf-briefing-ux (frontmatter + lógica da skill)
│   │   └── templates/
│   │       └── briefing-ux.md        ← 11 seções do briefing UX/UI
│   ├── lf-new-feature/
│   │   ├── SKILL.md                  ← /lf-new-feature (frontmatter + lógica da skill)
│   │   └── templates/
│   │       ├── briefing-tech.md      ← 15 seções canônicas do briefing técnico
│   │       ├── specs.md              ← 12 seções por SPEC-XX
│   │       └── wps.md                ← campos e seções por Wp-XX
│   └── lf-design-system/
│       ├── SKILL.md                  ← /lf-design-system (frontmatter + lógica da skill)
│       └── templates/
│           └── design-system.md      ← 15 seções do design system
└── ai/specs/                         ← specs internas do próprio repositório
    └── 20260323142630_google_docs/   ← referência canônica de qualidade (não modificar)
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

- `ai/specs/20260323142630_google_docs/briefings/briefing-ux.v0.md` — referência de qualidade do Briefing UX/UI
- `ai/specs/20260323142630_google_docs/briefings/briefing.v0.md` — referência de qualidade do Briefing Técnico
- `ai/specs/20260323142630_google_docs/specs.md` — referência de qualidade das especificações
- `ai/specs/20260323142630_google_docs/wps.md` — referência de qualidade dos work packages

