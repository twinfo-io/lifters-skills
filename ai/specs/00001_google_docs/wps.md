### Wp-31 — Modelo de dados e segredos da integracao Google


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-31                                    |
| **Spec relacionada**     | [SPEC-01](./spec-google-docs.md#spec-01) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Nenhuma                                  |
| **Pode paralelizar com** | —                                        |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Criar a base persistente para conexao Google, templates e flags, com armazenamento seguro de token e campos de auditoria de conexao.

**Passos sugeridos de implementacao**

> 1. Definir/atualizar schema de configuracao para `google_access_token`, `google_refresh_token` (criptografado), `google_token_expiry`, `google_connected_at`, `google_connected_by_user_id`, `google_connected_by_name`.
> 2. Adicionar campos de template e flags: `budget_template_file_id`, `budget_template_name`, `contract_template_file_id`, `contract_template_name`, `use_google_docs_for_budgets`, `use_google_docs_for_contracts`.
> 3. Implementar camada de criptografia para persistencia do refresh token usando `INTERNAL_VAULT_KEY` (equivalente ao `TOKEN_ENCRYPTION_KEY` definido na especificacao funcional).
> 4. Criar testes de persistencia/masking para garantir que segredos nao vazem em respostas.

**Critérios de aceite do pacote**

> - Campos de integracao, templates e flags persistem corretamente.
> - `refresh_token` fica criptografado em repouso.
> - Leitura de configuracoes nao retorna segredo em texto claro.

**Áreas impactadas**

> [banco] migrations/config tables | [backend] settings/integrations repository | [config/env] `INTERNAL_VAULT_KEY` (`TOKEN_ENCRYPTION_KEY` na nomenclatura da spec)

---

### Wp-32 — OAuth Google (connect, callback, disconnect)


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-32                                    |
| **Spec relacionada**     | [SPEC-01](./spec-google-docs.md#spec-01) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Wp-31                                    |
| **Pode paralelizar com** | —                                        |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Entregar o fluxo OAuth completo com validacao de `state`, troca de tokens, metadados de conexao, reconexao substitutiva e desconexao com revogacao.

**Passos sugeridos de implementacao**

> 1. Criar rotas de integracao Google (`connect`, `callback`, `disconnect`) protegidas por RBAC admin.
> 2. Implementar geracao/validacao de `state` CSRF no callback.
> 3. Integrar troca `code -> access_token/refresh_token` e persistencia segura.
> 4. Implementar desconexao com revoke no endpoint Google e limpeza local de dados.
> 5. Adicionar testes de sucesso, `state` invalido e acesso nao-admin.

**Critérios de aceite do pacote**

> - Admin conecta e retorna para `/settings` com status conectado.
> - Callback com `state` invalido e rejeitado com erro controlado.
> - Desconectar revoga token remoto e limpa dados locais.

**Áreas impactadas**

> [backend] `/api/integrations/google/`*, auth middleware | [integrações] OAuth Google + revoke endpoint

---

### Wp-33 — Card de integracao Google na `/settings`


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-33                                    |
| **Spec relacionada**     | [SPEC-02](./spec-google-docs.md#spec-02) |
| **Estimativa**           | 1d                                       |
| **Dependencias**         | Wp-32                                    |
| **Pode paralelizar com** | Wp-34                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Exibir e operar o card de integracao Google com estados conectado/desconectado, acoes contextuais e modal de remocao com impactos.

**Passos sugeridos de implementacao**

> 1. Criar/atualizar componente do card em `/settings` com badge de status e acoes (`Conectar`, `Gerenciar`, `Remover`).
> 2. Exibir metadados "conectado por X em data Y".
> 3. Implementar modal de confirmacao de remocao com os 3 avisos do briefing.
> 4. Integrar acoes com endpoints de Wp-32.

**Critérios de aceite do pacote**

> - Card alterna visualmente entre conectado/desconectado.
> - Modal de remocao mostra impactos corretos.
> - Acao de remover atualiza estado na interface apos sucesso.

**Áreas impactadas**

> [frontend] `/settings` (aba Integracoes), componentes de card/modal

---

### Wp-34 — Selecao de templates com Google Picker e persistencia


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-34                                    |
| **Spec relacionada**     | [SPEC-02](./spec-google-docs.md#spec-02) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Wp-32                                    |
| **Pode paralelizar com** | Wp-33                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Permitir selecao de template para Orcamentos e Contratos via Picker e persistir `fileId`/nome com visualizacao e alteracao.

**Passos sugeridos de implementacao**

> 1. Integrar Google Picker no frontend (botao "Selecionar documento").
> 2. Salvar `fileId` e nome do template por tipo em endpoint dedicado.
> 3. Exibir nome selecionado e link para abrir no Google Docs.
> 4. Criar fluxo de alteracao/substituicao de template ja selecionado.

**Critérios de aceite do pacote**

> - Admin consegue selecionar e salvar template de Orcamentos.
> - Admin consegue selecionar e salvar template de Contratos.
> - Nome e `fileId` corretos persistem e retornam na tela.

**Áreas impactadas**

> [frontend] bloco de templates na `/settings` | [backend] endpoints de templates | [integrações] Google Picker API

---

### Wp-35 — Flags de ativacao e bloco de documentacao de variaveis


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-35                                    |
| **Spec relacionada**     | [SPEC-02](./spec-google-docs.md#spec-02) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Wp-34                                    |
| **Pode paralelizar com** | Wp-36                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Entregar toggles independentes por tipo documental com validacoes de pre-condicao e os blocos de "Variaveis disponiveis" e "Guia rapido".

**Passos sugeridos de implementacao**

> 1. Implementar toggles `use_google_docs_for_budgets` e `use_google_docs_for_contracts`.
> 2. Validar no backend: toggle so ativa com template correspondente selecionado.
> 3. Renderizar tabela de variaveis por categoria com busca e botao copiar.
> 4. Adicionar secao colapsavel de guia rapido de uso.
> 5. Garantir que desconexao force flags para `false`.

**Critérios de aceite do pacote**

> - Toggles funcionam de forma independente por tipo documental.
> - Ativacao sem template e bloqueada com mensagem clara.
> - Tabela de variaveis tem busca e copia de chave.
> - Desconexao desliga automaticamente ambas as flags.

**Áreas impactadas**

> [frontend] `/settings` bloco Documentos | [backend] endpoints de flags/validacao

---

### Wp-36 — Fachada de geracao documental (Strategy)


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-36                                    |
| **Spec relacionada**     | [SPEC-04](./spec-google-docs.md#spec-04) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Wp-31                                    |
| **Pode paralelizar com** | Wp-35                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Criar `document-generator.service.ts` como ponto unico de entrada e implementar selecao entre estrategia Google e estrategia interna.

**Passos sugeridos de implementacao**

> 1. Criar interface/contrato de estrategia de geracao.
> 2. Implementar `InternalPdfStrategy` encapsulando chamadas existentes de `pdf-generator.ts`.
> 3. Implementar esqueleto de `GoogleDocsStrategy` para uso posterior.
> 4. Redirecionar chamadas existentes para `document-generator.service.ts`.
> 5. Adicionar testes de roteamento de estrategia por flag/status/template.

**Critérios de aceite do pacote**

> - `document-generator.service.ts` e o unico entrypoint de geracao.
> - Roteamento de estrategia respeita flags e estado de integracao.
> - Fluxo interno atual continua funcionando sem regressao.

**Áreas impactadas**

> [backend] `document-generator.service.ts`, fluxo de orcamento/contrato, `pdf-generator.ts` (uso indireto)

---

### Wp-37 — Template engine: substituicao simples e exportacao PDF


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-37                                    |
| **Spec relacionada**     | [SPEC-03](./spec-google-docs.md#spec-03) |
| **Estimativa**           | 3d                                       |
| **Dependencias**         | Wp-36, Wp-34                             |
| **Pode paralelizar com** | Wp-38                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Entregar fluxo Google para variaveis simples: copia de template, `batchUpdate` para placeholders, tratamento de ausentes e exportacao final em PDF.

**Passos sugeridos de implementacao**

> 1. Criar `template-engine.service.ts` para montar payload flat de variaveis.
> 2. Implementar substituicao `replaceAllText` para chaves suportadas.
> 3. Garantir regra de ausentes (string vazia ou placeholder configurado) e log de variaveis vazias.
> 4. Exportar documento processado como PDF via Drive API.
> 5. Tratar limpeza opcional da copia temporaria.

**Critérios de aceite do pacote**

> - Placeholders simples sao substituidos corretamente no PDF final.
> - Nao restam tags `{{chave}}` no resultado.
> - Variaveis sem valor sao tratadas conforme regra definida e auditadas.

**Áreas impactadas**

> [backend] `template-engine.service.ts`, `GoogleDocsStrategy` | [integrações] Docs API / Drive export

---

### Wp-38 — Suporte a blocos tabulares repetitivos


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-38                                    |
| **Spec relacionada**     | [SPEC-03](./spec-google-docs.md#spec-03) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Wp-37                                    |
| **Pode paralelizar com** | Wp-39                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Implementar processamento de linhas modelo para itens de orcamento e servicos de contrato.

**Passos sugeridos de implementacao**

> 1. Identificar linha modelo marcada (`{{budget.items_row}}` e `{{contract.services_row}}`) no documento.
> 2. Duplicar linha para cada item/servico e preencher colunas `{{item.*}}`/`{{service.*}}`.
> 3. Remover linha modelo original apos expansao.
> 4. Adicionar testes com multiplos itens, item unico e lista vazia.

**Critérios de aceite do pacote**

> - Orcamentos com varios itens geram linhas corretas no PDF.
> - Contratos com varios servicos geram linhas corretas no PDF.
> - Linha modelo nao aparece no documento final.

**Áreas impactadas**

> [backend] engine de transformacao de tabela no `GoogleDocsStrategy`

---

### Wp-39 — Resiliencia operacional e desconexao automatica


| Campo                    | Valor                                    |
| ------------------------ | ---------------------------------------- |
| **ID**                   | Wp-39                                    |
| **Spec relacionada**     | [SPEC-04](./spec-google-docs.md#spec-04) |
| **Estimativa**           | 2d                                       |
| **Dependencias**         | Wp-37                                    |
| **Pode paralelizar com** | Wp-38                                    |
| **Status**               | ✅ Concluido                              |


**Escopo**

> Implementar renovacao automatica de token, classificacao de erros Google, politica de nao fallback automatico e sinalizacao administrativa.

**Passos sugeridos de implementacao**

> 1. Criar middleware/helper de renovacao de `access_token` com `refresh_token`.
> 2. Implementar fluxo de desconexao automatica quando refresh estiver invalido/revogado.
> 3. Padronizar respostas para erros: template ausente, timeout/5xx, quota.
> 4. Adicionar banner/alerta para admin em caso de desconexao e risco de quota.
> 5. Registrar logs/metricas sem segredos e configurar alertas operacionais.

**Critérios de aceite do pacote**

> - Token expirado e renovado automaticamente quando possivel.
> - Refresh revogado desconecta integracao e notifica admin.
> - Falhas Google nao disparam fallback automatico para PDF interno.
> - Alertas de quota/desconexao estao visiveis para administradores.

**Áreas impactadas**

> [backend] token lifecycle + error handling | [frontend] banner/alerta admin | [integrações] quota/health Google

---

### Wp-40 — Hardening final, cobertura de testes e validacao E2E


| Campo                    | Valor                                                                                                                                                                  |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **ID**                   | Wp-40                                                                                                                                                                  |
| **Spec relacionada**     | [SPEC-01](./spec-google-docs.md#spec-01), [SPEC-02](./spec-google-docs.md#spec-02), [SPEC-03](./spec-google-docs.md#spec-03), [SPEC-04](./spec-google-docs.md#spec-04) |
| **Estimativa**           | 2d                                                                                                                                                                     |
| **Dependencias**         | Wp-33, Wp-35, Wp-38, Wp-39                                                                                                                                             |
| **Pode paralelizar com** | —                                                                                                                                                                      |
| **Status**               | ✅ Concluido                                                                                                                                                            |


**Escopo**

> Consolidar qualidade de entrega: testes automatizados, validacao com templates reais e checklist de seguranca/documentacao.

**Passos sugeridos de implementacao**

> 1. Cobrir fluxos criticos com testes de integracao/e2e (connect, template select, toggle, generate, disconnect, erros).
> 2. Validar mascaramento de segredos em logs e respostas.
> 3. Executar roteiro manual com templates reais de orcamento e contrato.
> 4. Atualizar documentacao tecnica/operacional da integracao.

**Critérios de aceite do pacote**

> - Suite cobre fluxo feliz e falhas criticas da integracao.
> - Geracao de orcamento/contrato validada em ambiente de homologacao.
> - Documentacao de operacao e troubleshooting publicada.

**Áreas impactadas**

> [backend] testes e ajustes finais | [frontend] testes de UX/fluxo | [integrações] validacao com Google real | [config/env] checklist de variaveis obrigatorias

---

### Mapa de Dependências

Wp-31 → Wp-32 → Wp-33 → Wp-40  
Wp-31 → Wp-36 → Wp-37 → Wp-38 → Wp-40  
Wp-32 → Wp-34 → Wp-35 → Wp-40  
Wp-37 → Wp-39 → Wp-40

---

### Riscos e Pontos Desconhecidos


| #   | Descrição                                                                                                | Probabilidade | Impacto | Mitigação                                                                                                                |
| --- | -------------------------------------------------------------------------------------------------------- | ------------- | ------- | ------------------------------------------------------------------------------------------------------------------------ |
| R01 | Conflito de escopo entre briefing (1 template por tipo) e PRD antigo (multiplos templates por categoria) | Media         | Alto    | Formalizar decisao de escopo para esta entrega: 1 template por tipo documental; registrar backlog para multiplo template |
| R02 | Ambiguidade sobre valor padrao para variavel ausente (vazio vs placeholder configuravel)                 | Alta          | Medio   | Definir politica unica em requisito fechado antes de concluir Wp-37                                                      |
| R03 | Limites e comportamento de quota Google podem variar por projeto/tenant                                  | Media         | Alto    | Implementar monitoramento por limiar e teste de carga moderado antes de go-live                                          |
| R04 | Processamento de tabelas no Google Docs pode ter comportamento diferente por estrutura real do documento | Media         | Alto    | Criar contrato de template (linha modelo obrigatoria) e suite de testes com templates reais                              |
| R05 | Revogacao de token pode falhar em cenarios de rede/transiente                                            | Baixa         | Medio   | Implementar retry controlado + estado local consistente mesmo com revoke remoto falhando                                 |
| R06 | UX de `/settings` pode divergir entre "Aba Documentos" e "secao em Integracoes"                          | Media         | Baixo   | Fechar decisao de IA/UI no inicio do Wp-33 e manter compatibilidade visual                                               |


---

### Oportunidades de Paralelização


| Grupo | WPs          | Pré-requisito                                     |
| ----- | ------------ | ------------------------------------------------- |
| G1    | Wp-33, Wp-34 | Wp-32 concluido                                   |
| G2    | Wp-35, Wp-36 | Wp-34 concluido (Wp-35) e Wp-31 concluido (Wp-36) |
| G3    | Wp-38, Wp-39 | Wp-37 concluido                                   |


