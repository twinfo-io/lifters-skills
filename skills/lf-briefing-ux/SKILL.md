---
name: lf-briefing-ux
description: "Generates the UX/UI briefing from an existing discovery.md — personas, screen navigation map, per-screen specs with states and ASCII wireframes, user flows, microcopy, display rules, and visual references. Designed for the UX/UI team to start prototyping without a full technical briefing. Use after /lf-discovery and before /lf-new-feature. Produces briefings/briefing-ux.v0.md (or vN if iterating)."
---

Você é um especialista em UX e produto, atuando como ponte entre o discovery de uma feature e o time de design. Seu papel é transformar o contexto do discovery em um artefato claro e completo para o time de UX/UI — sem ruído técnico de backend, segurança ou infraestrutura.

Gere o Briefing UX/UI com o nível de detalhe e prescrição da referência canônica em `ai/specs/20260323142630_google_docs/briefings/briefing-ux.v0.md`. Leia esse arquivo antes de gerar.

---

## PASSO 1 — Localizar contexto

1. Use a ferramenta Glob para verificar se existe `ai/specs/*/discovery.md` no projeto.

   **Se NÃO existir:** Informe:
   ```
   Nenhum discovery encontrado neste projeto.
   Execute /lf-discovery primeiro para gerar o discovery.md da feature.
   ```
   E encerre — não prossiga sem um discovery.

   **Se existir mais de um:** Liste os encontrados com data e nome, e pergunte qual usar.

2. Leia o `discovery.md` encontrado com a ferramenta Read.

3. Leia todos os arquivos em `inputs/` da mesma pasta (use Glob + Read).

4. Verifique se existe `specs/design-system.md` com a ferramenta Glob.
   - **Se NÃO existir:** Informe:
     ```
     ❌ specs/design-system.md não encontrado.

     O protótipo HTML requer o design system do projeto.
     Execute /lf-design-system primeiro para gerar specs/design-system.md.
     ```
     E encerre — não prossiga sem o design system.
   - **Se existir:** leia com Read. Use para referenciar componentes e tokens na seção 9
     do briefing e para gerar o protótipo HTML no PASSO 5.

5. Verifique se já existe `briefings/briefing-ux.v*.md` na mesma pasta do discovery.
   - Se existir: identifique a versão mais alta (ex: v1) e pergunte:
     ```
     Já existe briefing-ux.v[N].md nesta feature.
     [1] Gerar nova versão v[N+1] (recomendado — mantém o histórico)
     [2] Sobrescrever o v[N] existente
     ```
   - Se não existir: prossiga para gerar v0.

6. Leia a referência canônica de qualidade:
   - `ai/specs/20260323142630_google_docs/briefings/briefing-ux.v0.md`
   - `$CLAUDE_SKILL_DIR/templates/briefing-ux.md`

---

## PASSO 2 — Confirmação de escopo

Apresente ao usuário:

```
Vou gerar o Briefing UX/UI para: [nome da feature]

  Arquivo: ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-ux.v0.md

  Baseado em:
    • discovery.md ([data do discovery])
    [• inputs/input-XX.md (N arquivos)]
    • specs/design-system.md (encontrado — será usado para tokens e protótipo HTML)

  Telas identificadas no discovery: [lista resumida, se identificável]

  Pontos em aberto do discovery que podem virar seção 11:
    ⚠️ [lista, se houver]

Confirma?
```

Aguarde confirmação antes de gerar.

---

## PASSO 3 — Geração do `briefing-ux.v0.md`

Gere `ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-ux.v0.md`.

**Use `$CLAUDE_SKILL_DIR/templates/briefing-ux.md` como estrutura e `ai/specs/20260323142630_google_docs/briefings/briefing-ux.v0.md` como referência de profundidade e prescrição.**

**Header obrigatório — popular com valores reais:**
```markdown
> **Versão:** 0.1
> **Audiência:** Time de UX/UI — designers e frontend
> **Status:** Rascunho
> **Gerado em:** [data atual no formato YYYY-MM-DD]
> **Baseado em:** [`../discovery.md`](../discovery.md) — discovery de [data do discovery]
```

**Regras de qualidade:**

- **Todas as 11 seções devem estar presentes** — se uma seção não for aplicável, incluir com nota "Não aplicável para esta feature — [motivo]".
- **Seção 3 (Mapa de Telas):** grafo ASCII completo de todas as telas e transições identificadas. Toda tela mencionada nas seções seguintes deve aparecer aqui.
- **Seção 4 (Especificação por Tela):** uma subseção `4.X` por tela listada na seção 3. Cada tela DEVE ter:
  - URL/rota
  - Estados explícitos (vazio, carregando, com dados, erro) com descrição do que o usuário vê em cada estado
  - Wireframe ASCII — obrigatório, não omitir
- **Seção 6 (Feedbacks):** tabela completa com todos os eventos de UX identificados. Microcopy prescritivo — textos exatos, não placeholders como "[mensagem de sucesso]".
- **Seção 7 (Condicionalidade):** regras visuais SE/ENTÃO — não regras de negócio de backend.
- **Seção 8 (Conteúdo e Textos):** textos exatos para todos os elementos listados — títulos, botões, estados vazios, tooltips, modais. Não deixar como "[texto]".
- **Seção 9 (Referências):** referenciar componentes por nome usando o `design-system.md` encontrado no PASSO 1.
- **Seção 11 (Pontos em Aberto):** todo `⚠️ Ponto em aberto` do discovery relacionado a UX deve aparecer aqui com responsável.
- **Tom:** direto, prescritivo, orientado ao designer. Sem frases como "o sistema deve" — escrever "o usuário vê", "a tela exibe", "ao clicar em X, aparece Y".
- **Audiência:** exclusivamente UX/UI. Não mencionar banco de dados, APIs, arquitetura, segurança ou infraestrutura — esses tópicos pertencem ao briefing técnico.

---

## PASSO 4 — Confirmação final

Após gerar o arquivo e o protótipo (PASSO 5), apresente:

```
Briefing UX/UI gerado ✓

  ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-ux.v0.md
    [N] telas especificadas · [N] fluxos · [N] pontos em aberto

  Protótipo HTML gerado ✓
    ai/specs/YYYYMMDDHHmmSS_nome/prototype/index.html
      [N] telas navegáveis · [N] estados por tela · mock data inline
      Tokens do design system: specs/design-system.md

[Se houver pontos em aberto:]
Decisões de UX pendentes antes de prototipar:
  ⚠️ U01 — [questão] — responsável: [papel]
  ⚠️ U02 — [questão] — responsável: [papel]

Próximos passos:
  1. Abrir prototype/index.html no browser para revisão visual imediata
  2. Compartilhar com o time de UX/UI para revisão do briefing
  3. Para iterar: peça ao Claude "leia briefing-ux.v0.md e gere v1 com: [mudanças]"
  4. Quando o briefing UX estiver aprovado, execute /lf-new-feature para gerar
     o briefing técnico, especificações e work packages
```

---

## PASSO 5 — Geração do protótipo HTML

Gere `ai/specs/YYYYMMDDHHmmSS_nome/prototype/index.html` como um protótipo navegável de todas as telas descritas no `briefing-ux.vN.md`, usando os tokens do design system em `specs/design-system.md`.

### Fontes de dados (use apenas estas):

- **Seção 3** do briefing (Mapa de Telas) → lista de todas as telas e transições
- **Seção 4** do briefing (Especificação por Tela) → estados, wireframes ASCII, rotas
- **Seção 5** do briefing (Fluxos Principais) → sequência de navegação
- **Seção 6** do briefing (Feedbacks) → toasts, mensagens de erro, loaders
- **Seção 7** do briefing (Condicionalidade) → regras SE/ENTÃO de exibição
- **Seção 8** do briefing (Conteúdo e Textos) → copy exato de todos os elementos
- **Seção 9** do briefing (Referências Visuais) → componentes e padrões visuais
- **`specs/design-system.md`** → tokens de cor, tipografia, espaçamento, radius, sombras

### Estrutura do `index.html`:

**Um único arquivo HTML autocontido** com:

1. **CSS inline no `<head>`:**
   - Bloco `:root` com todos os CSS custom properties extraídos de `specs/design-system.md` (cores, tipografia, espaçamento, border-radius, shadows)
   - Estilos de layout, componentes e estados — sem frameworks externos

2. **Body com todas as telas:** uma `<section>` por tela listada na seção 3 do briefing.
   - Apenas a primeira tela (entry point do fluxo principal) visível por padrão (`display: block`)
   - As demais com `display: none`

3. **Barra de navegação fixa (dev toolbar):**
   - Botões para navegar diretamente entre telas (pelo nome da seção 4)
   - Seletor de estado por tela: Vazio / Carregando / Com dados / Erro
   - Posicionada fora do fluxo do protótipo (ex: bottom bar com fundo contrastante)

4. **JavaScript inline no `<body>`:**
   - Funções para mostrar/ocultar telas ao clicar nos botões da toolbar
   - Funções para alternar estados (vazio, loading, com dados, erro) dentro de cada tela
   - Mock data hard-coded para todos os estados de todas as telas
   - Lógica de feedback: toasts/snackbars da seção 6 simulados via `setTimeout`
   - Regras de condicionalidade da seção 7 implementadas como toggle de classes CSS

### Regras de qualidade do protótipo:

- **Fidelidade ao briefing:** nada além do que está descrito. Se uma tela tem 3 estados no briefing, o protótipo tem exatamente 3 estados — nem mais, nem menos.
- **Tokens obrigatórios:** usar as CSS custom properties do design system para toda cor, tipografia, espaçamento e radius. Proibido usar valores hard-coded que existam como token.
- **Copy exato:** todos os textos (labels, títulos, botões, mensagens, empty states, tooltips) devem ser os textos prescritos na seção 8 do briefing. Sem placeholders como "[texto]".
- **Mock data realista:** dados fictícios mas coerentes com o domínio da feature (ex: nomes, datas, valores no formato correto).
- **Zero funcionalidade real:** nenhuma chamada de API, nenhum `localStorage`, sem formulários que submetam dados. Tudo é visual e navegacional.
- **Sem over-engineering:** sem frameworks (React, Vue, etc.), sem bibliotecas externas, sem build step. HTML + CSS + JS vanilla puro, autocontido no único arquivo.
