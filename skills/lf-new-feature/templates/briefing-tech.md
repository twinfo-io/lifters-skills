# Briefing Técnico — [Nome da Feature]

> **Versão:** 0.1
> **Status:** Rascunho | Em revisão | Aprovado
> **Gerado em:** [YYYY-MM-DD]
> **Baseado em:**
>   - [`../briefings/briefing-ux.vN.md`](../briefings/briefing-ux.vN.md) — Briefing UX/UI vN ([YYYY-MM-DD])
>   - [`../discovery.md`](../discovery.md) — discovery de [YYYY-MM-DD]

<!-- Remover a linha do briefing-ux se não houver Briefing UX/UI para esta feature -->

---

## 1. Contexto e Problema

<!-- OBRIGATÓRIO: Descreva ≥2 problemas concretos.
     - Nomeie o sistema/componente atual afetado (ex: "o módulo pdf-generator.ts")
     - Inclua frequência e impacto mensurável (ex: "qualquer alteração exige deploy")
     - Inclua TUDO que foi descrito pelo usuário e pelo discovery — não sumarize.
     O que acontece se não resolvermos? -->

---

## 2. Solução Proposta

<!-- O que vamos construir — em uma frase clara.
     Seguido do que NÃO vamos construir nesta versão.
     Retrocompatibilidade: o sistema atual continua funcionando? Como? -->

---

## 3. Personas e Papéis Afetados

<!-- Quem usa, quem configura, quem é impactado indiretamente.
     Inclua papéis técnicos e de negócio.
     Se houver briefing-ux.vN.md, derivar dali e complementar com papéis técnicos. -->

| Papel | Ação que realiza | Impacto da feature |
|-------|------------------|--------------------|
| [ex: admin] | [configura templates] | [direto — controla a feature] |
| [ex: usuário] | [gera documentos] | [direto — usa o resultado] |

---

## 4. Premissas, Restrições e Decisões Tomadas

<!-- OBRIGATÓRIO: ≥5 itens, cada um com justificativa.
     Tipos: técnica | legal | negócio | arquitetural | produto
     Inclua TODAS as restrições mencionadas pelo usuário ou identificadas no discovery. -->

- **[Premissa/Restrição]:** [descrição e justificativa] *(origem: técnica/legal/negócio)*

---

## 5. Arquitetura e Fluxos

<!-- OBRIGATÓRIO:
     5.1 — ≥1 diagrama ASCII com ≥4 atores/etapas
     5.2 — ≥1 tabela de modelo de dados com ≥5 campos
     5.3 — ≥1 tabela de endpoints com ≥3 rotas
     5.4 — listar todas as integrações externas identificadas (APIs, SDKs, serviços)
     Inclua TODOS os detalhes técnicos mencionados pelo usuário ou no discovery. -->

### 5.1 Fluxo principal

```
[Ator] → [Ação] → [Sistema] → [Resultado]
         ↓
[Ator] → [Ação] → [Serviço externo] → [Resposta]
```

### 5.2 Modelo de dados

<!-- ≥5 campos. Não deixe linha vazia — se não souber o tipo exato, use "a definir" e marque na Seção 15. -->

| Campo | Entidade | Tipo | Obrigatório | Descrição |
|-------|----------|------|-------------|-----------|

### 5.3 Endpoints

<!-- ≥3 rotas. Inclua autenticação esperada (JWT, API key, sessão, webhook-sig). -->

| Método | Path | Auth | Payload resumido | Resposta |
|--------|------|------|------------------|----------|

### 5.4 Integrações externas

<!-- Listar todas as APIs, SDKs ou serviços de terceiros envolvidos. -->

| Serviço | Finalidade | SDK / Versão | Autenticação |
|---------|-----------|--------------|--------------|

---

## 6. UX e Comportamento da Interface

<!-- Se há briefing-ux.vN.md: resumir os fluxos principais e referenciar o arquivo.
     Adicionar wireframes ASCII apenas para comportamentos técnicos não cobertos no UX
     (estados de erro técnico, fluxos de autenticação, retry, etc.).
     Se não há briefing-ux: incluir wireframes ASCII completos para os fluxos principais.
     Validações visíveis ao usuário (mensagens de erro, tooltips).
     Referências visuais: "seguindo o padrão de X (Slack, Linear, etc.)". -->

<!-- Se briefing-ux existir, adicionar referência: -->
<!-- Ver detalhamento completo de telas e fluxos em: ../briefings/briefing-ux.vN.md -->

### 6.1 Estados da interface

```
[Estado vazio]        → [o que o usuário vê]
[Estado carregando]   → [o que o usuário vê]
[Estado sucesso]      → [o que o usuário vê]
[Estado erro]         → [o que o usuário vê]
```

### 6.2 Wireframe

```
┌──────────────────────────────────────────┐
│  [componente]                            │
│                                          │
└──────────────────────────────────────────┘
```

---

## 7. Regras de Negócio

<!-- OBRIGATÓRIO: ≥5 regras. Linguagem prescritiva:
     DEVE     — obrigatório
     NÃO DEVE — proibido
     PODE     — opcional/permitido
     SE...ENTÃO — condicional
     Inclua TODAS as regras identificadas no discovery e nos inputs — não omita nenhuma. -->

1. [Papel] DEVE [fazer X] para [contexto].
2. O sistema NÃO DEVE [fazer Y] quando [condição].
3. SE [condição] ENTÃO [comportamento].
4.
5.

---

## 8. Segurança e Privacidade

<!-- RBAC: quem pode fazer o quê — seja explícito por papel.
     Dados sensíveis: o que não pode ser logado, o que precisa criptografar.
     Auditoria: quais ações precisam de log rastreável.
     Validação de entrada: o que o servidor valida independente do frontend. -->

### 8.1 Controle de acesso

| Ação | Papel permitido | Papel bloqueado |
|------|-----------------|-----------------|

### 8.2 Dados sensíveis

| Dado | Onde armazenar | Criptografia | Pode logar? |
|------|---------------|--------------|-------------|

---

## 9. Tratamento de Erros e Resiliência

<!-- OBRIGATÓRIO: ≥5 cenários. Cobrir as 3 categorias:
     • Erro do usuário (input inválido, permissão negada)
     • Erro do sistema (timeout, banco indisponível)
     • Erro de terceiro/integração (API externa fora do ar, token expirado)
     Inclua TODOS os cenários de falha identificados no discovery e nos inputs. -->

| Cenário | Causa | HTTP | Comportamento do sistema | Mensagem ao usuário |
|---------|-------|------|--------------------------|---------------------|

---

## 10. Observabilidade

<!-- OBRIGATÓRIO: não deixar nenhuma subseção vazia.
     10.1 — ≥3 eventos (use snake_case para nomes)
     10.2 — ≥2 métricas (contador, gauge ou histograma)
     10.3 — ≥1 alerta com condição e threshold definidos -->

### 10.1 Eventos a logar

| Evento | Campos obrigatórios | Nível |
|--------|---------------------|-------|
| [ex: feature_action_success] | [user_id, timestamp, contexto] | info |

### 10.2 Métricas

| Métrica | Tipo | O que mede |
|---------|------|------------|

### 10.3 Alertas

| Condição | Threshold | Ação |
|----------|-----------|------|

---

## 11. Variáveis de Ambiente e Configuração

<!-- Bloco .env comentado com todas as variáveis necessárias.
     Indicar: obrigatória (✱) vs opcional, backend (BE) vs frontend (FE).
     Nunca incluir valores reais — apenas exemplos/placeholders. -->

```env
# [Serviço] — obrigatórias
✱ VARIAVEL_1=exemplo          # BE — descrição do que faz
✱ VARIAVEL_2=exemplo          # BE — descrição do que faz

# [Serviço] — frontend (públicas)
✱ NEXT_PUBLIC_VARIAVEL=exemplo  # FE — descrição

# Criptografia / segurança
✱ ENCRYPTION_KEY=base64-32-bytes  # BE — chave AES-256 para tokens
```

---

## 12. Estratégia de Rollout e Rollback

<!-- Feature flag? Se sim, qual o mecanismo (env var, banco, serviço)?
     Rollout gradual: por % de usuários, por tenant, por plano?
     Como desativar em produção sem rollback de banco?
     Rollback: se der errado, como reverter? Quais dados são afetados? -->

**Rollout:** [descrição da estratégia]

**Rollback:** [como desfazer — feature flag off, migration down, etc.]

---

## 13. Fases de Entrega

<!-- Divisão incremental onde cada fase entrega valor observável.
     Cada fase deve ser deployável independentemente. -->

### Fase 1 — [Nome]
- [ ] [Entregável 1]
- [ ] [Entregável 2]

### Fase 2 — [Nome]
- [ ] [Entregável 1]

---

## 14. Fora do Escopo (desta versão)

<!-- Itens explicitamente excluídos — o que NÃO faremos agora.
     Inclui itens que foram considerados e descartados. -->

- [Item 1] — [motivo ou "previsto para versão futura"]
- [Item 2]

---

## 15. Riscos e Pontos em Aberto

<!-- OBRIGATÓRIO: ≥3 riscos na tabela.
     Todos os pontos em aberto do discovery e dos inputs devem aparecer aqui.
     Inclua também qualquer informação que não coube nas seções anteriores — nada pode ficar de fora. -->

| # | Descrição | Probabilidade | Impacto | Mitigação |
|---|-----------|---------------|---------|-----------|
| R01 | [risco] | Alta / Média / Baixa | Alto / Médio / Baixo | [ação de mitigação] |

**Pontos em aberto (bloqueadores):**
- ⚠️ [Dimensão]: [o que falta definir] — **responsável:** [nome/papel] — **prazo:** [data ou "antes de iniciar"]

**Informações adicionais dos inputs:**
<!-- Use este espaço para qualquer informação fornecida pelo usuário que não se encaixou nas seções acima.
     Não omita nada — se existe dúvida sobre onde colocar, coloque aqui com nota de contexto. -->

---

*Documento gerado para alinhamento técnico interno. Revisar com o time antes de iniciar o desenvolvimento.*
