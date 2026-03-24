# Briefing UX/UI — Sistema de Templates via Google Docs

> **Versão:** 0.1
> **Audiência:** Time de UX/UI — designers e frontend
> **Status:** Referência canônica de qualidade — não modificar
> **Gerado em:** 2026-03-23
> **Baseado em:** briefing técnico `./briefing.v0.md` — Sistema de Templates via Google Docs

---

## 1. Contexto e Objetivo para o Usuário

Hoje, quando um administrador precisa mudar o layout ou o texto de um orçamento ou contrato gerado pela plataforma, precisa acionar o time de desenvolvimento — uma tarefa simples vira uma solicitação técnica com dias de espera.

Esta feature permite que o próprio administrador crie e edite os templates de orçamentos e contratos diretamente no Google Docs, usando variáveis dinâmicas (ex: `{{lead.companyName}}`) para preencher os dados automaticamente. A plataforma conecta com o Google Drive do admin, usa o documento escolhido como molde e gera o PDF final — tudo sem código.

O resultado para o usuário: autonomia total para personalizar documentos da empresa, sem depender do time técnico, sem perder a integração com os dados da plataforma.

---

## 2. Personas e Papéis

| Persona | Papel no sistema | O que vê/faz nesta feature | O que não vê/não pode fazer |
|---------|-----------------|---------------------------|------------------------------|
| Administrador | Configura integrações e documentos | Conecta a conta Google, seleciona os templates, ativa/desativa o uso por tipo de documento, acessa o catálogo de variáveis | Não edita o template dentro da plataforma (edição é no Google Docs) |
| Usuário operacional | Gera orçamentos e contratos | Nenhuma mudança visível — o processo de gerar documentos continua igual; só o resultado (PDF) pode ser diferente | Não vê nem acessa as configurações de integração |

---

## 3. Mapa de Telas e Navegação

```
[/settings — Aba "Integrações"]
    ├── card Google Docs (estado Desconectado)
    │       └── [Conectar] → redirecionamento externo (tela de consentimento Google)
    │               └── [Google autoriza] → [/settings — Aba "Integrações"] (estado Conectado)
    │
    ├── card Google Docs (estado Conectado)
    │       ├── [Gerenciar] → [/settings — Aba "Documentos"]
    │       └── [Remover] → modal de confirmação de desconexão
    │               ├── [Cancelar] → [/settings — Aba "Integrações"] (sem mudança)
    │               └── [Confirmar desconexão] → [/settings — Aba "Integrações"] (estado Desconectado)
    │
[/settings — Aba "Documentos"]  ← acessível apenas com integração Conectada
    ├── Bloco "Orçamentos" — selecionar template
    │       └── [Selecionar documento do Google Docs] → modal Google Picker (externo)
    │               └── [usuário seleciona arquivo] → bloco atualizado com nome do arquivo
    │
    ├── Bloco "Contratos" — selecionar template
    │       └── [Selecionar documento do Google Docs] → modal Google Picker (externo)
    │               └── [usuário seleciona arquivo] → bloco atualizado com nome do arquivo
    │
    └── Toggle de ativação (por tipo)
            ├── [ligar — quando template selecionado] → status muda para "Ativo"
            └── [desligar] → status muda para "Inativo"
```

---

## 4. Especificação de Cada Tela

### 4.1 /settings — Aba "Integrações"

**URL/Rota:** `/settings` → aba "Integrações"
**Quem acessa:** Administrador
**Quando aparece:** Admin navega para configurações e clica na aba "Integrações"

**Conteúdo e elementos visíveis:**
- Lista de cards de integrações disponíveis (uma por serviço)
- Card da integração Google Docs com: ícone, nome, descrição curta, badge de status e botão de ação

**Estados do card Google Docs:**

```
[Estado Desconectado]  → card com badge cinza "Desconectado" e botão "Conectar"
[Estado Conectado]     → card com badge verde "Conectado", nome e data de quem conectou,
                         botões "Gerenciar" e "Remover"
[Estado carregando]    → skeleton do card durante carregamento inicial da página
```

**Wireframe — card Desconectado:**
```
┌─────────────────────────────────────────────────────────┐
│  [ícone Google Docs]  Google Docs      ● Desconectado   │
│  Gere orçamentos e contratos a partir de templates      │
│  personalizados no Google Docs.                         │
│                                              [Conectar] │
└─────────────────────────────────────────────────────────┘
```

**Wireframe — card Conectado:**
```
┌─────────────────────────────────────────────────────────┐
│  [ícone Google Docs]  Google Docs         ● Conectado   │
│  Conectado por Maria Silva em 18/02/2025                │
│                                  [Gerenciar]  [Remover] │
└─────────────────────────────────────────────────────────┘
```

---

### 4.2 Modal de confirmação de desconexão

**URL/Rota:** overlay sobre `/settings`
**Quem acessa:** Administrador
**Quando aparece:** Admin clica em "Remover" no card Google Docs conectado

**Conteúdo e elementos:**
- Título do modal
- Texto explicando as consequências (o que vai acontecer)
- Lista de impactos visíveis ao usuário
- Dois botões: cancelar e confirmar

**Estados:**
```
[Estado padrão]      → modal com informações e dois botões habilitados
[Estado carregando]  → botão "Confirmar desconexão" mostra spinner, ambos desabilitados
[Estado erro]        → mensagem de erro inline abaixo dos botões, botões reabilitados
```

**Wireframe:**
```
┌──────────────────────────────────────────────────────┐
│  Remover integração com Google Docs?                 │
│                                                      │
│  Esta ação irá:                                      │
│  • Desativar a geração de documentos via template    │
│  • Desvincular os templates de orçamento e contrato  │
│  • Desconectar a conta Google da plataforma          │
│                                                      │
│  Os documentos no Google Drive não serão excluídos.  │
│                                                      │
│         [Cancelar]    [Confirmar desconexão]         │
└──────────────────────────────────────────────────────┘
```

---

### 4.3 /settings — Aba "Documentos"

**URL/Rota:** `/settings` → aba "Documentos"
**Quem acessa:** Administrador (somente com integração Conectada)
**Quando aparece:** Admin clica em "Gerenciar" no card Google Docs conectado, ou navega diretamente para a aba quando conectado

**Conteúdo e elementos visíveis:**
- Bloco "Orçamentos": template selecionado (ou vazio), toggle de ativação
- Bloco "Contratos": template selecionado (ou vazio), toggle de ativação
- Catálogo de variáveis com busca e grupos por categoria
- Guia rápido de uso (seção colapsável)

**Estados do bloco de template:**
```
[Sem template]      → botão "Selecionar documento do Google Docs", toggle desabilitado
[Com template]      → nome do arquivo com ícone de link para abrir no Google Docs,
                      botão "Alterar", toggle habilitado
[Carregando picker] → estado de loading enquanto o Google Picker abre
```

**Estados do toggle:**
```
[Inativo — sem template]  → toggle desabilitado com tooltip "Selecione um template primeiro"
[Inativo — com template]  → toggle desabilitado (off), clicável para ativar
[Ativo]                   → toggle ligado (on), label "Ativo — usando Google Docs"
```

**Wireframe — bloco Orçamentos (com template ativo):**
```
┌──────────────────────────────────────────────────────────┐
│  Orçamentos                                              │
│                                                          │
│  Template:  📄 Template-Orcamento-2025.docx  [↗ Abrir]  │
│             [Alterar documento]                          │
│                                                          │
│  Geração:   ●━━━━━━━━  Ativo — usando Google Docs       │
└──────────────────────────────────────────────────────────┘
```

**Wireframe — bloco Contratos (sem template):**
```
┌──────────────────────────────────────────────────────────┐
│  Contratos                                               │
│                                                          │
│  Template:  Nenhum template selecionado                  │
│             [Selecionar documento do Google Docs]        │
│                                                          │
│  Geração:   ○━━━━━━━━  Inativo — selecione um template  │
└──────────────────────────────────────────────────────────┘
```

**Wireframe — catálogo de variáveis:**
```
┌──────────────────────────────────────────────────────────┐
│  Variáveis disponíveis para os templates                 │
│                                                          │
│  🔍  Buscar variável...                                  │
│                                                          │
│  ━━━ Lead / Cliente ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  {{lead.companyName}}    Razão social / nome cliente [⎘] │
│  {{lead.cnpj}}           CNPJ                        [⎘] │
│  {{lead.responsibleName}} Nome do responsável        [⎘] │
│  ... (mais itens colapsados)                             │
│                                                          │
│  ━━━ Empresa / Configurações ━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  {{company.name}}        Nome da empresa             [⎘] │
│  ... (mais itens colapsados)                             │
│                                                          │
│  📖 Como usar os templates?                    [Expandir]│
└──────────────────────────────────────────────────────────┘
```

---

## 5. Fluxos Principais

### Fluxo 1 — Conectar a conta Google e configurar o primeiro template

1. Admin acessa `/settings` → aba "Integrações"
2. Admin vê o card Google Docs com badge "Desconectado" e clica em "Conectar"
3. Admin é redirecionado para a tela de consentimento do Google (fora da plataforma)
4. Admin autoriza o acesso e é redirecionado de volta para `/settings` → aba "Integrações"
5. Card Google Docs agora exibe badge verde "Conectado", nome do admin e data de conexão
6. Admin clica em "Gerenciar" → vai para aba "Documentos"
7. Admin vê dois blocos (Orçamentos e Contratos) sem templates configurados
8. Admin clica em "Selecionar documento do Google Docs" no bloco Orçamentos
9. Modal do Google Picker abre (nativo do Google) — admin navega e seleciona o arquivo
10. Bloco Orçamentos é atualizado: exibe nome do arquivo e toggle habilitado
11. Admin liga o toggle — status muda para "Ativo — usando Google Docs"
12. Toast verde confirma: "Template de orçamento ativado com sucesso."

### Fluxo 2 — Desconectar a integração Google

1. Admin acessa `/settings` → aba "Integrações"
2. Admin vê o card Google Docs "Conectado" e clica em "Remover"
3. Modal de confirmação aparece com a lista de impactos
4. Admin clica em "Confirmar desconexão"
5. Modal fecha, card volta ao estado "Desconectado"
6. Toast verde: "Integração com Google Docs removida."

### Fluxo 3 — Alterar template existente

1. Admin acessa `/settings` → aba "Documentos"
2. Bloco Orçamentos exibe template já selecionado
3. Admin clica em "Alterar documento"
4. Modal do Google Picker abre — admin seleciona novo arquivo
5. Bloco atualiza com novo nome de arquivo
6. Toggle permanece no estado anterior (ativo ou inativo)
7. Toast verde: "Template de orçamento atualizado."

### Fluxo 4 — Usar o catálogo de variáveis ao criar template

1. Admin está no Google Docs criando ou editando o template
2. Admin retorna para `/settings` → aba "Documentos"
3. Admin localiza a variável desejada no catálogo (usando busca ou navegando pelos grupos)
4. Admin clica em [⎘] ao lado da variável para copiar
5. Toast discreto: "Variável copiada para a área de transferência."
6. Admin volta ao Google Docs e cola a variável no local desejado

---

## 6. Comportamentos e Feedbacks de UX

| Evento | Feedback ao usuário | Tipo |
|--------|---------------------|------|
| Integração conectada com sucesso | "Google Docs conectado com sucesso." | toast verde · 4s |
| Integração desconectada | "Integração com Google Docs removida." | toast verde · 4s |
| Erro ao conectar (falha no OAuth) | "Não foi possível conectar com o Google. Tente novamente." | toast vermelho · persistente com botão "Fechar" |
| Template de orçamento ativado | "Template de orçamento ativado com sucesso." | toast verde · 3s |
| Template de contrato ativado | "Template de contrato ativado com sucesso." | toast verde · 3s |
| Template atualizado | "Template de orçamento atualizado." | toast verde · 3s |
| Erro ao salvar template | "Erro ao salvar o template. Tente novamente." | toast vermelho · persistente |
| Toggle ativado sem template selecionado | "Selecione um template antes de ativar." | tooltip sobre o toggle desabilitado |
| Variável copiada para clipboard | "Copiado!" | toast discreto/neutro · 1.5s |
| Ação de desconexão em andamento | Botão "Confirmar desconexão" mostra spinner, ambos botões desabilitados | loading inline no botão |
| Integração desconectada automaticamente (erro de autenticação) | Banner amarelo no topo da página: "A integração com o Google foi desconectada. Reconecte em Configurações → Integrações." | banner persistente até ser fechado manualmente |

---

## 7. Regras de Exibição e Condicionalidade

- SE [integração Google Docs = Desconectada] ENTÃO [aba "Documentos" exibe mensagem "Conecte sua conta Google para configurar os templates" com CTA "Conectar agora"]
- SE [integração Google Docs = Conectada] ENTÃO [aba "Documentos" exibe os blocos de configuração de templates completos]
- SE [bloco Orçamentos não tem template selecionado] ENTÃO [toggle de Orçamentos fica desabilitado com tooltip "Selecione um template primeiro"]
- SE [bloco Contratos não tem template selecionado] ENTÃO [toggle de Contratos fica desabilitado com tooltip "Selecione um template primeiro"]
- SE [integração for desconectada] ENTÃO [ambos os toggles são automaticamente desligados e os templates desvinculados — sem ação adicional do admin]
- SE [integração for desconectada por erro externo] ENTÃO [banner de alerta aparece nas páginas da aplicação até ser fechado]
- O botão "Gerenciar" só aparece quando a integração está Conectada
- O botão "Remover" só aparece quando a integração está Conectada
- O catálogo de variáveis exibe todas as variáveis disponíveis — independente de template estar selecionado ou não

---

## 8. Conteúdo e Textos

| Elemento | Texto |
|----------|-------|
| Título da aba | "Integrações" |
| Nome da integração | "Google Docs" |
| Descrição do card | "Gere orçamentos e contratos a partir de templates personalizados no Google Docs." |
| Badge desconectado | "Desconectado" |
| Badge conectado | "Conectado" |
| Info de conexão (card conectado) | "Conectado por [nome] em [data]" |
| Botão de conexão | "Conectar" |
| Botão de gerenciamento | "Gerenciar" |
| Botão de remoção | "Remover" |
| Título do modal de desconexão | "Remover integração com Google Docs?" |
| Texto do modal — linha 1 | "Esta ação irá:" |
| Item 1 da lista de impactos | "Desativar a geração de documentos via template" |
| Item 2 da lista de impactos | "Desvincular os templates de orçamento e contrato" |
| Item 3 da lista de impactos | "Desconectar a conta Google da plataforma" |
| Nota de segurança do modal | "Os documentos no Google Drive não serão excluídos." |
| Botão cancelar do modal | "Cancelar" |
| Botão confirmar do modal | "Confirmar desconexão" |
| Título do bloco de orçamentos | "Orçamentos" |
| Título do bloco de contratos | "Contratos" |
| Label sem template | "Nenhum template selecionado" |
| Botão selecionar template | "Selecionar documento do Google Docs" |
| Botão alterar template | "Alterar documento" |
| Label toggle ativo | "Ativo — usando Google Docs" |
| Label toggle inativo com template | "Inativo" |
| Label toggle inativo sem template | "Inativo — selecione um template" |
| Título do catálogo | "Variáveis disponíveis para os templates" |
| Placeholder da busca | "Buscar variável..." |
| Título do guia rápido | "Como usar os templates?" |
| Mensagem aba Documentos sem conexão | "Conecte sua conta Google para configurar os templates." |
| CTA aba Documentos sem conexão | "Conectar agora" |
| Banner de desconexão automática | "A integração com o Google foi desconectada. Reconecte em Configurações → Integrações." |

---

## 9. Referências Visuais e Padrões de Interface

- **Cards de integração:** padrão de ferramentas como Slack, Linear e ClickUp — cada integração como um card horizontal com ícone, nome, descrição, badge de status e botão de ação. Badge colorido (verde = ativo, cinza = inativo).
- **Toggle de ativação:** padrão iOS/Material com estado visual claro. Quando desabilitado, exibir em tom acinzentado com cursor `not-allowed`.
- **Catálogo de variáveis:** interface de tabela com busca inline e agrupamento por categorias usando separadores visuais. Botão de copiar (ícone de clipboard) ao final de cada linha — feedback imediato ("Copiado!").
- **Modal de confirmação destrutiva:** botão de confirmação em cor de perigo (vermelho), botão cancelar como secundário/neutro à esquerda, texto descritivo com lista de impactos.
- **Google Picker:** modal nativo do Google — não há customização visual possível. Exibir um estado de loading na tela da plataforma enquanto o Picker não abre.
- **Toasts:** posicionados no canto inferior direito, com ícone de status (check para sucesso, X para erro). Toasts de erro persistentes (não fecham automaticamente) — sempre com botão "Fechar".

---

## 10. Fora do Escopo desta Versão (UX)

- Edição do template diretamente dentro da plataforma — o Google Docs é o editor, não há editor embutido
- Preview do template renderizado com dados reais antes da geração
- Histórico de documentos gerados por template
- Múltiplas contas Google conectadas simultaneamente
- Configuração de templates por tipo de cliente (PJ/PF)
- Assinatura digital dos documentos gerados

---

## 11. Pontos em Aberto (UX)

| # | Questão | Impacto | Responsável |
|---|---------|---------|-------------|
| U01 | O catálogo de variáveis exibe todas as variáveis de uma vez ou usa paginação/colapso por grupo por padrão? Dado o volume (40+ variáveis), grupos colapsados podem melhorar a escaneabilidade. | Aba "Documentos" — seção de variáveis | Designer |
| U02 | O guia rápido deve ser colapsável (accordion) ou sempre visível? Usuários recorrentes podem achar o conteúdo redundante. | Aba "Documentos" | Designer / PM |
| U03 | Quando o admin clica em "Conectar" e é redirecionado para o Google, há uma tela intermediária de loading na plataforma ou o redirecionamento é imediato? | Fluxo de conexão — percepção de carregamento | Frontend / Designer |

---

*Documento de referência canônica para a skill `/lf-briefing-ux`. Serve como exemplo de qualidade — não modificar.*
