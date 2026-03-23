# Briefing Técnico — Sistema de Templates via Google Docs

> **Versão:** 1.0  
> **Papel:** Engenheiro de Software & Product Manager Sênior  
> **Status:** Pronto para refinamento com time técnico

---

## 1. Contexto e Problema

A plataforma já possui geração de orçamentos e contratos em PDF via geração interna (`pdf-generator.ts`). Essa abordagem é funcional, porém rígida: qualquer alteração no layout ou conteúdo dos documentos exige mudanças no código-fonte, criando dependência técnica para uma tarefa que deveria ser autônoma pelo administrador do negócio.

**Dor principal:** Falta de flexibilidade para personalizar documentos sem envolver a equipe de desenvolvimento.

---

## 2. Solução Proposta

Criar um sistema de templates de documentos integrado ao **Google Docs**, permitindo que administradores do sistema personalizem orçamentos e contratos livremente usando variáveis dinâmicas (`{{chave}}`), sem nenhuma dependência de código.

A integração deve ser opcional, retrocompatível e segura — o sistema deve continuar funcionando normalmente com geração interna de PDF caso a integração não esteja ativa.

---

## 3. Premissas e Restrições

- Apenas usuários com papel `admin` podem configurar e gerenciar a integração.
- A integração com o Google é feita via **OAuth 2.0** (não API Key).
- O escopo OAuth deve ser **mínimo possível**: `https://www.googleapis.com/auth/drive.file`, garantindo acesso apenas aos arquivos explicitamente selecionados pelo admin.
- Credenciais do Google Cloud (Client ID, Client Secret) ficam exclusivamente no `.env` do servidor — nunca expostas ao frontend.
- O sistema deve manter **retrocompatibilidade total**: se a integração estiver desativada, o fluxo atual de geração de PDF permanece intacto.
- Um único workspace Google pode ser conectado por vez. Reconectar substitui a integração anterior.

---

## 4. Arquitetura de Integração

### 4.1 Fluxo OAuth 2.0

```
Admin clica "Conectar com Google"
    → Backend gera URL de autorização com estado CSRF
    → Admin é redirecionado para tela de consentimento Google
    → Google redireciona para callback da aplicação
    → Backend troca code por access_token + refresh_token
    → Tokens são persistidos de forma segura no banco
    → Admin é redirecionado de volta para /settings com status "Conectado"
```

**Dados persistidos após autenticação:**

| Campo | Descrição |
|---|---|
| `google_access_token` | Token de curta duração (uso imediato) |
| `google_refresh_token` | Token de longa duração (renovação automática) |
| `google_connected_at` | Timestamp da conexão |
| `google_connected_by_user_id` | FK para o usuário admin que conectou |
| `google_connected_by_name` | Nome do usuário (desnormalizado para exibição) |
| `google_token_expiry` | Expiração do access_token atual |

> ⚠️ O `refresh_token` deve ser armazenado **criptografado** no banco (ex: AES-256). O `access_token` pode ser armazenado em cache seguro ou também criptografado.

### 4.2 Seleção de Templates (Google Picker)

Após autenticação, o admin seleciona os templates usando o **Google Picker API** — um modal nativo do Google que exibe apenas os arquivos que o usuário autenticado tem permissão de acessar. Isso garante que nenhum arquivo da empresa seja exposto além do necessário.

**Dados persistidos para cada template:**

| Campo | Descrição |
|---|---|
| `budget_template_file_id` | `fileId` do Google Doc selecionado para Orçamentos |
| `budget_template_name` | Nome do arquivo (para exibição na UI) |
| `contract_template_file_id` | `fileId` do Google Doc selecionado para Contratos |
| `contract_template_name` | Nome do arquivo (para exibição na UI) |

### 4.3 Flags de Ativação

| Flag | Padrão | Condição para habilitar |
|---|---|---|
| `use_google_docs_for_budgets` | `false` | Integração conectada + template de orçamento selecionado |
| `use_google_docs_for_contracts` | `false` | Integração conectada + template de contrato selecionado |

> As flags são independentes. O admin pode ativar apenas para orçamentos e manter PDF interno para contratos, por exemplo.  
> Se a integração for desconectada, ambas as flags são automaticamente revertidas para `false`.

---

## 5. Configurações e UX — Tela `/settings`

### 5.1 Aba "Integrações"

Seguindo o padrão visual de ferramentas como Slack, Linear e ClickUp, cada integração disponível é exibida como um **card**, com:

- Ícone + nome do serviço
- Descrição curta do que a integração faz
- Status visual (badge): `Conectado` (verde) / `Desconectado` (cinza)
- Botão de ação contextual: `Conectar` ou `Gerenciar`

**Card da integração Google Docs — estado "Desconectado":**
```
┌─────────────────────────────────────────────────────────┐
│  [Google Docs icon]  Google Docs          ● Desconectado│
│  Gere orçamentos e contratos a partir de                │
│  templates personalizados no Google Docs.               │
│                                              [Conectar] │
└─────────────────────────────────────────────────────────┘
```

**Card da integração Google Docs — estado "Conectado":**
```
┌─────────────────────────────────────────────────────────┐
│  [Google Docs icon]  Google Docs             ● Conectado│
│  Conectado por Maria Silva em 18/02/2025                │
│                                   [Gerenciar] [Remover] │
└─────────────────────────────────────────────────────────┘
```

Ao clicar em **"Remover"**, exibir um modal de confirmação alertando que:
- As flags de geração por template serão desativadas
- Os templates selecionados serão desvinculados
- Os documentos no Google Drive **não** serão excluídos

### 5.2 Aba "Documentos" (ou seção dentro de Integrações)

Visível e funcional apenas quando a integração estiver com status `Conectado`.

Esta seção é dividida em três blocos:

---

#### Bloco A — Configuração de Templates

Para **Orçamentos** e **Contratos**, cada um com:

1. **Seletor de template:** botão "Selecionar documento" que abre o Google Picker. Após seleção, exibe o nome do arquivo e um ícone de link para abrir no Google Docs.
2. **Toggle de ativação:** habilita/desabilita o uso do template. Só pode ser ligado se um template estiver selecionado. Ao desativar, volta a gerar PDF interno.

```
Orçamentos
  Template: [📄 Template-Orcamento-2025.docx  ↗]  [Alterar]
  Geração:  [● Ativo — usando Google Docs]  ←toggle→

Contratos
  Template: Nenhum template selecionado
            [Selecionar documento do Google Docs]
  Geração:  [○ Inativo — desabilitado sem template]
```

---

#### Bloco B — Variáveis disponíveis para o template

Lista completa e documentada de todas as chaves que o admin pode usar nos templates. Exibida em tabela com busca por chave e agrupamento por categoria.

> Padrão recomendado: manter as chaves no formato `{{entidade.campo}}`, refletindo os atributos reais já existentes na aplicação.

**Catálogo inicial de chaves (alinhado ao estado atual da aplicação):**

```
🔍 Buscar variável...

━━━ Lead / Cliente (entidade leads) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {{lead.id}}                     ID do lead
  {{lead.clientType}}             pj | pf | internacional
  {{lead.responsibleName}}        Nome do responsável
  {{lead.responsibleCpf}}         CPF do responsável (quando houver)
  {{lead.cnpj}}                   CNPJ (quando houver)
  {{lead.companyName}}            Razão social / nome cliente
  {{lead.tradeName}}              Nome fantasia
  {{lead.freeDocument}}           Documento livre (internacional)
  {{lead.billingEmailsCsv}}       E-mails de cobrança concatenados
  {{lead.billingEmailPrimary}}    Primeiro e-mail de cobrança
  {{lead.salespersonId}}          ID do vendedor
  {{lead.accountManagerId}}       ID do account manager
  {{lead.originType}}             Origem do lead
  {{lead.originChannelLabel}}     Detalhe da origem (canal/campanha)
  {{lead.source}}                 Origem técnica (web/api)
  {{lead.autoInvoiceEnabled}}     true/false
  {{lead.isDelinquent}}           true/false
  {{lead.delinquencyStage}}       Estágio de inadimplência
  {{lead.delinquencyDays}}        Dias de inadimplência
  {{lead.createdAt}}              Data de criação
  {{lead.updatedAt}}              Data de atualização

━━━ Empresa / Configurações (system_settings) ━━━━━━━━━━━━━━━━━━━
  {{company.name}}                companyName
  {{company.tradeName}}           companyTradeName
  {{company.cnpj}}                companyCnpj
  {{company.email}}               companyEmail
  {{company.address}}             companyAddress
  {{company.logoUrl}}             companyLogoUrl
  {{company.primaryColor}}        primaryColor
  {{company.secondaryColor}}      secondaryColor
  {{company.defaultTheme}}        defaultTheme
  {{settings.autoInvoiceEnabled}} autoInvoiceEnabled
  {{settings.lateFeePercent}}     lateFeePercent
  {{settings.monthlyInterestPercent}} monthlyInterestPercent
  {{settings.gracePeriodDays}}    gracePeriodDays

━━━ Orçamento (budget_simulations / formal_budgets) ━━━━━━━━━━━━━
  {{budget.id}}                   ID do orçamento formal
  {{budget.simulationId}}         ID da simulação de origem
  {{budget.leadId}}               ID do lead
  {{budget.name}}                 Nome do orçamento
  {{budget.periodicity}}          mensal | anual
  {{budget.discountType}}         percentage | fixed
  {{budget.discountValue}}        Valor do desconto
  {{budget.subtotal}}             Subtotal
  {{budget.totalDiscount}}        Total de desconto
  {{budget.total}}                Total final
  {{budget.notes}}                Observações
  {{budget.status}}               draft | linked_to_contract
  {{budget.approvalStatus}}       pending_approval | approved | rejected
  {{budget.approvalComment}}      Comentário de aprovação/reprovação
  {{budget.approvedAt}}           Data de aprovação
  {{budget.createdAt}}            Data de criação
  {{budget.updatedAt}}            Data de atualização
  {{budget.annualProjection}}     Projeção anual (derivada)
  {{budget.validUntil}}           Validade sugerida (derivada)

━━━ Itens do orçamento (bloco de repetição) ━━━━━━━━━━━━━━━━━━━━━
  {{budget.items_row}}            Marcador da linha modelo
  {{item.serviceName}}            Nome do serviço
  {{item.billingModel}}           Modelo de cobrança
  {{item.billingModelLabel}}      Label amigável do modelo
  {{item.unitPrice}}              Preço unitário
  {{item.quantity}}               Quantidade
  {{item.subtotal}}               Subtotal do item

━━━ Contrato (entidade contracts) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {{contract.id}}                 ID do contrato
  {{contract.leadId}}             ID do lead
  {{contract.moduleId}}           ID do módulo
  {{contract.moduleName}}         Nome do módulo
  {{contract.packageId}}          ID do pacote
  {{contract.packageName}}        Nome do pacote
  {{contract.leadNeedVersionId}}  Versão de necessidades vinculada
  {{contract.startDate}}          Data de início
  {{contract.endDate}}            Data de término
  {{contract.billingPeriod}}      monthly | annual
  {{contract.status}}             negotiating | active | suspended | cancelled
  {{contract.lastQuoteUrl}}       URL do último orçamento
  {{contract.lastQuoteDate}}      Data do último orçamento
  {{contract.lastContractUrl}}    URL do último contrato
  {{contract.lastContractDate}}   Data do último contrato
  {{contract.createdAt}}          Data de criação
  {{contract.updatedAt}}          Data de atualização
  {{contract.totalValue}}         Soma dos serviços (derivada)

━━━ Serviços do contrato (bloco de repetição) ━━━━━━━━━━━━━━━━━━━
  {{contract.services_row}}       Marcador da linha modelo
  {{service.serviceName}}         Nome do serviço
  {{service.billingModel}}        Modelo de cobrança
  {{service.billingModelLabel}}   Label amigável do modelo
  {{service.unitPrice}}           Preço unitário
  {{service.quantity}}            Quantidade
  {{service.total}}               Total do serviço (unitPrice * quantity)
```

> Botão "Copiar" ao lado de cada chave para facilitar o uso no Google Docs.

---

#### Bloco C — Guia rápido de uso

Seção colapsável com orientações simples:

```
📖 Como usar os templates?

1. Crie ou abra um documento no Google Docs
2. Escreva o conteúdo do documento normalmente
3. Nos campos dinâmicos, use as variáveis da tabela acima
   Exemplo: "Prezado(a) {{lead.companyName}}, segue seu orçamento..."
4. Salve o documento no Google Drive
5. Clique em "Selecionar documento" acima e escolha o arquivo
6. Ative o toggle para começar a usar o template
```

---

## 6. Engine de Substituição de Variáveis

### 6.1 Fluxo de geração via template

```
Usuário solicita geração (orçamento ou contrato)
    → Sistema verifica flag de ativação
    → [flag = false] → Gera PDF interno (fluxo atual)
    → [flag = true]  → Busca fileId do template no banco
                     → Cria cópia do documento no Drive
                       (para não alterar o template original)
                     → Monta payload com todos os dados
                     → Executa replaceAllText via batchUpdate
                       para cada variável {{chave}} → valor
                     → Exporta o documento como PDF
                       (via Drive API export endpoint)
                     → Retorna o PDF para o usuário
                     → [opcional] Exclui a cópia temporária
```

### 6.2 Construção do payload de variáveis

O serviço de geração (`template-engine.service.ts`) deve receber os dados e montar um objeto flat de substituições:

```typescript
// Exemplo de payload gerado pelo serviço
const variables: Record<string, string> = {
  '{{lead.companyName}}': lead.companyName ?? "",
  '{{lead.cnpj}}': lead.cnpj ?? "",
  '{{lead.clientType}}': lead.clientType ?? "",
  '{{lead.billingEmailsCsv}}': (lead.billingEmails ?? []).join(", "),
  '{{company.name}}': settings.companyName ?? "Acesse",
  '{{company.cnpj}}': settings.companyCnpj ?? "",
  '{{settings.lateFeePercent}}': `${settings.lateFeePercent ?? ""}%`,
  '{{budget.id}}': budget.id,
  '{{budget.total}}': formatCurrency(budget.total),
  '{{budget.createdAt}}': formatDate(budget.createdAt),
  // ... demais chaves
};
```

### 6.3 Tratamento de valores ausentes

- Se uma variável não tiver valor disponível, substituir por string vazia `""` ou por um placeholder configurável (ex: `—`).
- Logar quais variáveis ficaram vazias para auditoria.
- Nunca deixar a tag literal `{{chave}}` no documento final.

### 6.4 Itens de tabela (`{{budget.items}}`)

Itens de tabela são um caso especial — não são substituição simples de texto. A abordagem recomendada:

- O template deve conter uma **linha de modelo** na tabela marcada com uma variável especial, ex: `{{budget.items_row}}`.
- O serviço identifica essa linha, duplica-a para cada item do orçamento e preenche colunas como `{{item.serviceName}}`, `{{item.quantity}}`, `{{item.unitPrice}}`, `{{item.subtotal}}`.
- A linha modelo original é removida após a geração.

> Isso deve ser documentado claramente no Guia rápido exibido na tela de configurações.

---

## 7. Refatoração do Fluxo de Geração de PDF

O arquivo `pdf-generator.ts` não deve ser removido — ele permanece como a implementação padrão (fallback). A refatoração consiste em:

1. Criar `document-generator.service.ts` como **fachada** única para geração de documentos.
2. Esse serviço verifica a flag + status da integração e decide internamente qual estratégia usar:
   - `GoogleDocsStrategy` — quando integração ativa e template configurado
   - `InternalPdfStrategy` — quando flag desativada ou integração indisponível
3. Todos os pontos da aplicação que hoje chamam `pdf-generator.ts` diretamente passam a chamar `document-generator.service.ts`.

Isso aplica o **padrão Strategy**, mantendo o código limpo e extensível para futuras integrações (ex: Word, Notion, etc.).

---

## 8. Tratamento de Erros e Resiliência

| Cenário | Comportamento esperado |
|---|---|
| Token expirado | Renovar automaticamente via refresh_token antes da requisição |
| Refresh token inválido/revogado | Marcar integração como `Desconectada`, notificar admin via banner na dashboard |
| Template não encontrado no Drive | Exibir erro claro ao usuário, sugerir reconfigurar o template |
| Falha na API do Google (timeout, 5xx) | Registrar erro, retornar mensagem amigável ao usuário, **não** tentar fallback automático para PDF interno (isso pode gerar inconsistência) |
| Limite de quota da API Google | Monitorar e alertar admin antes de atingir o limite |

---

## 9. Segurança

- Toda rota de configuração da integração deve verificar papel `admin` no middleware.
- O estado CSRF (parâmetro `state`) deve ser validado no callback OAuth.
- O `refresh_token` deve ser criptografado em repouso no banco.
- O `access_token` nunca deve ser exposto em respostas de API ou logs.
- Os tokens não devem ser logados em nenhuma circunstância.
- Ao desconectar, revogar o token no Google (`https://oauth2.googleapis.com/revoke`) além de limpar os dados no banco.

---

## 10. Variáveis de Ambiente Necessárias

```env
# Google OAuth
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_REDIRECT_URI=https://yourdomain.com/api/integrations/google/callback

# Picker API (frontend — pode ser pública)
VITE_GOOGLE_CLIENT_ID=your_client_id
VITE_GOOGLE_PICKER_API_KEY=your_picker_api_key
VITE_GOOGLE_APP_ID=your_app_id

# Criptografia dos tokens
INTERNAL_VAULT_KEY=replace-with-base64-32-byte-key
```

---

## 11. Escopo de Entrega (sugestão de fases)

### Fase 1 — Integração e configuração
- [ ] Fluxo OAuth 2.0 completo (connect, callback, disconnect)
- [ ] Persistência segura dos tokens
- [ ] Card de integração na tela `/settings`
- [ ] Status visual (Conectado/Desconectado), exibição de nome e data

### Fase 2 — Seleção de templates e flags
- [ ] Integração com Google Picker API
- [ ] Persistência dos fileIds selecionados
- [ ] Toggles de ativação por tipo de documento
- [ ] Tabela de variáveis disponíveis com busca e botão copiar

### Fase 3 — Engine de geração
- [ ] Serviço `document-generator.service.ts` com padrão Strategy
- [ ] Substituição de variáveis simples via `batchUpdate`
- [ ] Tratamento especial para itens de tabela
- [ ] Exportação do documento como PDF via Drive API

### Fase 4 — Integração no produto e polimento
- [ ] Substituição de todas as chamadas diretas ao `pdf-generator.ts`
- [ ] Tratamento de erros e resiliência
- [ ] Revogação de token ao desconectar
- [ ] Testes e validação com templates reais

---

## 12. Fora do Escopo (por ora)

- Edição de templates diretamente na aplicação (o Google Docs é o editor)
- Assinatura digital dos documentos gerados
- Múltiplas contas Google conectadas simultaneamente
- Histórico de versões dos documentos gerados
- Preview do template renderizado dentro da aplicação

---

## 13. Validação Operacional (WP-40)

### 13.1 Evidências automatizadas executadas

Para hardening final, as seguintes suítes cobrem fluxo feliz e falhas críticas:

- `api/routes/integrations-google.test.ts`
  - connect OAuth (redirect/json)
  - callback (sucesso, `state` inválido, `access_denied`, falha de troca de token)
  - templates/flags
  - disconnect (sucesso e falha de revoke)
  - cenário E2E encadeado: connect -> callback -> template -> flag -> disconnect
- `api/services/document-generator.test.ts`
  - classificação de erro (`auth_revoked`, `template_not_found`, `quota_exceeded`, `google_unavailable`, `google_unknown`)
  - garantia explícita de não fallback silencioso para fluxo Google
- `api/routes/auth-admin.test.ts`
  - mascaramento e não vazamento de segredos em resposta/auditoria
- `web/src/lib/google-templates.test.ts`
- `web/src/lib/google-template-variables.test.ts`

### 13.2 Checklist manual para homologação com templates reais

1. Conectar integração Google em `/settings` com usuário admin.
2. Selecionar template real para orçamento e contrato via Google Picker.
3. Ativar toggles por tipo documental e confirmar persistência após recarregar página.
4. Gerar documento de orçamento e contrato, validar:
   - placeholders simples substituídos;
   - blocos tabulares (`items_row`/`services_row`) renderizados;
   - ausência de tags `{{...}}` remanescentes.
5. Desconectar integração e confirmar:
   - flags desativadas automaticamente;
   - templates desvinculados;
   - documentos do Drive preservados.

### 13.3 Troubleshooting rápido

- **`invalid_state` no callback OAuth**
  - Recomeçar o fluxo por `/api/integrations/google/connect` (state expirado/consumido).
- **`token_exchange_failed` no callback**
  - Validar `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` e `GOOGLE_REDIRECT_URI`.
- **`missing_refresh_token`**
  - Reconectar com consentimento completo (Google pode não reenviar refresh token sem novo consent).
- **`template_not_found` na geração**
  - Verificar se o template ainda existe e se a conta conectada mantém permissão no arquivo.
- **`quota_exceeded` / `google_unavailable`**
  - Aguardar janela de cota/estabilidade e tentar novamente; acompanhar alerta administrativo em `/settings`.
- **Desconexão automática (`auth_revoked`)**
  - Reconectar integração e selecionar novamente templates antes de reativar as flags.

---

*Documento gerado para alinhamento técnico interno. Revisar com o time antes de iniciar o desenvolvimento.*