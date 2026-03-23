# lifters-ai

Skills de Claude Code para times de produto da Lifters. Padroniza o processo de criação de features — do discovery inicial à geração de briefing, especificações e work packages — em todos os projetos da empresa.

---

## Instalação

**Via registry (recomendado):**
```bash
npx skills add lifters/lifters-ai
```

**Via script (fallback):**
```bash
curl -sSL https://raw.githubusercontent.com/lifters/lifters-ai/main/install.sh | bash
```

**Via clone local (para contribuição):**
```bash
git clone https://github.com/lifters/lifters-ai.git ~/.lifters-ai
bash ~/.lifters-ai/install.sh
```

As skills são instaladas em `~/.claude/commands/` e ficam disponíveis em **todos os projetos** da máquina.

---

## Atualização

```bash
npx skills update lifters/lifters-ai
```

---

## Comandos

### `/discovery`

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
lifters-ai/
├── skills.json           ← manifesto para npx skills add
├── install.sh            ← instalação via curl | bash
├── README.md
├── CHANGELOG.md
├── commands/
│   ├── discovery.md      ← /discovery
│   └── new-feature.md    ← /new-feature
├── templates/
│   ├── discovery.md      ← estrutura do artefato discovery
│   ├── briefing.md       ← 15 seções canônicas do briefing
│   ├── specs.md          ← 12 seções por SPEC-XX
│   └── wps.md            ← campos e seções por Wp-XX
└── ai/specs/             ← specs internas do próprio repositório
```

---

## Contribuindo

Para adicionar uma nova skill ao repositório:

1. Crie `commands/nome-da-skill.md` com as instruções do comando
2. Adicione a entrada correspondente em `skills.json`
3. Documente no `README.md` e no `CHANGELOG.md`
4. Abra um PR — o time revisa antes de publicar

Convenção de nomes: `kebab-case`, verbos no imperativo em inglês (`gen-docs`, `review-pr`, `update-spec`).

---

## Referências canônicas

Os templates e commands usam os arquivos abaixo como exemplos de qualidade — **não modificar**:

- `ai/specs/00001_google_docs/briefings/briefing.v0.md`
- `ai/specs/00001_google_docs/specs.md`
- `ai/specs/00001_google_docs/wps.md`
