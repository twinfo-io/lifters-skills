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

Gera o briefing técnico a partir do `discovery.md` existente. Se não houver discovery prévio, conduz o discovery inline. Se `briefing-ux.vN.md` existir, usa-o para popular personas e UX sem repetir perguntas. Pode ser executado múltiplas vezes para iterar versões.

```bash
/lf-new-feature
```

**O que gera:**

```
ai/specs/YYYYMMDDHHmmSS_nome/
└── briefings/
    └── briefing-tech.vN.md  ← 15 seções canônicas (v0, v1, v2... conforme iterações)
```

---

### `/lf-specs [feature-folder-name]`

Executa após o time de UX/UI entregar as telas finalizadas no Figma. É a skill que fecha o ciclo de planejamento: vincula cada tela do briefing à sua respectiva tela no Figma e gera os artefatos que os developers usam para implementar.

```bash
/lf-specs                             # detecta automaticamente a pasta da feature
/lf-specs 20260323142630_google_docs  # especifica a pasta diretamente (útil com múltiplas features)
```

**Pré-requisitos:**
- `briefing-tech.vN.md` gerado pelo `/lf-new-feature` — a skill aborta sem ele
- Figma MCP Server configurado no Claude Code (**opcional** — sem ele, gera specs/wps sem links visuais)
- URLs das telas do Figma em mãos — o time de UX/UI precisa ter entregue os frames finalizados

**O que acontece, passo a passo:**

1. Verifica se o Figma MCP está conectado — se não estiver, oferece continuar sem Figma
2. Localiza o `briefing-tech.vN.md` mais recente e extrai automaticamente a lista de telas descritas na Seção 6 e no `briefing-ux.vN.md` (se existir)
3. Apresenta a lista de telas e pede uma URL do Figma para cada uma — você pode colar URL com `node-id` por tela (mais preciso) ou uma URL de arquivo único (a skill navega e localiza os frames)
4. Para cada URL fornecida, consulta o Figma MCP: busca metadados do frame, componentes usados, estados/variantes e anotações de design
5. Detecta divergências entre o que o Figma mostra e o que o briefing descreve — lista para revisão
6. Gera `briefing-tech.v(N+1).md`: cópia fiel da versão anterior com dois acréscimos — links inline por tela na Seção 6 e uma nova Seção 16 (tabela de referências de design)
7. Gera `specs.md` com links diretos para cada tela do Figma nas seções "Comportamento esperado" e "Definição de pronto"
8. Gera `wps.md` com todos os work packages, mapa de dependências e oportunidades de paralelização

**O que gera:**

```
ai/specs/YYYYMMDDHHmmSS_nome/
├── briefings/
│   └── briefing-tech.v(N+1).md  ← cópia fiel da versão anterior +
│                                    links Figma inline por tela (Seção 6) +
│                                    Seção 16: tabela de referências de design
├── specs.md                     ← SPEC-XX por domínio · critérios DADO/QUANDO/ENTÃO ·
│                                    links Figma nas seções "Comportamento esperado"
│                                    e "Definição de pronto"
└── wps.md                       ← Wp-XX por unidade de trabalho (1-3d) ·
                                    mapa de dependências · riscos · paralelização
```

**Sem Figma MCP:** a skill ainda gera `specs.md` e `wps.md` completos — apenas sem os links visuais. Você pode re-executar `/lf-specs` depois, com o Figma configurado, para enriquecer os artefatos com as referências.

**Re-execução:** `specs.md` e `wps.md` são sempre sobrescritos — não têm versionamento. `briefing-tech.v(N+1).md` é sempre um novo arquivo, preservando o histórico.

---

### `/lf-exec`

Inicia a execução de um work package a partir do `wps.md` gerado pelo `/lf-specs`. Conduz o desenvolvedor pelo processo completo: seleção da spec e do WP, atualização do projeto, criação de branch e disparo do prompt de implementação. Sem argumentos — fluxo totalmente interativo.

```bash
/lf-exec
```

**Pré-requisito:** `wps.md` gerado pelo `/lf-specs` em `specs/YYYYMMDDHHmmSS_nome/`.

**O que acontece, passo a passo:**

1. Lista todas as specs com `wps.md` disponíveis em `specs/` — você escolhe qual executar
2. Lista apenas os WPs **pendentes** da spec escolhida (os com `✅ Concluido` são omitidos) — você escolhe qual iniciar
3. Detecta se o projeto usa git submodules e orienta a atualização correta:
   - Com submodules: `git --no-pager submodule update --init --recursive`
   - Sem submodules: `git pull origin main`
4. Pergunta se você quer criar uma nova branch (`features/<iniciais>/<nome_semantico>`) ou usar a branch atual
5. Dispara o prompt padronizado de execução para o WP selecionado, referenciando o `wps.md` correto

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

## Configurando o Figma MCP

O `/lf-specs` e o `/lf-design-system` usam o **Figma MCP Server** para ler dados diretamente do Figma. Sem ele as skills funcionam em modo degradado — sem extrair tokens de design nem links visuais.

### Instalação

O Figma MCP Server oficial está disponível em [npmjs.com/package/@figma/mcp-server](https://www.npmjs.com/package/@figma/mcp-server).

Adicione ao seu `~/.claude/settings.json` (ou via **Claude Code → Settings → MCP Servers**):

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@figma/mcp-server"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "seu-token-aqui"
      }
    }
  }
}
```

### Obtendo o token do Figma

1. Acesse [figma.com → Settings → Security](https://www.figma.com/settings)
2. Role até **Personal access tokens** → clique em **Generate new token**
3. Dê um nome (ex: `claude-code-mcp`), escolha escopo `File content: Read only`
4. Copie o token gerado (começa com `figd_...`) — ele só aparece uma vez
5. Cole no `FIGMA_ACCESS_TOKEN` do `settings.json`

### Verificando a conexão

No Claude Code, execute qualquer skill que use o Figma (ex: `/lf-specs`) — ela chama `whoami` internamente e confirma a conexão antes de prosseguir. Se falhar, revise o token e reinicie o Claude Code.

### Como copiar a URL correta de uma tela no Figma

O `/lf-specs` aceita dois formatos:

**URL com node-id (recomendado — mais preciso):**

No Figma, clique com o botão direito no frame da tela → **Copy link to selection**. A URL terá o formato:
```
https://figma.com/design/AbC123xYz/Nome-do-Arquivo?node-id=42-816
```
Cole esta URL quando a skill pedir — ela extrai o `fileKey` (`AbC123xYz`) e o `nodeId` (`42:816`) automaticamente.

**URL de arquivo (fallback — para quem não tem node-ids específicos):**

Cole a URL raiz do arquivo (sem `node-id`). A skill navega pela estrutura do arquivo e tenta localizar os frames pelo nome das telas descritas no briefing. Menos preciso, mas funciona.

---

## Fluxo completo de uso

O fluxo AI-Native da Lifters segue quatro etapas. Cada etapa gera um artefato que alimenta a próxima — nenhuma skill repete perguntas já respondidas.

```
                        ┌─ /lf-design-system ──────────────────┐
                        │  (antes do /lf-briefing-ux)          │
                        ▼                                       │
/lf-discovery     specs/design-system.md                       │
      │                 │                                       │
      ▼                 ▼                                       │
 discovery.md ──► /lf-briefing-ux ◄────────────────────────────┘
      │                 │
      │                 ▼
      │          briefing-ux.v0.md
      │          prototype/index.html
      │                 │
      │         [revisão UX/UI]
      │                 │
      │          briefing-ux.v1.md  (se refinado)
      │                 │
      └────────────────►│
                        ▼
                  /lf-new-feature  ◄── pode iterar N vezes
                        │
                        ▼
               briefing-tech.v0.md
               briefing-tech.v1.md  (se refinado)
                        │
               [time UX/UI finaliza telas no Figma]
                        │
                        ▼
                   /lf-specs  ◄── requer Figma MCP + URLs das telas
                        │
                        ▼
           briefing-tech.v(N+1).md  (+ Seção 16 Figma)
           specs.md
           wps.md
```

### Etapa 0 — Design System `/lf-design-system`

Execute uma vez por projeto, antes do `/lf-briefing-ux`. Extrai todos os tokens visuais do Figma (tipografia, cores, espaçamento, sombras) e gera `specs/design-system.md` — a fonte de verdade visual que o `/lf-briefing-ux` usa para gerar o protótipo HTML.

```bash
/lf-design-system "Atlas" https://figma.com/design/abc123/Atlas?node-id=3-281
```

**Pré-requisito:** Figma MCP configurado. **Resultado:** `specs/design-system.md`

---

### Etapa 1 — Discovery `/lf-discovery`

Conduza o discovery antes de qualquer outra skill de feature. O `discovery.md` é o único ponto de entrada de contexto — tudo que as skills seguintes geram parte dele.

```bash
/lf-discovery "Cobrança recorrente com Stripe"
```

Colete documentos existentes (Google Docs, Notion, texto colado), responda as perguntas sobre greenfield vs. brownfield, lacunas técnicas e personas. A skill pesquisa referências de mercado automaticamente.

**Resultado:** `ai/specs/YYYYMMDDHHmmSS_nome/discovery.md`

---

### Etapa 2 — Briefing UX/UI `/lf-briefing-ux`

Execute após ter o `discovery.md` **e** o `specs/design-system.md`. Gera o briefing para o time de UX/UI e um protótipo HTML navegável com mocks — sem precisar ler o discovery completo nem esperar o briefing técnico.

```bash
/lf-briefing-ux
```

A skill lê o `discovery.md` e o `specs/design-system.md` automaticamente, gera o briefing UX com todas as telas, wireframes ASCII e microcopy prescritivo, e em seguida gera o `prototype/index.html` com todas as telas navegáveis e os tokens do design system aplicados.

**Resultado:**
- `ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-ux.v0.md`
- `ai/specs/YYYYMMDDHHmmSS_nome/prototype/index.html`

---

### Etapa 3 — Briefing Técnico `/lf-new-feature`

Execute após o `briefing-ux.v0.md` estar revisado pelo time de UX. A skill detecta e lê automaticamente o briefing UX mais recente para popular as seções de personas e UX do briefing técnico.

```bash
/lf-new-feature
```

Pode ser executado múltiplas vezes para iterar o briefing (`v0`, `v1`, `v2`...) conforme o time técnico revisa e refina. **Não gera specs nem WPs** — esses artefatos só são criados na Etapa 4, quando as telas do Figma estiverem prontas.

Ao final de cada execução, lista automaticamente decisões técnicas que possam impactar o Briefing UX/UI — para que você decida se uma nova versão de UX é necessária antes de seguir.

**Resultado:**
```
briefings/briefing-tech.v0.md  ← 15 seções técnicas
```

---

### Etapa 4 — Specs + WPs com Figma `/lf-specs`

Execute quando o time de UX/UI entregar as telas finalizadas no Figma. Esse é o passo que transforma o planejamento em execução — o developer que pegar um WP vai ter link direto para a tela que precisa implementar.

```bash
/lf-specs
```

**O que acontece na prática:**

A skill lê o `briefing-tech.vN.md` mais recente, analisa a Seção 6 (UX) e o `briefing-ux.vN.md` (se existir) e monta automaticamente a lista de telas da feature. Então pede uma URL do Figma para cada tela:

```
Identifiquei 4 telas nesta feature. Preciso da URL do Figma para cada uma.

Cole a URL do Figma (figma.com/design/...) para cada tela.
Se uma tela ainda não tem design no Figma, digite "–" para pular.

  [1] Tela de Configuração (/settings/integrations)
      URL Figma:
  [2] Modal de Conexão OAuth
      URL Figma:
  [3] Estado Vazio — sem integração configurada
      URL Figma:
  [4] Estado de Erro — falha na autenticação
      URL Figma:
```

Para cada URL fornecida, a skill consulta o Figma MCP e extrai: nome do frame, componentes usados, estados/variantes existentes e anotações de design. Se detectar divergências entre o que o Figma mostra e o que o briefing descreve, lista para revisão antes de gerar os artefatos.

**Resultado:**
```
briefings/briefing-tech.v1.md  ← cópia fiel da v0 com acréscimos:
                                  · Seção 6: link Figma após cada tela
                                  · Seção 16 (nova): tabela completa de referências
specs.md                       ← SPECs por domínio com links Figma inline:
                                  · "Comportamento esperado": → link para a tela
                                  · "Definição de pronto": validado contra Figma ✓
wps.md                         ← WPs com estimativas, dependências, mapa ASCII
```

**Se o Figma MCP não estiver configurado:** a skill avisa e pergunta se deve continuar sem referências visuais. Os artefatos gerados ficam funcionais — apenas sem os links do Figma. Você pode re-executar `/lf-specs` depois, já com o Figma configurado, que os arquivos são regenerados com as referências.

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

Todos os briefings gerados incluem headers de referência cruzada. Qualquer IA (ou colega) que abra um arquivo sabe imediatamente de onde ele veio:

```
discovery.md
    ↑
briefing-ux.v0.md     "Baseado em: ../discovery.md"
    ↑
briefing-tech.v0.md   "Baseado em: briefing-ux.v0.md + ../discovery.md"
    ↑
briefing-tech.v1.md   "Baseado em: ./briefing-tech.v0.md (com refs Figma)"
                           ← este é o gerado pelo /lf-specs
```

O `briefing-tech.vN.md` gerado pelo `/lf-specs` é identificável na cadeia porque referencia seu parent imediato dentro da pasta `briefings/` — não o `discovery.md` diretamente. Isso marca explicitamente o ponto em que as referências visuais entraram no planejamento.

---

## Estrutura gerada por feature

```
ai/specs/YYYYMMDDHHmmSS_nome_da_feature/
├── inputs/                       ← documentos de entrada fornecidos pelo PM
│   ├── input-01.md               ← conteúdo de URL ou paste (salvo pela skill)
│   └── input-02.md
├── briefings/
│   ├── briefing-ux.v0.md         ← /lf-briefing-ux: personas, telas, wireframes, microcopy
│   ├── briefing-ux.v1.md         ← refinamento após review do time UX (opcional)
│   ├── briefing-tech.v0.md       ← /lf-new-feature: 15 seções técnicas (rascunho)
│   ├── briefing-tech.v1.md       ← /lf-new-feature: 15 seções (após review técnico)
│   └── briefing-tech.v2.md       ← /lf-specs: v1 + links Figma inline + Seção 16
├── prototype/
│   └── index.html                ← /lf-briefing-ux: protótipo HTML navegável
├── plans/                        ← planos de execução (opcional)
├── discovery.md                  ← /lf-discovery: contexto, personas, decisões
├── specs.md                      ← /lf-specs: SPEC-XX com critérios e links Figma
└── wps.md                        ← /lf-specs: Wp-XX com estimativas e dependências
```

O número de versões do `briefing-tech` varia por feature: uma feature simples pode ter só v0 e v1 (gerado pelo `/lf-specs`). Uma feature complexa pode ter v0, v1, v2 de iterações técnicas antes do `/lf-specs` gerar o v3 final com Figma.

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
│   ├── lf-specs/
│   │   ├── SKILL.md                  ← /lf-specs (frontmatter + lógica da skill)
│   │   └── templates/
│   │       ├── briefing-tech.md      ← template do briefing técnico com Seção 16
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

