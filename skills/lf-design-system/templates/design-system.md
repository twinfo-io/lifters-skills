# Design System — {{DESIGN_SYSTEM_NAME}}

> **Versão:** {{VERSION}}
> **Gerado em:** {{DATE}}
> **Fonte:** {{FIGMA_URL}}
> **Padrões:** W3C WCAG 2.1 AA · WAI-ARIA 1.2 · {{CSS_METHODOLOGY}}
> **Status:** Fonte de verdade oficial do projeto
>
> **Uso:** Este documento é a fonte de verdade para agentes de IA construírem qualquer tela do sistema {{DESIGN_SYSTEM_NAME}} a partir dos padrões aqui descritos.

---

## Fonte de verdade

Este arquivo consolida o design system oficial do projeto **{{DESIGN_SYSTEM_NAME}}** a partir dos seguintes nodes do Figma:

| Categoria | Node ID | Nome no Figma |
|---|---|---|
| Tipografia | `{{NODE_TYPOGRAPHY}}` | {{NODE_TYPOGRAPHY_NAME}} |
| Cores | `{{NODE_COLORS}}` | {{NODE_COLORS_NAME}} |
| Espaçamento | `{{NODE_SPACING}}` | {{NODE_SPACING_NAME}} |
| Border Radius | `{{NODE_RADIUS}}` | {{NODE_RADIUS_NAME}} |
| Sombras | `{{NODE_SHADOWS}}` | {{NODE_SHADOWS_NAME}} |
| Componentes | `{{NODE_COMPONENTS}}` | {{NODE_COMPONENTS_NAME}} |

Se houver conflito entre implementação local e este arquivo, **o Figma e este arquivo vencem**.

---

## Uso obrigatório

- Toda tela, página, componente e estado visual deve usar este design system.
- Não introduzir novas famílias tipográficas, escalas de texto ou paletas ad hoc sem atualizar este arquivo primeiro.
- Sempre preferir nomes semânticos de token em vez de valores soltos no código.
- Em componentes de biblioteca de UI (ex.: `shadcn/ui`, `Radix`, `MUI`), sobrescrever variantes e tokens para refletir este design system.
- Textos de apoio e secundários devem preferir tokens de cor de texto secundário.
- Bordas, grids e divisores devem preferir tokens de borda neutros.
- Botões e CTAs devem partir do token primário da marca.
- Estados de erro, sucesso e informação devem usar os tokens de status desta documentação.
- Overlays, hover e estados de interação devem usar o sistema de alpha definido neste arquivo — nunca sobrescrever a cor de fundo subjacente com cor sólida.

---

## Notas de interpretação

> Liste aqui todas as inferências e decisões tomadas durante a extração do Figma.
> Se não houver ambiguidades, escreva: "Nenhuma ambiguidade identificada — todos os valores foram lidos diretamente do Figma."

- **Inferência:** {{NOTE_1}}
- **Inferência:** {{NOTE_2}}

---

## 1. DESIGN TOKENS

### 1.1 Paleta de Cores — Brand

Inclui a cor primária da marca e todas as suas variantes de opacidade/alpha usadas em backgrounds, hovers e estados interativos.

| Token | Valor HEX / RGBA | Uso principal |
|---|---|---|
| `{{BRAND_TOKEN_100}}` | `{{BRAND_HEX_100}}` | Cor primária da marca — botões CTA, ícones ativos, destaques |
| `{{BRAND_TOKEN_90}}` | `{{BRAND_HEX_90}}` | Variante alpha 90% — hover de botão primário |
| `{{BRAND_TOKEN_40}}` | `{{BRAND_HEX_40}}` | Variante alpha 40% — focus ring, estados intermediários |
| `{{BRAND_TOKEN_20}}` | `{{BRAND_HEX_20}}` | Variante alpha 20% — background suave de destaque |
| `{{BRAND_TOKEN_12}}` | `{{BRAND_HEX_12}}` | Variante alpha 12% — background de item ativo na nav |
| `{{BRAND_TOKEN_8}}` | `{{BRAND_HEX_8}}` | Variante alpha 8% — background ultra suave |
| `{{BRAND_TOKEN_4}}` | `{{BRAND_HEX_4}}` | Variante alpha 4% — background quase transparente |
| `{{BRAND_TOKEN_BLACK}}` | `{{BRAND_HEX_BLACK}}` | Texto principal, ícones ativos — tom escuro da marca |
| `{{BRAND_TOKEN_WHITE}}` | `#ffffff` | Texto em fundos escuros / botão primário |

### 1.2 Paleta de Cores — Accent

Cores de destaque para elementos editoriais, tags, links e avisos visuais.

| Token | Valor HEX | Uso |
|---|---|---|
| `{{ACCENT_PURPLE}}` | `{{ACCENT_PURPLE_HEX}}` | Destaque roxo — tags, labels especiais |
| `{{ACCENT_BLUE}}` | `{{ACCENT_BLUE_HEX}}` | Links, estados informativos |
| `{{ACCENT_RED}}` | `{{ACCENT_RED_HEX}}` | Erro / destrutivo |
| `{{ACCENT_GREEN}}` | `{{ACCENT_GREEN_HEX}}` | Sucesso / confirmação |
| `{{ACCENT_YELLOW}}` | `{{ACCENT_YELLOW_HEX}}` | Aviso / atenção |

### 1.3 Paleta de Cores — Superfície e Fundo

Tokens para backgrounds de cards, modais, painéis e o fundo geral da aplicação.

| Token | Valor HEX | Uso |
|---|---|---|
| `{{SURFACE}}` | `{{SURFACE_HEX}}` | Cards, modais, painéis elevados |
| `{{SURFACE_RAISED}}` | `{{SURFACE_RAISED_HEX}}` | Superfície elevada — dropdowns, tooltips |
| `{{BACKGROUND_BASE}}` | `{{BACKGROUND_BASE_HEX}}` | Fundo geral da aplicação |
| `{{BACKGROUND_LIGHTER}}` | `{{BACKGROUND_LIGHTER_HEX}}` | Variante mais clara do fundo |
| `{{BORDER_FAINT}}` | `{{BORDER_FAINT_HEX}}` | Divisores e bordas muito suaves |
| `{{BORDER_MUTED}}` | `{{BORDER_MUTED_HEX}}` | Bordas padrão de inputs e containers |
| `{{BORDER_LOUD}}` | `{{BORDER_LOUD_HEX}}` | Bordas com maior contraste visual |

### 1.4 Sistema de Alpha / Overlay

Utilizado para hover, press e estados de interação sem sobrescrever a cor de fundo subjacente. Aplicar sobre qualquer superfície para obter o efeito de camada.

| Token | Valor RGBA | Uso típico |
|---|---|---|
| `{{ALPHA_2}}` | `{{ALPHA_2_RGBA}}` | Row hover ultra-suave |
| `{{ALPHA_4}}` | `{{ALPHA_4_RGBA}}` | Tab group background, ghost button base |
| `{{ALPHA_7}}` | `{{ALPHA_7_RGBA}}` | Button press / active |
| `{{ALPHA_10}}` | `{{ALPHA_10_RGBA}}` | Hover padrão de botões |
| `{{ALPHA_16}}` | `{{ALPHA_16_RGBA}}` | Hover em itens de lista |
| `{{ALPHA_40}}` | `{{ALPHA_40_RGBA}}` | Texto secundário / placeholder |
| `{{ALPHA_56}}` | `{{ALPHA_56_RGBA}}` | Texto desabilitado / estado inativo |

### 1.5 Cores — Brand e primárias (tokens canônicos)

| Token | Papel | Hex |
|---|---|---|
| `brand-primary` | Cor primária principal da interface | `{{COLOR_BRAND_PRIMARY_HEX}}` |
| `brand-secondary` | Cor secundária / complementar | `{{COLOR_BRAND_SECONDARY_HEX}}` |
| `brand-accent` | Acento editorial / destaque de display | `{{COLOR_BRAND_ACCENT_HEX}}` |

### 1.6 Cores — Neutras

| Token | Papel | Hex |
|---|---|---|
| `neutral-white` | Branco puro | `#FFFFFF` |
| `neutral-black` | Preto profundo / base escura | `{{COLOR_NEUTRAL_BLACK_HEX}}` |
| `neutral-text-primary` | Texto primário | `{{COLOR_NEUTRAL_TEXT_PRIMARY_HEX}}` |
| `neutral-text-secondary` | Texto secundário | `{{COLOR_NEUTRAL_TEXT_SECONDARY_HEX}}` |
| `neutral-border` | Bordas e divisores | `{{COLOR_NEUTRAL_BORDER_HEX}}` |
| `neutral-bg-soft` | Fundo suave | `{{COLOR_NEUTRAL_BG_SOFT_HEX}}` |
| `neutral-card` | Fundo de card neutro | `{{COLOR_NEUTRAL_CARD_HEX}}` |

### 1.7 Cores — Feedback / Status

| Token | Papel | Hex |
|---|---|---|
| `status-success` | Sucesso / confirmação | `{{COLOR_STATUS_SUCCESS_HEX}}` |
| `status-error` | Erro / alerta crítico | `{{COLOR_STATUS_ERROR_HEX}}` |
| `status-warning` | Aviso / atenção | `{{COLOR_STATUS_WARNING_HEX}}` |
| `status-info` | Info / estado informativo | `{{COLOR_STATUS_INFO_HEX}}` |

---

## 2. TIPOGRAFIA

### 2.1 Família Tipográfica

| Papel | Família | Pesos permitidos | Uso |
|---|---|---|---|
| Display / Heading | `{{FONT_DISPLAY}}` | `{{FONT_DISPLAY_WEIGHTS}}` | Títulos, hero, headings e destaques editoriais |
| Body / UI | `{{FONT_BODY}}` | `{{FONT_BODY_WEIGHTS}}` | Texto corrido, labels, botões, captions, KPI e UI geral |

**Fallback stack recomendado:**
```
"{{FONT_BODY}}", "{{FONT_BODY}} Fallback", ui-sans-serif, system-ui, sans-serif,
"Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"
```

> **Nota:** O fallback stack garante compatibilidade entre plataformas. Em caso de indisponibilidade da fonte primária, o sistema usa `ui-sans-serif` como fallback nativo.

> **Font weight não-padrão:** Alguns sistemas utilizam pesos intermediários como `450` (entre regular `400` e medium `500`) para labels interativos. Verificar disponibilidade na fonte selecionada.

### 2.2 Escala Tipográfica — Display e Headings

| Token | Família | Peso | Tamanho | Line Height | Letter Spacing |
|---|---|---:|---:|---:|---:|
| `display-2xl` | `{{FONT_DISPLAY}}` | `700` | `64px` | `72px` | `-2` |
| `display-xl` | `{{FONT_DISPLAY}}` | `700` | `48px` | `56px` | `-2` |
| `display-lg` | `{{FONT_DISPLAY}}` | `700` | `40px` | `48px` | `-1` |
| `heading-h1` | `{{FONT_DISPLAY}}` | `700` | `32px` | `40px` | `-1` |
| `heading-h2` | `{{FONT_DISPLAY}}` | `600` | `24px` | `32px` | `-0.5` |
| `heading-h3` | `{{FONT_DISPLAY}}` | `600` | `20px` | `28px` | `0` |
| `heading-h4` | `{{FONT_DISPLAY}}` | `600` | `16px` | `24px` | `0` |

### 2.3 Escala Tipográfica — Body e UI

| Token | Família | Peso | Tamanho | Line Height | Uso |
|---|---|---:|---:|---:|---|
| `text-label-x-large` | `{{FONT_BODY}}` | `500` | `18px` | `28px` | Títulos de seção, cabeçalhos principais |
| `text-label-large` | `{{FONT_BODY}}` | `500` | `16px` | `24px` | Labels de grupo, cabeçalhos de card |
| `text-label-medium` | `{{FONT_BODY}}` | `450` | `14px` | `20px` | Botões, links de navegação, labels |
| `text-label-small` | `{{FONT_BODY}}` | `450` | `13px` | `18px` | Tags, badges, metadata |
| `text-body` | `{{FONT_BODY}}` | `400` | `15px` | `22px` | Inputs, conteúdo textual corrido |
| `text-caption` | `{{FONT_BODY}}` | `400` | `12px` | `16px` | Timestamps, info secundária |
| `body-lg` | `{{FONT_BODY}}` | `400` | `18px` | `28px` | Corpo editorial amplo |
| `body-md` | `{{FONT_BODY}}` | `400` | `16px` | `24px` | Corpo padrão |
| `body-sm` | `{{FONT_BODY}}` | `400` | `14px` | `20px` | Corpo compacto |
| `body-xs` | `{{FONT_BODY}}` | `400` | `12px` | `16px` | Corpo mínimo |
| `label-lg` | `{{FONT_BODY}}` | `500` | `16px` | `24px` | Label grande |
| `label-md` | `{{FONT_BODY}}` | `500` | `14px` | `20px` | Label médio |
| `label-sm` | `{{FONT_BODY}}` | `500` | `12px` | `16px` | Label pequeno |
| `button-lg` | `{{FONT_BODY}}` | `500` | `16px` | `24px` | Botão grande |
| `button-md` | `{{FONT_BODY}}` | `500` | `14px` | `20px` | Botão médio |
| `button-sm` | `{{FONT_BODY}}` | `500` | `12px` | `16px` | Botão pequeno |
| `caption-md` | `{{FONT_BODY}}` | `400` | `12px` | `16px` | Caption padrão |
| `caption-sm` | `{{FONT_BODY}}` | `400` | `11px` | `16px` | Caption mínimo, section labels uppercase |
| `kpi-xl` | `{{FONT_BODY}}` | `700` | `40px` | `48px` | KPI / métrica destaque grande |
| `kpi-lg` | `{{FONT_BODY}}` | `700` | `32px` | `40px` | KPI grande |
| `kpi-md` | `{{FONT_BODY}}` | `600` | `24px` | `32px` | KPI médio |

---

## 3. ESPAÇAMENTO & GRID

### 3.1 Escala de Espaçamento (base 4px)

| Token | px | rem | Uso típico |
|---|---:|---:|---|
| `space-1` | `4px` | `0.25rem` | Espaçamento mínimo entre elementos inline |
| `space-1.5` | `6px` | `0.375rem` | Padding de botões compactos |
| `space-2` | `8px` | `0.5rem` | Padding interno de badges e chips |
| `space-3` | `12px` | `0.75rem` | Gap entre ícone e label |
| `space-4` | `16px` | `1rem` | Padding padrão de cards e botões |
| `space-5` | `20px` | `1.25rem` | Espaçamento entre seções internas |
| `space-6` | `24px` | `1.5rem` | Padding lateral de containers compactos |
| `space-8` | `32px` | `2rem` | Espaçamento entre blocos de conteúdo / padding de seções |
| `space-9` | `36px` | `2.25rem` | Altura/largura de itens de menu e nav |
| `space-10` | `40px` | `2.5rem` | Seções de página |
| `space-12` | `48px` | `3rem` | Seções hero e espaçamento maior |
| `space-16` | `64px` | `4rem` | Separação entre módulos de página / altura de topbar |
| `space-20` | `80px` | `5rem` | Margens de layout full-width |
| `space-24` | `96px` | `6rem` | Seções de landing page |

### 3.2 Layout Principal

```
┌─────────────────────────────────────────────────────────────────┐
│  TOPBAR (header)  — altura: {{TOPBAR_HEIGHT}}  — full width     │
├───────────────────┬─────────────────────────────────────────────┤
│                   │                                             │
│   SIDEBAR         │         CONTENT AREA                        │
│  (aside/nav)      │         (main)                              │
│  width: {{SIDEBAR_WIDTH}}  │  flex-1 (fluid)                    │
│  bg: {{SIDEBAR_BG}}        │  bg: {{CONTENT_BG}}               │
│  border-right:    │                                             │
│  {{SIDEBAR_BORDER}}        │                                     │
│                   │                                             │
├───────────────────┴─────────────────────────────────────────────┤
│  FOOTER (sidebar bottom) — fixado na base da sidebar            │
└─────────────────────────────────────────────────────────────────┘
```

| Elemento | Dimensão | Cor de fundo | Borda |
|---|---|---|---|
| Topbar | altura: `{{TOPBAR_HEIGHT}}` | `{{TOPBAR_BG}}` | `{{TOPBAR_BORDER}}` |
| Sidebar | largura: `{{SIDEBAR_WIDTH}}` | `{{SIDEBAR_BG}}` | `{{SIDEBAR_BORDER}}` |
| Content area | flex-1 (fluid) | `{{CONTENT_BG}}` | — |

### 3.3 Container Máximo de Conteúdo

| Token | Valor | Uso |
|---|---|---|
| `--container-width` | `{{CONTAINER_WIDTH}}` | Largura máxima do conteúdo principal |
| `--container-width-padding` | `{{CONTAINER_WIDTH_PADDING}}` | Largura com padding lateral incluído |

---

## 4. BORDER RADIUS

| Token | Valor | Uso |
|---|---|---|
| `radius-none` | `0px` | Sem arredondamento (tabelas, separadores) |
| `radius-xs` | `4px` | Badges de texto, chips de status |
| `radius-sm` | `{{RADIUS_SM}}` | Inputs, chips, badges pequenos |
| `radius-md` | `{{RADIUS_MD}}` | Botões, cards padrão, nav items |
| `radius-lg` | `{{RADIUS_LG}}` | Cards de destaque, modais, input cards |
| `radius-xl` | `{{RADIUS_XL}}` | Painéis laterais, drawers |
| `radius-full` | `9999px` | Pills, avatares, counter badges, toggles |

---

## 5. SOMBRAS / ELEVATION

| Token | Definição CSS | Uso |
|---|---|---|
| `shadow-xs` | `{{SHADOW_XS}}` | Dropdowns, tooltips |
| `shadow-sm` | `{{SHADOW_SM}}` | Cards em repouso |
| `shadow-md` | `{{SHADOW_MD}}` | Cards com hover, popovers |
| `shadow-lg` | `{{SHADOW_LG}}` | Modais, drawers |
| `shadow-xl` | `{{SHADOW_XL}}` | Painéis flutuantes, overlays |

---

## 6. COMPONENTES

> Esta seção descreve os padrões visuais e de estado de cada componente principal. Nenhum componente deve ser implementado com valores fora dos tokens definidos nas seções anteriores.

### 6.1 Topbar (Header Global)

**Dimensões:** altura `{{TOPBAR_HEIGHT}}` · largura `100%` · posição: sticky top
**Background:** `{{TOPBAR_BG}}`
**Borda inferior:** `{{TOPBAR_BORDER}}`

#### Elementos (esquerda → direita)

| Elemento | Tipo | Comportamento |
|---|---|---|
| Logo / Brand | Link | Ícone SVG da marca + nome da aplicação |
| Workspace Selector | Button dropdown | Avatar inicial + nome do workspace + chevron ▾ |
| Notificações | IconButton | Ícone bell com `aria-label` |
| Theme Toggle | IconButton | Toggle 3 estados (light / dark / system) |
| Help | Button | Ícone + label |
| Docs | Link/Button | Ícone + label → link externo |
| CTA (Upgrade/Action) | Primary Button | Estilo primary (cor da marca) |

---

### 6.2 Sidebar (Navigation)

**Dimensões:** largura `{{SIDEBAR_WIDTH}}` · altura `100vh`
**Background:** `{{SIDEBAR_BG}}`
**Borda direita:** `{{SIDEBAR_BORDER}}`
**Comportamento:** colapsável

#### Estados dos itens de navegação

| Estado | Background | Cor do texto | Cor do ícone |
|---|---|---|---|
| Default | transparente | `{{ALPHA_56}}` | `{{ALPHA_40}}` |
| Hover | `{{ALPHA_4}}` | `{{BRAND_TOKEN_BLACK}}` | `{{BRAND_TOKEN_BLACK}}` |
| Active | `{{BRAND_TOKEN_12}}` | `{{BRAND_TOKEN_100}}` | `{{BRAND_TOKEN_100}}` |
| Pressed | `{{ALPHA_7}}` | `{{BRAND_TOKEN_BLACK}}` | `{{BRAND_TOKEN_BLACK}}` |

**Dimensões do item:** altura `{{NAV_ITEM_HEIGHT}}` · largura `100%` · border-radius `{{RADIUS_MD}}`
**Padding:** ícone à esquerda fixo `{{NAV_ICON_WIDTH}}` · texto com padding horizontal `{{NAV_TEXT_PADDING}}`
**Transição:** `transition-all` com micro-animação de escala no press (`scale 0.98`)

#### Section Labels (agrupamentos da nav)

| Propriedade | Valor |
|---|---|
| Font size | `11px` |
| Font weight | `500` |
| Letter spacing | `0.08em` |
| Text transform | `uppercase` |
| Cor | `{{ALPHA_40}}` |
| Padding | `16px 10px 4px 10px` |

#### Badge "NEW" (indicador de feature nova)

| Propriedade | Valor |
|---|---|
| Background | `{{BRAND_TOKEN_12}}` |
| Cor do texto | `{{BRAND_TOKEN_100}}` |
| Border radius | `{{RADIUS_SM}}` |
| Padding | `1px 6px` |
| Font size | `11px` |
| Font weight | `500` |

#### Counter Badge (notificações com número)

| Propriedade | Valor |
|---|---|
| Background | `{{BRAND_TOKEN_100}}` |
| Cor do texto | `#ffffff` |
| Border radius | `9999px` (pill) |
| Min-width | `20px` |
| Altura | `20px` |
| Font size | `11px` |
| Font weight | `600` |

---

### 6.3 Segment Control / Tabs

**Container:**
- Background: `{{ALPHA_4}}`
- Border-radius: `{{RADIUS_MD}}`
- Padding: `2px`

**Tab — Default:**
- Cor do texto: `{{ALPHA_40}}`
- Font size: `14px` / font weight: `450`
- Background: transparente
- Border-radius: `{{RADIUS_SM}}`

**Tab — Active/Selected:**
- Background: `{{SURFACE}}`
- Cor do texto: `{{BRAND_TOKEN_BLACK}}`
- Font weight: `500`
- Box-shadow: `0 1px 3px {{ALPHA_10}}`

Cada tab possui: ícone SVG `14px` à esquerda + texto do label.

---

### 6.4 Input Card (Formulário Principal)

**Background:** `{{SURFACE}}`
**Border-radius:** `{{RADIUS_LG}}`
**Borda:** `1px solid {{BORDER_MUTED}}`
**Box-shadow:** `{{SHADOW_SM}}`
**Padding:** `16px`
**Max-width:** `{{INPUT_CARD_MAX_WIDTH}}`

**Campo de URL interno:**
- Prefixo fixo: texto `"https://"` com cor `{{ALPHA_40}}`
- Input: transparente, sem borda, font-size `15px`, peso `400`
- Cor do texto: `{{BRAND_TOKEN_BLACK}}`

---

### 6.5 Botões — Sistema Completo

#### Primary Button (CTA)

| Estado | Background | Texto | Border |
|---|---|---|---|
| Default | `{{BRAND_TOKEN_100}}` | `#ffffff` | nenhuma |
| Hover | `{{BRAND_TOKEN_90}}` | `#ffffff` | nenhuma |
| Pressed | `{{BRAND_TOKEN_100}}` + `scale(0.99)` | `#ffffff` | nenhuma |
| Focus | `{{BRAND_TOKEN_100}}` | `#ffffff` | outline `2px solid {{BRAND_TOKEN_40}}` offset `2px` |
| Disabled | `{{BRAND_TOKEN_100}}` opacity `0.5` | `#ffffff` opacity `0.5` | nenhuma |

**Dimensões:** padding `6px 12px` · border-radius `{{RADIUS_MD}}` · font-size `14px` · font-weight `450`

#### Ghost Button (Secondary)

| Estado | Background | Texto | Borda |
|---|---|---|---|
| Default | transparente | `{{BRAND_TOKEN_BLACK}}` | `1px solid {{ALPHA_4}}` |
| Hover | `{{ALPHA_4}}` | `{{BRAND_TOKEN_BLACK}}` | `1px solid {{ALPHA_4}}` |
| Pressed | `{{ALPHA_7}}` + `scale(0.99)` | `{{BRAND_TOKEN_BLACK}}` | `1px solid {{ALPHA_4}}` |

**Dimensões:** padding `6px 10px` · border-radius `{{RADIUS_MD}}` · font-size `14px` · font-weight `450`

#### Icon Button

| Estado | Background | Cor do ícone |
|---|---|---|
| Default | transparente | `{{BRAND_TOKEN_BLACK}}` |
| Hover | `{{ALPHA_4}}` | `{{BRAND_TOKEN_BLACK}}` |
| Pressed | `{{ALPHA_7}}` | `{{BRAND_TOKEN_BLACK}}` |

**Dimensões:** `32px × 32px` · border-radius `{{RADIUS_MD}}` · ícone centralizado

---

### 6.6 Status Badge

| Status | Ícone | Cor | Texto |
|---|---|---|---|
| Success | check circle | `{{ACCENT_GREEN}}` | "{{STATUS_SUCCESS_LABEL}}" |
| Error | x circle | `{{ACCENT_RED}}` | "{{STATUS_ERROR_LABEL}}" |
| Running | spinner | `{{BRAND_TOKEN_100}}` | "{{STATUS_RUNNING_LABEL}}" |
| Pending | circle vazio | `{{ALPHA_40}}` | "{{STATUS_PENDING_LABEL}}" |

---

### 6.7 Format Tag / Chip

| Propriedade | Valor |
|---|---|
| Background | `{{ALPHA_4}}` |
| Border-radius | `{{RADIUS_SM}}` |
| Padding | `3px 8px` |
| Font size | `13px` |
| Font weight | `450` |
| Cor do texto | `{{BRAND_TOKEN_BLACK}}` |
| Gap ícone/texto | `4px` |

---

### 6.8 Toast / Notificação

| Propriedade | Valor |
|---|---|
| Background | `{{BRAND_TOKEN_BLACK}}` |
| Cor do texto | `#ffffff` |
| Border-radius | `{{RADIUS_MD}}` |
| Padding | `12px 16px` |
| Font size | `14px` |
| Box-shadow | `{{SHADOW_LG}}` |
| Posição | bottom-right, z-index elevado |

---

## 7. ICONOGRAFIA

**Biblioteca:** `{{ICON_LIBRARY}}` (ex.: Lucide Icons, Heroicons, Phosphor Icons)
**Licença:** `{{ICON_LICENSE}}`

| Contexto | Tamanho | Stroke-width | Uso |
|---|---|---|---|
| Navegação (sidebar/topbar) | `15px–16px` | `2px` | Ícones de itens de menu e ações do header |
| Botões | `14px` | `2px` | Ícones dentro de botões com label |
| Headers de seção | `20px` | `2px` | Ícones decorativos em títulos de seção |
| Micro ícones (badges, tags) | `12px` | `1.5px` | Ícones em chips e badges pequenos |

**Propriedades visuais padrão:**
- Stroke-linecap: `round`
- Stroke-linejoin: `round`
- Fill: `none` (exceto ícones filled explícitos)

#### Mapa de ícones por contexto

| Contexto | Ícone sugerido |
|---|---|
| Notificações | `bell` |
| Theme toggle | `sun` / `moon` |
| Ajuda | `help-circle` |
| Documentação | `file` |
| Upgrade / ação principal | `arrow-up-circle` |
| Link externo | `arrow-up-right` |
| Configurações | `settings` |
| Chaves de API | `key` |
| Logs de atividade | `list` |
| Uso / métricas | `bar-chart-2` |
| Colapsar sidebar | `chevrons-left` |
| Novidades | `megaphone` |
| Sucesso | `check-circle-2` |
| Erro | `x-circle` |
| Opções avançadas | `sliders-horizontal` |
| Formato de saída | `file-text` |
| Código / API | `code-2` |
| Busca | `search` |
| Agente / AI | `bot` |

---

## 8. ACESSIBILIDADE (W3C WCAG 2.1 AA)

### 8.1 Roles ARIA obrigatórios

| Elemento | Role ARIA | Notas |
|---|---|---|
| Header global | `role="banner"` | Único por página |
| Sidebar | `<aside>` + `role="navigation"` | Com `aria-label` descritivo |
| Conteúdo principal | `role="main"` | Único por página |
| Tabs (container) | `role="tablist"` | Com `aria-label` do grupo |
| Tab individual | `role="tab"` | Com `aria-selected` e `aria-controls` |
| Painel de tab | `role="tabpanel"` | Com `aria-labelledby` apontando para o tab |
| Ícones decorativos | `aria-hidden="true"` | Não anunciar ao leitor de tela |
| Botões de ícone | `aria-label` descritivo | Obrigatório quando não há texto visível |

### 8.2 Focus Management

- Todos os elementos interativos possuem `:focus-visible` visível:
  `outline: 2px solid {{BORDER_MUTED}}, offset: 2px`
- Ordem de tab lógica: Topbar → Sidebar → Content Area → Footer
- Modais e dropdowns exigem **focus trap** obrigatório (foco não sai do overlay)
- Fechar modal/dropdown com `Escape` retorna o foco ao elemento que o abriu

### 8.3 Contraste (WCAG AA mínimo 4.5:1 para texto normal)

| Foreground | Background | Ratio | Status |
|---|---|---|---|
| `{{COLOR_NEUTRAL_TEXT_PRIMARY_HEX}}` (texto) | `{{BACKGROUND_BASE_HEX}}` (fundo) | `{{CONTRAST_TEXT_BG}}` | {{CONTRAST_TEXT_BG_STATUS}} |
| `#ffffff` (btn text) | `{{COLOR_BRAND_PRIMARY_HEX}}` (primary) | `{{CONTRAST_BTN_PRIMARY}}` | {{CONTRAST_BTN_PRIMARY_STATUS}} |
| `{{ALPHA_40}}` (texto secundário) | `{{BACKGROUND_BASE_HEX}}` (fundo) | `{{CONTRAST_TEXT_SECONDARY_BG}}` | {{CONTRAST_TEXT_SECONDARY_BG_STATUS}} |

> **Nota:** Texto branco sobre cor primária da marca pode ter ratio abaixo de 4.5:1 — aplicável apenas a elementos de tamanho grande (WCAG AA Large: ratio mínimo 3:1 para texto ≥ 18px ou 14px bold).

### 8.4 Navegação por Teclado

| Tecla | Comportamento |
|---|---|
| `Tab` | Navega entre elementos interativos na ordem lógica |
| `Shift+Tab` | Navegação reversa |
| `Enter` / `Space` | Ativa botão ou link |
| `Arrow Keys` | Navega entre tabs de um `tablist` |
| `Escape` | Fecha dropdown / modal |
| `{{SHORTCUT_CUSTOM_1}}` | `{{SHORTCUT_CUSTOM_1_DESC}}` |

---

## 9. ESTADOS E FEEDBACK VISUAL

### 9.1 Loading State (Skeleton)

- Background: gradiente shimmer de `{{ALPHA_4}}` → `{{ALPHA_8}}` → `{{ALPHA_4}}`
- Background-size: `200% 100%`
- Animação: `shimmer 1.5s infinite linear`
- Border-radius: `4px` para blocos de texto, `{{RADIUS_MD}}` para cards

### 9.2 Empty State

| Elemento | Especificação |
|---|---|
| Ícone ilustrativo | `48px`, cor `{{ALPHA_40}}` |
| Título | `text-label-large`, cor `{{BRAND_TOKEN_BLACK}}` |
| Subtítulo | `14px`, cor `{{ALPHA_40}}` |

### 9.3 Status Visual de Operação

| Estado | Ícone | Cor | Comportamento |
|---|---|---|---|
| Success | check-circle | `{{ACCENT_GREEN}}` | Estático |
| Error | x-circle | `{{ACCENT_RED}}` | Estático |
| Running | spinner | `{{BRAND_TOKEN_100}}` | Animação de rotação |
| Pending | circle | `{{ALPHA_40}}` | Estático |

---

## 10. RESPONSIVIDADE

### 10.1 Breakpoints

| Breakpoint | Largura | Comportamento |
|---|---|---|
| `sm` | < 640px | Sidebar oculta, menu hamburger no topbar |
| `md` | 640–1024px | Sidebar colapsável (ícones apenas) |
| `lg` | 1024–1280px | Layout completo, tabs e controles visíveis |
| `xl` | > 1280px | Layout completo com container max-width `{{CONTAINER_WIDTH}}` |

### 10.2 Comportamento da Sidebar por Breakpoint

| Breakpoint | Estado padrão | Opção do usuário |
|---|---|---|
| `< sm` | Oculta | Abre via menu hamburger (drawer) |
| `md` | Colapsada (ícones) | Pode expandir |
| `≥ lg` | Expandida | Pode colapsar |

---

## 11. MAPEAMENTO CSS CUSTOM PROPERTIES

```css
:root {
  /* Tipografia */
  --ds-font-display: "{{FONT_DISPLAY}}", sans-serif;
  --ds-font-body: "{{FONT_BODY}}", ui-sans-serif, system-ui, sans-serif;

  /* Cores — Brand */
  --ds-color-brand-primary: {{COLOR_BRAND_PRIMARY_HEX}};
  --ds-color-brand-secondary: {{COLOR_BRAND_SECONDARY_HEX}};
  --ds-color-brand-accent: {{COLOR_BRAND_ACCENT_HEX}};

  /* Cores — Brand Alpha */
  --ds-brand-100: {{BRAND_HEX_100}};
  --ds-brand-90: {{BRAND_HEX_90}};
  --ds-brand-40: {{BRAND_HEX_40}};
  --ds-brand-20: {{BRAND_HEX_20}};
  --ds-brand-12: {{BRAND_HEX_12}};
  --ds-brand-8: {{BRAND_HEX_8}};
  --ds-brand-4: {{BRAND_HEX_4}};

  /* Cores — Alpha Overlay */
  --ds-alpha-2: {{ALPHA_2_RGBA}};
  --ds-alpha-4: {{ALPHA_4_RGBA}};
  --ds-alpha-7: {{ALPHA_7_RGBA}};
  --ds-alpha-10: {{ALPHA_10_RGBA}};
  --ds-alpha-16: {{ALPHA_16_RGBA}};
  --ds-alpha-40: {{ALPHA_40_RGBA}};
  --ds-alpha-56: {{ALPHA_56_RGBA}};

  /* Cores — Superfície e Fundo */
  --ds-surface: {{SURFACE_HEX}};
  --ds-surface-raised: {{SURFACE_RAISED_HEX}};
  --ds-background-base: {{BACKGROUND_BASE_HEX}};
  --ds-background-lighter: {{BACKGROUND_LIGHTER_HEX}};
  --ds-border-faint: {{BORDER_FAINT_HEX}};
  --ds-border-muted: {{BORDER_MUTED_HEX}};
  --ds-border-loud: {{BORDER_LOUD_HEX}};

  /* Cores — Neutras */
  --ds-color-neutral-white: #FFFFFF;
  --ds-color-neutral-black: {{COLOR_NEUTRAL_BLACK_HEX}};
  --ds-color-neutral-text-primary: {{COLOR_NEUTRAL_TEXT_PRIMARY_HEX}};
  --ds-color-neutral-text-secondary: {{COLOR_NEUTRAL_TEXT_SECONDARY_HEX}};
  --ds-color-neutral-border: {{COLOR_NEUTRAL_BORDER_HEX}};
  --ds-color-neutral-bg-soft: {{COLOR_NEUTRAL_BG_SOFT_HEX}};
  --ds-color-neutral-card: {{COLOR_NEUTRAL_CARD_HEX}};

  /* Cores — Accent */
  --ds-accent-purple: {{ACCENT_PURPLE_HEX}};
  --ds-accent-blue: {{ACCENT_BLUE_HEX}};
  --ds-accent-red: {{ACCENT_RED_HEX}};
  --ds-accent-green: {{ACCENT_GREEN_HEX}};
  --ds-accent-yellow: {{ACCENT_YELLOW_HEX}};

  /* Cores — Status */
  --ds-color-status-success: {{COLOR_STATUS_SUCCESS_HEX}};
  --ds-color-status-error: {{COLOR_STATUS_ERROR_HEX}};
  --ds-color-status-warning: {{COLOR_STATUS_WARNING_HEX}};
  --ds-color-status-info: {{COLOR_STATUS_INFO_HEX}};

  /* Border Radius */
  --ds-radius-xs: 4px;
  --ds-radius-sm: {{RADIUS_SM}};
  --ds-radius-md: {{RADIUS_MD}};
  --ds-radius-lg: {{RADIUS_LG}};
  --ds-radius-xl: {{RADIUS_XL}};
  --ds-radius-full: 9999px;

  /* Sombras */
  --ds-shadow-xs: {{SHADOW_XS}};
  --ds-shadow-sm: {{SHADOW_SM}};
  --ds-shadow-md: {{SHADOW_MD}};
  --ds-shadow-lg: {{SHADOW_LG}};
  --ds-shadow-xl: {{SHADOW_XL}};

  /* Layout */
  --ds-topbar-height: {{TOPBAR_HEIGHT}};
  --ds-sidebar-width: {{SIDEBAR_WIDTH}};
  --ds-container-width: {{CONTAINER_WIDTH}};
  --ds-container-width-padding: {{CONTAINER_WIDTH_PADDING}};
}
```

---

## 12. REGRAS PRÁTICAS DE IMPLEMENTAÇÃO

- Nunca usar outra família tipográfica para UI de produto sem atualização explícita deste arquivo.
- Nunca usar cores arbitrárias fora dos tokens acima. Em caso de necessidade de nova cor, adicionar o token aqui primeiro.
- Em componentes de biblioteca de UI, sobrescrever variantes para refletir este design system.
- Textos de apoio e secundários devem preferir `neutral-text-secondary`.
- Bordas, grids e divisores devem preferir `neutral-border` ou `border-faint`.
- Cards claros devem preferir `neutral-card`; fundos editoriais suaves podem usar `neutral-bg-soft` ou `background-base`.
- Botões e CTAs devem partir de `brand-primary`.
- Estados de erro, sucesso, aviso e informação devem usar os tokens de status desta documentação.
- Espaçamentos devem seguir a escala de tokens `space-*` — evitar valores soltos.
- Border radius deve seguir os tokens `radius-*` — evitar px avulsos.
- Sombras devem seguir os tokens `shadow-*` — evitar `box-shadow` manual.
- **Overlays e hover states** devem usar o sistema de alpha definido em `1.4` — nunca cores sólidas sobre fundos.
- Ícones decorativos recebem `aria-hidden="true"`; botões apenas com ícone recebem `aria-label`.
- Todos os elementos interativos devem ter estado `:focus-visible` visível com outline de `2px`.   

---

## 13. DECISÃO EM CASO DE DÚVIDA

1. **Figma + este arquivo vencem** — sempre.
2. Depois, aplicar os componentes e padrões da biblioteca de UI do projeto.
3. Se ainda faltar algum token, **atualizar este arquivo antes de inventar um novo**.
4. Registrar na seção "Notas de interpretação" qualquer decisão não óbvia tomada.
5. Em dúvida sobre acessibilidade, seguir W3C WCAG 2.1 AA como mínimo e WAI-ARIA 1.2 para marcação semântica.
