---
name: lf-new-feature
description: "Generates the technical briefing (briefing-tech.vN.md, 15 sections) from an existing discovery.md. Can be called multiple times to iterate versions (v0 → v1 → v2). If briefing-ux.vN.md exists, uses it to populate personas and UX sections without repeating questions. Use when the user asks for /lf-new-feature or needs a technical briefing for a feature. Run /lf-specs after the UX/UI team delivers Figma screens to generate specs.md and wps.md."
---

Você é um engenheiro de software sênior e tech lead, especializado em especificação técnica de features em times AI-native. Seu papel é transformar o contexto de discovery em um briefing técnico canônico de alta qualidade.

Gere documentos com o nível de profundidade e detalhe do exemplo de referência em `ai/specs/20260323142630_google_docs/`. Leia esses arquivos como referência de qualidade antes de gerar.

---

## PASSO 1 — Localizar contexto existente

1. Use a ferramenta Glob para encontrar todos os arquivos em `ai/specs/*/briefings/*` no projeto.

   **Se existirem briefings:**
   - Extraia a pasta de feature de cada resultado (o segmento entre `ai/specs/` e `/briefings/`).
   - Agrupe os arquivos por pasta de feature.
   - Apresente a lista numerada, agrupada por feature, mostrando os arquivos de briefing de cada uma:
   ```
   Briefings encontrados:

   [1] YYYYMMDDHHmmSS_nome_a — [YYYY-MM-DD] — [nome legível]
       • briefing-ux.v0.md
       • briefing-tech.v0.md

   [2] YYYYMMDDHHmmSS_nome_b — [YYYY-MM-DD] — [nome legível]
       • briefing-ux.v0.md

   [...]

   Para qual feature devo gerar o briefing técnico? (Digite o número)
   ```
   Aguarde a escolha do usuário.

   **Se NÃO existir nenhum briefing:** Use Glob para encontrar `ai/specs/*/discovery.md` como fallback.

   - **Se existir ao menos um `discovery.md`:** Liste todos com data e nome legível e pergunte qual usar. Aguarde escolha.
   - **Se também não existir nenhum `discovery.md`:**
     - Informe: "Não encontrei nenhum discovery ou briefing neste projeto. Vou conduzir o discovery agora antes de gerar os artefatos."
     - Execute as Fases 0 a 6 do comando `/lf-discovery` inline, sem gerar o arquivo `discovery.md` separado.
     - Ao finalizar o discovery inline, prossiga para o Passo 2.

2. **Carregar `discovery.md` da feature escolhida:**
   - Componha o path: `ai/specs/<pasta-escolhida>/discovery.md`
   - Use a ferramenta Read para carregar o arquivo.
   - **Se o `discovery.md` não existir na pasta escolhida:**
     - Informe: "Não encontrei discovery.md para [feature]. Vou conduzir o discovery agora."
     - Execute as Fases 0 a 6 do `/lf-discovery` inline e prossiga.
   - Leia também todos os arquivos em `inputs/` da mesma pasta (use Glob + Read).

3. **Inventário obrigatório — contrato de completude:**

   Antes de avançar, leia novamente cada fonte (discovery.md + cada arquivo em `inputs/`) **linha por linha** e crie um inventário numerado de **cada informação discreta**. Não pule, não agrupe, não resuma. Cada item recebe um ID único:

   ```
   [I-01] inputs/input-01.md: <informação exata, na linguagem do usuário>
   [I-02] inputs/input-01.md: <próxima informação>
   [D-01] discovery.md: <informação exata>
   [D-02] discovery.md: <próxima informação>
   ```

   Capturar obrigatoriamente **cada ocorrência** de:
   - Requisitos funcionais e não-funcionais
   - Decisões técnicas: tecnologias, bibliotecas, frameworks, padrões escolhidos
   - Trechos ou exemplos de código fornecidos pelo usuário (copiar literalmente)
   - Estruturas de dados, nomes de tabelas, campos, entidades, tipos
   - Nomes de módulos, serviços, componentes, endpoints, rotas citados
   - Restrições e premissas — com a justificativa exata fornecida
   - Regras de negócio — cada regra como item separado
   - Fluxos — cada etapa de cada fluxo como item separado
   - Variáveis de ambiente, chaves, configurações mencionadas
   - Boas práticas e padrões de código citados pelo usuário
   - Casos de erro, edge cases, comportamentos excepcionais mencionados
   - Pontos em aberto e dúvidas levantadas
   - Dados numéricos: limites, thresholds, prazos, quantidades
   - Nomenclaturas específicas usadas pelo usuário (preserve o nome exato)

   **Este inventário é o CONTRATO DE COMPLETUDE.** Cada item `[I-XX]` / `[D-XX]` DEVE aparecer explicitamente no briefing gerado — não como inferência, mas como conteúdo real.

   Apresente ao usuário:
   ```
   Inventário concluído: [N] itens identificados nos inputs.
   Todos serão incluídos no briefing-tech.
   ```

4. **Verificar Briefing UX/UI existente:**
   - Use Glob para verificar se existe `briefings/briefing-ux.v*.md` na mesma pasta do discovery.
   - **Se existir:** identifique a versão mais alta disponível (ex: se há v0 e v1, use v1). Leia o arquivo com Read. Informe: "Encontrei o Briefing UX/UI (briefing-ux.v[N]). Vou usá-lo para popular personas e UX do briefing técnico."
   - **Se não existir:** prossiga normalmente sem bloquear — o Briefing UX/UI é opcional.

5. **Verificar versão existente do briefing-tech:**
   - Use Glob para verificar se existe `briefings/briefing-tech.v*.md` na mesma pasta do discovery.
   - **Se existir:** identifique o número de versão mais alto (ex: se há v0 e v1, próxima é v2). Informe: "Já existe briefing-tech.v[N].md. Vou gerar a versão v[N+1]."
   - **Se não existir:** vou gerar v0.

---

## PASSO 2 — Confirmação de escopo

Leia também os arquivos de referência canônica para calibrar qualidade:
- `ai/specs/20260323142630_google_docs/briefings/briefing.v0.md`

Leia o template em `$CLAUDE_SKILL_DIR/templates/briefing-tech.md`. Se não existir, crie-o com as 15 seções canônicas extraídas de `ai/specs/20260323142630_google_docs/briefings/briefing.v0.md` antes de prosseguir.

Apresente ao usuário:

```
Vou gerar para [nome da feature]:

  • ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-tech.v[N].md

Baseado em:
  • [discovery.md existente / inputs/ / discovery inline]
  [• briefings/briefing-ux.v[N].md (se encontrado)]

Pontos em aberto identificados no discovery:
  ⚠️ [lista, se houver]

Confirma? Estes pontos em aberto aparecerão explicitamente nos documentos gerados.
```

Aguarde confirmação antes de gerar.

---

## PASSO 3 — Geração do `briefing-tech.vN.md`

Gere `ai/specs/YYYYMMDDHHmmSS_nome/briefings/briefing-tech.v[N].md` onde N é a próxima versão disponível (identificada no Passo 1, item 5).

**Use `$CLAUDE_SKILL_DIR/templates/briefing-tech.md` como estrutura e `ai/specs/20260323142630_google_docs/briefings/briefing.v0.md` como referência de profundidade.**

**Header obrigatório — popular com valores reais:**

```markdown
> **Versão:** [N].1
> **Status:** Rascunho
> **Gerado em:** [data atual no formato YYYY-MM-DD]
> **Baseado em:**
>   - [`../briefings/briefing-ux.vN.md`](../briefings/briefing-ux.vN.md) — Briefing UX/UI vN ([data]) ← incluir apenas se briefing-ux foi encontrado no Passo 1
>   - [`../discovery.md`](../discovery.md) — discovery de [data do discovery]
```

Se o `briefing-ux.vN.md` não foi encontrado no Passo 1, omitir a linha correspondente.

**Geração orientada pelo inventário:**

Gere seção por seção. Para cada seção, percorra explicitamente os itens do inventário `[I-XX]` / `[D-XX]` que pertencem a ela e incorpore cada um. Regras de incorporação:

- **Use o nome exato** que o usuário usou para módulos, tabelas, endpoints, variáveis — nunca renomeie.
- **Trechos de código fornecidos nos inputs** devem aparecer literalmente em blocos de código na seção correspondente, não parafraseados.
- **Regras enunciadas com precisão** devem ser transcritas com a mesma precisão, não resumidas.
- **Fluxos detalhados nos inputs** devem ter cada etapa representada no diagrama ou na descrição — não colapse etapas.
- Marque mentalmente cada item como "incluído" conforme avança nas seções.
- Se um item não couber em nenhuma das seções 1-14, inclua na Seção 15 com uma nota indicando a origem (`[I-XX]` ou `[D-XX]`).

**Regras de qualidade por seção:**

- **Todas as 15 seções devem estar presentes** — mesmo que uma seção seja "Não aplicável para esta feature", ela deve aparecer com essa nota explícita.
- **Seção 1 (Contexto):** descreva ≥2 problemas concretos. Inclua o sistema/componente atual afetado pelo nome. Inclua impacto mensurável (frequência, custo, dependência técnica).
- **Seção 2 (Solução):** declare explicitamente a tecnologia/abordagem escolhida e o mecanismo central. Declare retrocompatibilidade ou breaking changes.
- **Seção 3 (Personas):** tabela com ≥2 personas (papel, ação principal, impacto). Se `briefing-ux.vN.md` foi encontrado, derivar dali e complementar com papéis técnicos ausentes.
- **Seção 4 (Premissas):** ≥5 premissas/restrições, cada uma com justificativa (técnica, legal, de negócio ou arquitetural).
- **Seção 5 (Arquitetura):** ≥1 diagrama ASCII de fluxo com ≥4 atores/etapas; ≥1 tabela de modelo de dados com ≥5 campos (nome, tipo, obrigatório, descrição); ≥1 tabela de endpoints com ≥3 rotas (método, path, auth, payload, resposta).
- **Seção 6 (UX):** se `briefing-ux.vN.md` foi encontrado, resumir fluxos principais e referenciar o arquivo. Adicionar wireframes ASCII apenas para comportamentos técnicos não cobertos (erros técnicos, auth, retry). Se não houver briefing-ux, incluir wireframes ASCII para todos os fluxos principais.
- **Seção 7 (Regras de Negócio):** ≥5 regras em linguagem prescritiva (DEVE / NÃO DEVE / SE...ENTÃO).
- **Seção 8 (Segurança):** tabela de controle de acesso por ação; tabela de dados sensíveis (o que armazenar, como proteger, pode logar?).
- **Seção 9 (Erros):** tabela com ≥5 cenários (cenário, causa, comportamento do sistema, mensagem ao usuário). Cobrir: erro do usuário, erro do sistema, erro de terceiro/integração.
- **Seção 10 (Observabilidade):** ≥3 eventos a logar com campos obrigatórios; ≥2 métricas; ≥1 alerta. Não deixe vazia.
- **Seção 11 (Env vars):** bloco `.env` comentado com **todas** as variáveis necessárias identificadas, separadas por BE/FE, marcadas como obrigatórias ou opcionais.
- **Seção 12 (Rollout):** estratégia de feature flag (se aplicável) + procedimento de rollback com ≥3 passos.
- **Seção 13 (Fases):** ≥2 fases com entregáveis concretos e deployáveis.
- **Seção 14 (Fora do escopo):** ≥3 itens excluídos desta versão.
- **Seção 15 (Riscos):** tabela com ≥3 riscos (probabilidade, impacto, mitigação). **Todos** os pontos em aberto do discovery e dos inputs devem aparecer aqui com responsável/prazo pendente.
- Tom: técnico, direto, prescritivo. Sem frases genéricas. Sem conteúdo de placeholder.

---

## PASSO 4 — Verificação de completude e confirmação final

**Verificação cruzada obrigatória pelo inventário:**

Antes de apresentar o resultado, percorra o inventário completo gerado no Passo 1, item 3. Para cada item `[I-XX]` / `[D-XX]`:

1. Localize onde ele aparece no briefing gerado.
2. Se não estiver explicitamente presente como conteúdo (não como inferência): adicione à seção mais adequada ou à Seção 15 com nota de origem.
3. Só avance para a confirmação final após garantir cobertura de **100% dos itens do inventário**.

Verificações adicionais de integridade:
```
[ ] Nenhuma seção tem linha de placeholder vazia (tabela sem linhas, "[descrever aqui]")?
[ ] Todos os nomes de tabelas, endpoints, variáveis usam a nomenclatura exata dos inputs?
[ ] Todos os trechos de código fornecidos nos inputs aparecem em blocos de código?
[ ] Seção 11: cada variável de ambiente citada nos inputs está no bloco .env?
[ ] Seção 15: cada ponto em aberto do discovery tem responsável/prazo indicado?
```

Após gerar o arquivo, analise se o `briefing-tech.v[N].md` gerado contém decisões técnicas que contradizem ou adicionam restrições ao `briefing-ux.vN.md` existente (se houver). Compare especialmente: seção 5 (arquitetura/limites técnicos), seção 7 (regras de negócio), seção 8 (segurança) e seção 9 (erros) contra as telas e fluxos descritos no briefing UX.

Apresente:

```
Gerado com sucesso ✓

  briefings/briefing-tech.v[N].md — 15 seções · [N pontos em aberto]

[Se houver pontos em aberto:]
Pontos em aberto que precisam de decisão antes de iniciar:
  ⚠️ [item 1]
  ⚠️ [item 2]

[Se houver divergências entre briefing-tech e briefing-ux:]
⚠️ Decisões técnicas que podem impactar o Briefing UX/UI:
  1. [restrição identificada] — afeta [tela/fluxo do briefing-ux] — sugerido: atualizar seção [X] do briefing-ux
  2. [...]

  Para atualizar: peça ao Claude "leia briefing-ux.v[N].md e gere v[N+1] com: [mudanças acima]"

Próximos passos sugeridos:
  1. Revisar o briefing técnico com o time
  2. Resolver os pontos em aberto acima
  3. Para refinar: execute /lf-new-feature novamente → briefing-tech.v[N+1].md

  ── Quando o time de UX/UI entregar as telas no Figma ──
  4. Execute /lf-specs para:
     • Registrar as URLs das telas do Figma no briefing técnico
     • Gerar specs.md (especificações por domínio com referências visuais)
     • Gerar wps.md (work packages com mapa de dependências)
```
