<a id="spec-01"></a>
## SPEC-01 — Integracao OAuth Google Docs e Ciclo de Conexao

**Objetivo**
> Habilitar conexao segura de um unico workspace Google via OAuth 2.0 para uso de templates documentais, sem quebrar o fluxo atual interno de PDF.

**Contexto**
> A plataforma gera orcamentos e contratos em PDF por implementacao interna (`pdf-generator.ts`). O briefing define adicao opcional de Google Docs para dar autonomia ao admin, com restricoes de seguranca (RBAC admin, escopo minimo, criptografia de token e protecao CSRF) e reconexao substitutiva.

**Comportamento esperado**
> Fluxo OAuth detalhado:
> 1. Admin clica em "Conectar com Google" na tela `/settings`.
> 2. Backend gera URL de autorizacao OAuth com parametro `state` (anti-CSRF).
> 3. Admin e redirecionado para consentimento Google.
> 4. Google redireciona para callback da aplicacao.
> 5. Backend valida `state`, troca `code` por `access_token` + `refresh_token`.
> 6. Sistema persiste tokens e metadados de conexao.
> 7. Admin retorna para `/settings` com status visual "Conectado".
>
> Fluxo de desconexao:
> 1. Admin aciona "Remover" na integracao.
> 2. Sistema exibe confirmacao com impactos.
> 3. Ao confirmar, backend revoga token no Google e limpa dados locais.
> 4. Integracao passa para "Desconectado".
>
> Fluxo de reconexao:
> 1. Quando existe conexao ativa e o admin reconecta, a conexao anterior e substituida.
> 2. O sistema mantem a regra de um workspace conectado por vez.

**Regras de negocio**
> - Apenas usuarios com papel `admin` DEVEM configurar, gerenciar ou remover a integracao.
> - O fluxo de autorizacao DEVE usar OAuth 2.0 e NAO DEVE usar API Key para autenticacao.
> - O escopo OAuth DEVE ser `https://www.googleapis.com/auth/drive.file`.
> - O parametro `state` DEVE ser validado no callback.
> - O `refresh_token` DEVE ser armazenado criptografado em repouso.
> - O `access_token` PODE ser armazenado em cache seguro ou criptografado.
> - Tokens NAO DEVEM ser expostos em respostas de API ou logs.
> - O sistema DEVE suportar um unico workspace Google conectado por vez.
> - SE houver reconexao, ENTAO a conexao anterior DEVE ser substituida.
> - SE houver desconexao, ENTAO os dados de token/conexao DEVEM ser limpos e o token DEVE ser revogado no Google.

**Criterios de aceite**
> - DADO admin autenticado QUANDO clicar em "Conectar" ENTAO e redirecionado para OAuth Google com escopo `drive.file`.
> - DADO callback OAuth com `state` valido QUANDO processar o `code` ENTAO o sistema persiste os dados de conexao e retorna status conectado.
> - DADO callback OAuth com `state` invalido QUANDO processar ENTAO a conexao e negada com erro controlado.
> - DADO usuario nao-admin QUANDO tentar conectar/gerenciar/remover ENTAO o acesso e bloqueado.
> - DADO integracao conectada QUANDO admin confirmar remocao ENTAO o token e revogado no Google e os dados locais sao removidos.
> - DADO conexao ativa QUANDO admin reconectar ENTAO somente a conexao mais recente permanece valida.

**Estado atual**
> Existe geracao interna de PDF funcionando. Nao ha, no briefing, garantia de implementacao completa do ciclo OAuth Google especifico para templates.

**Mudancas necessarias**
> - **Banco de dados:** persistir `google_access_token`, `google_refresh_token`, `google_connected_at`, `google_connected_by_user_id`, `google_connected_by_name`, `google_token_expiry`.
> - **Backend:** implementar endpoints de `connect`, `callback`, `disconnect`, validacao de CSRF (`state`), troca/renovacao/revogacao de token.
> - **Frontend:** expor status de conexao e metadados do responsavel/data na `/settings`.
> - **Integracoes externas:** OAuth Google + endpoint de revoke (`https://oauth2.googleapis.com/revoke`).
> - **Seguranca:** mascaramento de segredos em logs/tracing/respostas.

**Definicao de pronto**
> - [ ] Funcionalidade implementada conforme comportamento esperado
> - [ ] Todos os criterios de aceite validados
> - [ ] Casos de erro tratados e com feedback ao usuario
> - [ ] Codigo revisado por outro membro do time
> - [ ] Fluxo OAuth completo (connect, callback, disconnect) validado em homologacao
> - [ ] `refresh_token` armazenado criptografado e sem vazamento em logs/respostas
> - [ ] Regra de um workspace por vez validada (incluindo reconexao)

<a id="spec-02"></a>
## SPEC-02 — Configuracao UX em `/settings` (Card, Templates, Flags e Guia)

**Objetivo**
> Entregar experiencia completa de configuracao da integracao Google Docs na `/settings`, incluindo card de integracao, configuracao de templates, toggles de ativacao e orientacoes de uso.

**Contexto**
> O briefing exige UX de integracao em formato de card (estilo Slack/Linear/ClickUp), com estados conectada/desconectada, gestao de templates por Google Picker, duas flags independentes (orcamento e contrato), e area de apoio para variaveis e guia rapido.

**Comportamento esperado**
> Aba "Integracoes" (card):
> 1. Card exibe icone, nome "Google Docs", descricao curta e badge de status.
> 2. Estado desconectado: badge "Desconectado" + botao "Conectar".
> 3. Estado conectado: badge "Conectado", texto "Conectado por [nome] em [data]", botoes "Gerenciar" e "Remover".
> 4. Ao clicar "Remover", exibir modal informando:
>    - flags de geracao por template serao desativadas;
>    - templates selecionados serao desvinculados;
>    - arquivos no Google Drive nao serao excluidos.
>
> Aba/secao "Documentos" (visivel apenas conectado):
> 1. Bloco A - Configuracao de Templates:
>    - secao de Orcamentos e secao de Contratos;
>    - botao "Selecionar documento" abre Google Picker;
>    - apos selecao, exibe nome do arquivo + link para abrir no Google Docs;
>    - botao "Alterar" permite trocar template;
>    - toggle ativa/desativa geracao por template.
> 2. Bloco B - Variaveis disponiveis:
>    - tabela de chaves com busca por variavel;
>    - agrupamento por categoria;
>    - botao "Copiar" ao lado de cada chave.
> 3. Bloco C - Guia rapido:
>    - secao colapsavel com passo a passo de como criar template no Google Docs e ativar no sistema.

**Regras de negocio**
> - O sistema DEVE persistir por tipo documental:
>   - `budget_template_file_id`, `budget_template_name`,
>   - `contract_template_file_id`, `contract_template_name`.
> - As flags `use_google_docs_for_budgets` e `use_google_docs_for_contracts` DEVEM ser independentes.
> - Toggle de um tipo documental SO DEVE ativar se houver template selecionado para esse tipo.
> - SE a integracao for desconectada, ENTAO ambas as flags DEVEM ser automaticamente revertidas para `false`.
> - O Google Picker DEVE mostrar apenas arquivos acessiveis pelo usuario autenticado no Google.
> - Apenas `admin` DEVE gerenciar templates, flags e desconexao.
> - A secao "Documentos" DEVE ser invisivel/inoperante quando status for `Desconectado`.
> - O sistema NAO DEVE excluir arquivos no Google Drive durante remocao da integracao.

**Criterios de aceite**
> - DADO integracao desconectada QUANDO admin acessar `/settings` ENTAO visualiza card com status desconectado e acao "Conectar".
> - DADO integracao conectada QUANDO admin abrir `/settings` ENTAO visualiza "Conectado por [nome] em [data]" e acoes de gerenciamento.
> - DADO admin conectado QUANDO selecionar template de Orcamentos no Picker ENTAO `fileId` e nome sao salvos e exibidos.
> - DADO admin conectado QUANDO selecionar template de Contratos no Picker ENTAO `fileId` e nome sao salvos e exibidos.
> - DADO template nao selecionado para Contratos QUANDO tentar ativar toggle de Contratos ENTAO a ativacao e bloqueada com feedback claro.
> - DADO flags ativas QUANDO admin remover integracao ENTAO flags voltam para `false` e templates sao desvinculados.
> - DADO bloco de variaveis QUANDO admin pesquisar por chave ENTAO resultados sao filtrados por texto mantendo categoria.
> - DADO uma chave de variavel QUANDO admin clicar em "Copiar" ENTAO a chave e enviada para area de transferencia.

**Estado atual**
> O fluxo interno de documentos existe, mas o briefing trata card de integracao + configuracao de templates/flags como evolucao da camada administrativa de `/settings`.

**Mudancas necessarias**
> - **Banco de dados:** campos de template por tipo e flags independentes.
> - **Backend:** endpoints para salvar templates, atualizar flags com validacao de pre-condicao e limpar estado na desconexao.
> - **Frontend:** UI de card, modal de remocao, Bloco A/B/C da secao de documentos.
> - **Integracoes externas:** Google Picker API para selecao de templates.

**Definicao de pronto**
> - [ ] Funcionalidade implementada conforme comportamento esperado
> - [ ] Todos os criterios de aceite validados
> - [ ] Casos de erro tratados e com feedback ao usuario
> - [ ] Codigo revisado por outro membro do time
> - [ ] Card da integracao exibe corretamente estados conectado/desconectado
> - [ ] Blocos A, B e C da secao de documentos entregues
> - [ ] Flags independentes funcionando com pre-condicao de template selecionado

<a id="spec-03"></a>
## SPEC-03 — Catalogo de Variaveis e Motor de Substituicao

**Objetivo**
> Definir e executar substituicao de variaveis `{{chave}}` em templates Google Docs, incluindo variaveis simples e blocos tabulares repetitivos para orcamentos e contratos.

**Contexto**
> O briefing define catalogo inicial de chaves alinhado ao estado atual da aplicacao, com padrao `{{entidade.campo}}`. A geracao por template deve montar payload flat, executar `replaceAllText`, tratar ausencias e processar linhas-modelo para repeticao de itens.

**Comportamento esperado**
> Fluxo de geracao via template:
> 1. Usuario solicita geracao de documento (orcamento ou contrato).
> 2. Sistema verifica flag de ativacao por tipo.
> 3. Se flag `false`: usa fluxo interno de PDF atual.
> 4. Se flag `true`: busca `fileId`, cria copia do template no Drive, monta payload de variaveis.
> 5. Executa `batchUpdate` para substituir cada `{{chave}}` por valor.
> 6. Processa blocos de repeticao de tabela quando houver linha-modelo.
> 7. Exporta documento final como PDF e retorna ao usuario.
> 8. Copia temporaria pode ser removida ao final (comportamento opcional).
>
> Catalogo inicial de variaveis (obrigatorio na especificacao funcional):
> - Lead/Cliente (`{{lead.id}}`, `{{lead.clientType}}`, `{{lead.responsibleName}}`, `{{lead.responsibleCpf}}`, `{{lead.cnpj}}`, `{{lead.companyName}}`, `{{lead.tradeName}}`, `{{lead.freeDocument}}`, `{{lead.billingEmailsCsv}}`, `{{lead.billingEmailPrimary}}`, `{{lead.salespersonId}}`, `{{lead.accountManagerId}}`, `{{lead.originType}}`, `{{lead.originChannelLabel}}`, `{{lead.source}}`, `{{lead.autoInvoiceEnabled}}`, `{{lead.isDelinquent}}`, `{{lead.delinquencyStage}}`, `{{lead.delinquencyDays}}`, `{{lead.createdAt}}`, `{{lead.updatedAt}}`).
> - Empresa/Configuracoes (`{{company.name}}`, `{{company.tradeName}}`, `{{company.cnpj}}`, `{{company.email}}`, `{{company.address}}`, `{{company.logoUrl}}`, `{{company.primaryColor}}`, `{{company.secondaryColor}}`, `{{company.defaultTheme}}`, `{{settings.autoInvoiceEnabled}}`, `{{settings.lateFeePercent}}`, `{{settings.monthlyInterestPercent}}`, `{{settings.gracePeriodDays}}`).
> - Orcamento (`{{budget.id}}`, `{{budget.simulationId}}`, `{{budget.leadId}}`, `{{budget.name}}`, `{{budget.periodicity}}`, `{{budget.discountType}}`, `{{budget.discountValue}}`, `{{budget.subtotal}}`, `{{budget.totalDiscount}}`, `{{budget.total}}`, `{{budget.notes}}`, `{{budget.status}}`, `{{budget.approvalStatus}}`, `{{budget.approvalComment}}`, `{{budget.approvedAt}}`, `{{budget.createdAt}}`, `{{budget.updatedAt}}`, `{{budget.annualProjection}}`, `{{budget.validUntil}}`).
> - Itens do Orcamento (repeticao): `{{budget.items_row}}`, `{{item.serviceName}}`, `{{item.billingModel}}`, `{{item.billingModelLabel}}`, `{{item.unitPrice}}`, `{{item.quantity}}`, `{{item.subtotal}}`.
> - Contrato (`{{contract.id}}`, `{{contract.leadId}}`, `{{contract.moduleId}}`, `{{contract.moduleName}}`, `{{contract.packageId}}`, `{{contract.packageName}}`, `{{contract.leadNeedVersionId}}`, `{{contract.startDate}}`, `{{contract.endDate}}`, `{{contract.billingPeriod}}`, `{{contract.status}}`, `{{contract.lastQuoteUrl}}`, `{{contract.lastQuoteDate}}`, `{{contract.lastContractUrl}}`, `{{contract.lastContractDate}}`, `{{contract.createdAt}}`, `{{contract.updatedAt}}`, `{{contract.totalValue}}`).
> - Servicos do Contrato (repeticao): `{{contract.services_row}}`, `{{service.serviceName}}`, `{{service.billingModel}}`, `{{service.billingModelLabel}}`, `{{service.unitPrice}}`, `{{service.quantity}}`, `{{service.total}}`.

**Regras de negocio**
> - O sistema DEVE adotar o padrao de chave `{{entidade.campo}}`.
> - O motor DEVE receber dados e montar payload flat `Record<string, string>`.
> - O sistema DEVE substituir todas as tags encontradas por valor correspondente.
> - SE nao houver valor para uma variavel, ENTAO DEVE substituir por string vazia `""` ou placeholder configuravel.
> - O sistema DEVE registrar para auditoria quais variaveis ficaram vazias.
> - O documento final NAO DEVE manter tags literais `{{chave}}`.
> - Para tabela, o template DEVE conter linha-modelo (`{{budget.items_row}}` ou `{{contract.services_row}}`).
> - O sistema DEVE duplicar linha-modelo para cada item, preencher colunas e remover a linha-modelo original.

**Criterios de aceite**
> - DADO documento com variaveis simples QUANDO gerar PDF ENTAO todas as tags mapeadas sao substituidas.
> - DADO variaveis sem valor QUANDO gerar PDF ENTAO o documento final nao contem tags literais remanescentes.
> - DADO template com `{{budget.items_row}}` e 3 itens QUANDO gerar PDF ENTAO 3 linhas de item sao renderizadas e a linha modelo e removida.
> - DADO template com `{{contract.services_row}}` e N servicos QUANDO gerar PDF ENTAO N linhas sao renderizadas com valores corretos.
> - DADO catalogo de variaveis na configuracao QUANDO admin consulta ENTAO visualiza chaves agrupadas e passivel de copia.

**Estado atual**
> Existe geracao interna de PDF, mas o fluxo de template Google com catalogo de variaveis e processamento de repeticao tabular e uma entrega nova conforme briefing.

**Mudancas necessarias**
> - **Backend:** implementar `template-engine.service.ts` e mecanismos de substituicao simples/tabular.
> - **Backend:** implementar exportacao final para PDF via Drive API.
> - **Frontend:** exibir catalogo de variaveis com busca/copia.
> - **Documentacao de UX:** incluir instrucao explicita da linha-modelo no guia rapido.

**Definicao de pronto**
> - [ ] Funcionalidade implementada conforme comportamento esperado
> - [ ] Todos os criterios de aceite validados
> - [ ] Casos de erro tratados e com feedback ao usuario
> - [ ] Codigo revisado por outro membro do time
> - [ ] Catalogo inicial de variaveis publicado e visivel para admin
> - [ ] Substituicao simples e tabular validada com templates reais
> - [ ] Nenhuma tag literal `{{chave}}` aparece no documento final

<a id="spec-04"></a>
## SPEC-04 — Fachada de Geracao, Resiliencia, Seguranca e Escopo de Entrega

**Objetivo**
> Consolidar geracao documental por Strategy (Google vs interno), com fallback controlado, tratamento robusto de erros, seguranca operacional e delimitacao clara de escopo.

**Contexto**
> O briefing pede `document-generator.service.ts` como fachada unica, mantendo `pdf-generator.ts` como fallback padrao. Tambem define matriz de erros esperados, regras de seguranca, variaveis de ambiente e itens fora de escopo.

**Comportamento esperado**
> Fachada Strategy:
> 1. Todas as chamadas de geracao passam por `document-generator.service.ts`.
> 2. A fachada decide estrategia por status de integracao + template configurado + flag do tipo.
> 3. `GoogleDocsStrategy` e usada quando todos pre-requisitos estao validos.
> 4. `InternalPdfStrategy` e usada quando flag desativada ou integracao indisponivel.
>
> Tratamento de erros/resiliencia:
> 1. Token expirado: renovar automaticamente via `refresh_token` antes da requisicao.
> 2. Refresh token invalido/revogado: marcar integracao como `Desconectada` e notificar admin.
> 3. Template nao encontrado no Drive: erro claro para usuario com sugestao de reconfigurar template.
> 4. Timeout/5xx Google: registrar erro, retornar mensagem amigavel e NAO executar fallback automatico para PDF interno.
> 5. Quota Google: monitorar consumo e alertar admin antes do limite.

**Regras de negocio**
> - O arquivo `pdf-generator.ts` NAO DEVE ser removido (fallback oficial).
> - O `document-generator.service.ts` DEVE ser o unico ponto de entrada de geracao.
> - Em falha operacional da API Google, o sistema NAO DEVE trocar automaticamente para PDF interno.
> - Rota de configuracao da integracao DEVE verificar papel `admin`.
> - Tokens NAO DEVEM ser logados em nenhuma circunstancia.
> - Credenciais OAuth (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`) DEVEM permanecer apenas no backend.
> - O sistema DEVE usar as variaveis de ambiente:
>   - `GOOGLE_CLIENT_ID`
>   - `GOOGLE_CLIENT_SECRET`
>   - `GOOGLE_REDIRECT_URI`
>   - `NEXT_PUBLIC_GOOGLE_PICKER_API_KEY`
>   - `NEXT_PUBLIC_GOOGLE_APP_ID`
>   - `INTERNAL_VAULT_KEY` (`TOKEN_ENCRYPTION_KEY` na nomenclatura funcional)
> - Escopo fora da entrega atual:
>   - edicao de templates dentro da aplicacao;
>   - assinatura digital dos documentos;
>   - multiplas contas Google simultaneas;
>   - historico de versoes dos documentos gerados;
>   - preview renderizado do template dentro da aplicacao.

**Criterios de aceite**
> - DADO qualquer ponto de geracao de documento QUANDO acionar o fluxo ENTAO o sistema usa `document-generator.service.ts` como entrypoint.
> - DADO integracao indisponivel ou flag desativada QUANDO gerar documento ENTAO sistema usa `InternalPdfStrategy`.
> - DADO falha 5xx/timeout da API Google QUANDO gerar documento ENTAO usuario recebe erro amigavel sem fallback automatico.
> - DADO `refresh_token` revogado QUANDO tentar renovar ENTAO integracao e desconectada e admin e notificado.
> - DADO auditoria de seguranca QUANDO inspecionar logs/respostas ENTAO nenhum token em texto claro e encontrado.
> - DADO ambiente sem variavel obrigatoria QUANDO iniciar modulo de integracao ENTAO o sistema falha de forma controlada com diagnostico claro.

**Estado atual**
> A geracao interna esta presente e e a base atual do produto. A consolidacao por Strategy, matriz de resiliencia Google e delimitacao formal de escopo precisam ser explicitamente incorporadas para evitar lacunas de implementacao.

**Mudancas necessarias**
> - **Backend:** criar `document-generator.service.ts` e substituir chamadas diretas a `pdf-generator.ts`.
> - **Backend:** implementar classificacao de erro e renovacao de token com desconexao automatica por revogacao.
> - **Frontend:** exibir feedbacks amigaveis de erro e banners de desconexao/quota para admin.
> - **Observabilidade:** logs estruturados e alertas para erros de integracao/quota.
> - **Config/env:** validar variaveis obrigatorias em startup/deploy.

**Definicao de pronto**
> - [ ] Funcionalidade implementada conforme comportamento esperado
> - [ ] Todos os criterios de aceite validados
> - [ ] Casos de erro tratados e com feedback ao usuario
> - [ ] Codigo revisado por outro membro do time
> - [ ] Fachada Strategy aplicada em todos os pontos de geracao documental
> - [ ] Matriz de erros/resiliencia implementada sem fallback automatico indevido
> - [ ] Requisitos de seguranca e variaveis de ambiente auditados
