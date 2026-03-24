# Briefing UX/UI — [Nome da Feature]

> **Versão:** 0.1
> **Audiência:** Time de UX/UI — designers e frontend
> **Status:** Rascunho | Em revisão | Aprovado pelo time UX
> **Gerado em:** [YYYY-MM-DD]
> **Baseado em:** [`../discovery.md`](../discovery.md) — discovery de [YYYY-MM-DD]

---

## 1. Contexto e Objetivo para o Usuário

<!-- Por que esta feature existe na perspectiva do usuário.
     Qual dor ela resolve. O que muda na vida de quem usa.
     Máximo 3 parágrafos. Sem jargão técnico — escreva como se fosse
     explicar para o usuário final o que está sendo construído para ele. -->

---

## 2. Personas e Papéis

<!-- Quem usa esta feature. O que cada persona consegue fazer.
     O que cada persona NÃO consegue fazer (restrições de acesso visíveis na UI).
     Foco no que o usuário VÊ e FAZ — não em permissões de banco ou RBAC. -->

| Persona | Papel no sistema | O que vê/faz nesta feature | O que não vê/não pode fazer |
|---------|-----------------|---------------------------|------------------------------|
| [ex: Administrador] | Configura e gerencia | [lista de ações visíveis] | [restrições visíveis na UI] |
| [ex: Operador] | Usa no dia a dia | [lista de ações visíveis] | [restrições visíveis na UI] |

---

## 3. Mapa de Telas e Navegação

<!-- Visão macro de todas as telas (novas ou modificadas) e como o usuário
     navega entre elas. Não é wireframe detalhado — é o mapa de fluxo.
     Use o formato de árvore abaixo. -->

```
[Tela A — Nome]
    ├── [ação/botão] → [Tela B — Nome]
    │       ├── [ação de sucesso] → [Tela C — Nome]
    │       └── [cancelar] → [Tela A]
    ├── [ação/botão] → [Tela D — Nome]
    │       └── [confirmar exclusão] → modal de confirmação → [Tela A]
    └── [filtros/busca] → [Tela A] com resultados filtrados
```

---

## 4. Especificação de Cada Tela

<!-- Uma subseção por tela. Para telas existentes modificadas, descrever
     apenas o que muda — referenciar o comportamento atual para o restante. -->

### 4.1 [Nome da Tela]

**URL/Rota:** `/caminho`
**Quem acessa:** [personas]
**Quando aparece:** [contexto de navegação — de onde o usuário vem]

**Conteúdo e elementos visíveis:**
- [O que está na tela — componentes, dados exibidos, ações disponíveis]
- [Quais informações são mostradas e em que formato]

**Estados da tela:**
```
[Estado vazio]      → [mensagem, CTA, ilustração? — o que o usuário vê]
[Estado carregando] → [skeleton, spinner, nada?]
[Estado com dados]  → [como os dados são apresentados — lista, tabela, cards?]
[Estado de erro]    → [mensagem de erro exibida, como o usuário pode recuperar]
```

**Wireframe:**
```
┌─────────────────────────────────────────────────────┐
│  [Título da tela]                        [Ação]     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  [Área de conteúdo principal]                       │
│                                                     │
│  [Componente 1]          [Componente 2]             │
│                                                     │
├─────────────────────────────────────────────────────┤
│  [Ação primária]          [Ação secundária]         │
└─────────────────────────────────────────────────────┘
```

<!-- Repetir seção 4.X para cada tela adicional -->

---

## 5. Fluxos Principais

<!-- Jornada do usuário nos fluxos mais importantes — o que ele vê e faz,
     não o que o sistema faz internamente. Cobrir o fluxo feliz e os
     principais fluxos alternativos (erro, cancelamento, borda). -->

### Fluxo 1 — [Nome do fluxo principal / caminho feliz]

1. Usuário está em [tela X] e [contexto]
2. Usuário clica em [ação Y]
3. Sistema exibe [tela/modal/toast Z] — o usuário vê [descrição]
4. Usuário preenche [campo(s)] e clica em [ação]
5. [resultado — o que o usuário vê ao final]

### Fluxo 2 — [Nome do fluxo alternativo ou de erro principal]

1. [...]

---

## 6. Comportamentos e Feedbacks de UX

<!-- Microcopy e feedbacks visuais — tudo que o sistema comunica ao usuário.
     Ser prescritivo: definir aqui evita que o designer invente textos
     ou que haja idas e vindas de revisão de copywriting. -->

| Evento | Feedback ao usuário | Tipo |
|--------|---------------------|------|
| [ex: salvar com sucesso] | "[texto exato da mensagem]" | toast verde · 3s |
| [ex: campo obrigatório vazio] | "[texto exato da mensagem]" | erro inline abaixo do campo |
| [ex: ação destrutiva — excluir] | "[texto exato da pergunta de confirmação]" | modal com 2 botões |
| [ex: carregando dados] | — | skeleton loader |
| [ex: erro de rede] | "[texto exato da mensagem]" | banner de erro + botão "Tentar novamente" |

---

## 7. Regras de Exibição e Condicionalidade

<!-- Quando um elemento aparece, desaparece ou muda de estado.
     Estas regras são visuais — guiam o frontend, não o backend.
     Usar linguagem SE/ENTÃO. -->

- SE [persona = X] ENTÃO [elemento Y é exibido / oculto / desabilitado]
- SE [estado = Z] ENTÃO [botão W fica desabilitado com tooltip "[texto]"]
- SE [campo A está vazio] ENTÃO [botão de submit fica desabilitado]
- SE [lista está vazia] ENTÃO [exibir estado vazio com mensagem "[texto]" e CTA "[texto]"]
- [Campo B] é obrigatório — não permite submissão se vazio
- [Seção C] só é visível quando [condição]

---

## 8. Conteúdo e Textos

<!-- Copywriting prescritivo: os textos que vão para o produto.
     Definir aqui reduz revisões e garante consistência de voz. -->

| Elemento | Texto |
|----------|-------|
| Título da tela/página principal | "[texto exato]" |
| Subtítulo ou descrição da tela | "[texto exato]" |
| Botão de ação primária | "[texto exato]" |
| Botão de ação secundária | "[texto exato]" |
| Mensagem de estado vazio | "[texto exato]" |
| CTA no estado vazio | "[texto exato]" |
| Placeholder do campo de busca | "[texto exato]" |
| Label do campo [X] | "[texto exato]" |
| Tooltip do campo [X] | "[texto exato]" |
| Título do modal de confirmação | "[texto exato]" |
| Texto do modal de confirmação | "[texto exato]" |

---

## 9. Referências Visuais e Padrões de Interface

<!-- Produtos e telas que serviram de referência para decisões de UX.
     Componentes do design system a usar (se specs/design-system.md existir).
     Padrões de interação esperados. -->

- **Padrão geral:** seguir o modelo de [produto referência] para [aspecto — ex: tabelas com ações inline]
- **Componente de listagem:** usar [componente do design system] — padrão já estabelecido em [tela existente]
- **Modal de confirmação:** padrão destrutivo — botão de confirmação em vermelho, cancelar à esquerda
- **[Interação X]:** [como deve funcionar — animação, transição, feedback háptico se mobile]

---

## 10. Fora do Escopo desta Versão (UX)

<!-- O que o usuário NÃO verá nesta versão. Itens explicitamente excluídos
     do escopo de design. Protege contra scope creep e alinha expectativas. -->

- [Feature X] — previsto para versão futura
- [Tela Y] — fora do escopo por [motivo — ex: depende de backend não planejado]
- [Funcionalidade Z] — descartada nesta versão por [motivo]

---

## 11. Pontos em Aberto (UX)

<!-- Decisões de UX ainda não tomadas. Rastreável com responsável.
     Resolver antes de iniciar prototipação. -->

| # | Questão | Impacto | Responsável |
|---|---------|---------|-------------|
| U01 | [ex: Qual é a ação padrão ao clicar no card — abrir detalhe ou editar inline?] | [tela X — muda o fluxo 1] | [designer / PM] |
| U02 | [ex: Em mobile, o menu lateral vira bottom sheet ou drawer?] | [navegação global] | [designer] |

---

*Documento para alinhamento com o time de UX/UI. Revisar e aprovar antes de iniciar prototipação.*
