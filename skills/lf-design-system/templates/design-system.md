# Design System — {{DESIGN_SYSTEM_NAME}}

> **Gerado em:** {{DATE}}
> **Fonte:** {{FIGMA_URL}}
> **Status:** Fonte de verdade oficial do projeto

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

Se houver conflito entre implementação local e este arquivo, **o Figma e este arquivo vencem**.

---

## Uso obrigatório

- Toda tela, página, componente e estado visual deve usar este design system.
- Não introduzir novas famílias tipográficas, escalas de texto ou paletas ad hoc sem atualizar este arquivo primeiro.
- Sempre preferir nomes semânticos de token em vez de valores soltos no código.
- Em componentes de biblioteca de UI (ex.: `shadcn/ui`, `Radix`, `MUI`), sobrescrever variantes e tokens para refletir este design system.
- Textos de apoio e secundários devem preferir tokens `neutral-text-*`.
- Bordas, grids e divisores devem preferir tokens `neutral-border-*`.
- Botões e CTAs devem partir do token `brand-primary`.
- Estados de erro, sucesso e informação devem usar os tokens de feedback desta documentação.

---

## Notas de interpretação

> Liste aqui todas as inferências e decisões tomadas durante a extração do Figma.
> Se não houver ambiguidades, escreva: "Nenhuma ambiguidade identificada — todos os valores foram lidos diretamente do Figma."

- **Inferência:** {{NOTE_1}}
- **Inferência:** {{NOTE_2}}

---

## Famílias tipográficas

| Papel | Família | Pesos permitidos | Uso |
|---|---|---|---|
| Display / Heading | `{{FONT_DISPLAY}}` | `{{FONT_DISPLAY_WEIGHTS}}` | Títulos, hero, headings e destaques editoriais |
| Body / UI | `{{FONT_BODY}}` | `{{FONT_BODY_WEIGHTS}}` | Texto corrido, labels, botões, captions, KPI e UI geral |

### Importação recomendada no projeto

```ts
// Next.js (next/font/google)
import { {{FONT_DISPLAY_IMPORT}}, {{FONT_BODY_IMPORT}} } from "next/font/google";
```

```css
/* CSS @import */
@import url('https://fonts.googleapis.com/css2?family={{FONT_DISPLAY_URL}}&family={{FONT_BODY_URL}}&display=swap');
```

Pesos recomendados:
- `{{FONT_DISPLAY}}`: {{FONT_DISPLAY_WEIGHTS}}
- `{{FONT_BODY}}`: {{FONT_BODY_WEIGHTS}}

---

## Escala tipográfica

### Display e headings

| Token | Família | Peso | Tamanho | Line height | Letter spacing |
|---|---|---:|---:|---:|---:|
| `display-2xl` | `{{FONT_DISPLAY}}` | `700` | `64px` | `72px` | `-2` |
| `display-xl` | `{{FONT_DISPLAY}}` | `700` | `48px` | `56px` | `-2` |
| `display-lg` | `{{FONT_DISPLAY}}` | `700` | `40px` | `48px` | `-1` |
| `heading-h1` | `{{FONT_DISPLAY}}` | `700` | `32px` | `40px` | `-1` |
| `heading-h2` | `{{FONT_DISPLAY}}` | `600` | `24px` | `32px` | `-0.5` |
| `heading-h3` | `{{FONT_DISPLAY}}` | `600` | `20px` | `28px` | `0` |
| `heading-h4` | `{{FONT_DISPLAY}}` | `600` | `16px` | `24px` | `0` |

### Body e UI

| Token | Família | Peso | Tamanho | Line height | Letter spacing |
|---|---|---:|---:|---:|---:|
| `body-lg` | `{{FONT_BODY}}` | `400` | `18px` | `28px` | `0` |
| `body-md` | `{{FONT_BODY}}` | `400` | `16px` | `24px` | `0` |
| `body-sm` | `{{FONT_BODY}}` | `400` | `14px` | `20px` | `0` |
| `body-xs` | `{{FONT_BODY}}` | `400` | `12px` | `16px` | `0` |
| `label-lg` | `{{FONT_BODY}}` | `500` | `16px` | `24px` | `0` |
| `label-md` | `{{FONT_BODY}}` | `500` | `14px` | `20px` | `0.25` |
| `label-sm` | `{{FONT_BODY}}` | `500` | `12px` | `16px` | `0.25` |
| `button-lg` | `{{FONT_BODY}}` | `500` | `16px` | `24px` | `0` |
| `button-md` | `{{FONT_BODY}}` | `500` | `14px` | `20px` | `0.25` |
| `button-sm` | `{{FONT_BODY}}` | `500` | `12px` | `16px` | `0.25` |
| `caption-md` | `{{FONT_BODY}}` | `400` | `12px` | `16px` | `0.25` |
| `caption-sm` | `{{FONT_BODY}}` | `400` | `11px` | `16px` | `0.25` |
| `kpi-xl` | `{{FONT_BODY}}` | `700` | `40px` | `48px` | `-1.5` |
| `kpi-lg` | `{{FONT_BODY}}` | `700` | `32px` | `40px` | `-1` |
| `kpi-md` | `{{FONT_BODY}}` | `600` | `24px` | `32px` | `-0.5` |

---

## Cores

### Brand e primárias

| Token | Papel | Hex | RGB | HSL |
|---|---|---|---|---|
| `brand-primary` | Cor primária principal da interface | `{{COLOR_BRAND_PRIMARY_HEX}}` | `{{COLOR_BRAND_PRIMARY_RGB}}` | `{{COLOR_BRAND_PRIMARY_HSL}}` |
| `brand-secondary` | Cor secundária / complementar | `{{COLOR_BRAND_SECONDARY_HEX}}` | `{{COLOR_BRAND_SECONDARY_RGB}}` | `{{COLOR_BRAND_SECONDARY_HSL}}` |
| `brand-accent` | Acento editorial / destaque de display | `{{COLOR_BRAND_ACCENT_HEX}}` | `{{COLOR_BRAND_ACCENT_RGB}}` | `{{COLOR_BRAND_ACCENT_HSL}}` |

### Neutras

| Token | Papel | Hex | RGB | HSL |
|---|---|---|---|---|
| `neutral-white` | Branco puro | `#FFFFFF` | `rgb(255, 255, 255)` | `hsl(0, 0%, 100%)` |
| `neutral-black` | Preto profundo / base escura | `{{COLOR_NEUTRAL_BLACK_HEX}}` | `{{COLOR_NEUTRAL_BLACK_RGB}}` | `{{COLOR_NEUTRAL_BLACK_HSL}}` |
| `neutral-text-primary` | Texto primário | `{{COLOR_NEUTRAL_TEXT_PRIMARY_HEX}}` | `{{COLOR_NEUTRAL_TEXT_PRIMARY_RGB}}` | `{{COLOR_NEUTRAL_TEXT_PRIMARY_HSL}}` |
| `neutral-text-secondary` | Texto secundário | `{{COLOR_NEUTRAL_TEXT_SECONDARY_HEX}}` | `{{COLOR_NEUTRAL_TEXT_SECONDARY_RGB}}` | `{{COLOR_NEUTRAL_TEXT_SECONDARY_HSL}}` |
| `neutral-border` | Bordas e divisores | `{{COLOR_NEUTRAL_BORDER_HEX}}` | `{{COLOR_NEUTRAL_BORDER_RGB}}` | `{{COLOR_NEUTRAL_BORDER_HSL}}` |
| `neutral-bg-soft` | Fundo suave | `{{COLOR_NEUTRAL_BG_SOFT_HEX}}` | `{{COLOR_NEUTRAL_BG_SOFT_RGB}}` | `{{COLOR_NEUTRAL_BG_SOFT_HSL}}` |
| `neutral-card` | Fundo de card neutro | `{{COLOR_NEUTRAL_CARD_HEX}}` | `{{COLOR_NEUTRAL_CARD_RGB}}` | `{{COLOR_NEUTRAL_CARD_HSL}}` |

### Feedback / Status

| Token | Papel | Hex | RGB | HSL |
|---|---|---|---|---|
| `status-success` | Sucesso / confirmação | `{{COLOR_STATUS_SUCCESS_HEX}}` | `{{COLOR_STATUS_SUCCESS_RGB}}` | `{{COLOR_STATUS_SUCCESS_HSL}}` |
| `status-error` | Erro / alerta crítico | `{{COLOR_STATUS_ERROR_HEX}}` | `{{COLOR_STATUS_ERROR_RGB}}` | `{{COLOR_STATUS_ERROR_HSL}}` |
| `status-warning` | Aviso / atenção | `{{COLOR_STATUS_WARNING_HEX}}` | `{{COLOR_STATUS_WARNING_RGB}}` | `{{COLOR_STATUS_WARNING_HSL}}` |
| `status-info` | Info / estado informativo | `{{COLOR_STATUS_INFO_HEX}}` | `{{COLOR_STATUS_INFO_RGB}}` | `{{COLOR_STATUS_INFO_HSL}}` |

---

## Espaçamento

> Escala de espaçamento usada em padding, margin, gap e posicionamento.

| Token | px | rem | Uso típico |
|---|---:|---:|---|
| `space-1` | `4px` | `0.25rem` | Espaçamento mínimo entre elementos inline |
| `space-2` | `8px` | `0.5rem` | Padding interno de badges e chips |
| `space-3` | `12px` | `0.75rem` | Gap entre ícone e label |
| `space-4` | `16px` | `1rem` | Padding padrão de cards e botões |
| `space-5` | `20px` | `1.25rem` | Espaçamento entre seções internas |
| `space-6` | `24px` | `1.5rem` | Padding lateral de containers compactos |
| `space-8` | `32px` | `2rem` | Espaçamento entre blocos de conteúdo |
| `space-10` | `40px` | `2.5rem` | Seções de página |
| `space-12` | `48px` | `3rem` | Seções hero e espaçamento maior |
| `space-16` | `64px` | `4rem` | Separação entre módulos de página |
| `space-20` | `80px` | `5rem` | Margens de layout full-width |
| `space-24` | `96px` | `6rem` | Seções de landing page |

---

## Border Radius

| Token | Valor | Uso |
|---|---|---|
| `radius-none` | `0px` | Sem arredondamento (tabelas, separadores) |
| `radius-sm` | `{{RADIUS_SM}}` | Inputs, chips, badges pequenos |
| `radius-md` | `{{RADIUS_MD}}` | Botões, cards padrão |
| `radius-lg` | `{{RADIUS_LG}}` | Modais, cards de destaque |
| `radius-xl` | `{{RADIUS_XL}}` | Painéis laterais, drawers |
| `radius-full` | `9999px` | Pills, avatares, toggles |

---

## Sombras / Elevation

| Token | Definição CSS | Uso |
|---|---|---|
| `shadow-xs` | `{{SHADOW_XS}}` | Dropdowns, tooltips |
| `shadow-sm` | `{{SHADOW_SM}}` | Cards em repouso |
| `shadow-md` | `{{SHADOW_MD}}` | Cards com hover, popovers |
| `shadow-lg` | `{{SHADOW_LG}}` | Modais, drawers |
| `shadow-xl` | `{{SHADOW_XL}}` | Painéis flutuantes, overlays |

---

## Mapeamento recomendado para CSS custom properties

```css
:root {
  /* Tipografia */
  --ds-font-display: "{{FONT_DISPLAY}}", sans-serif;
  --ds-font-body: "{{FONT_BODY}}", sans-serif;

  /* Cores — Brand */
  --ds-color-brand-primary: {{COLOR_BRAND_PRIMARY_HEX}};
  --ds-color-brand-secondary: {{COLOR_BRAND_SECONDARY_HEX}};
  --ds-color-brand-accent: {{COLOR_BRAND_ACCENT_HEX}};

  /* Cores — Neutras */
  --ds-color-neutral-white: #FFFFFF;
  --ds-color-neutral-black: {{COLOR_NEUTRAL_BLACK_HEX}};
  --ds-color-neutral-text-primary: {{COLOR_NEUTRAL_TEXT_PRIMARY_HEX}};
  --ds-color-neutral-text-secondary: {{COLOR_NEUTRAL_TEXT_SECONDARY_HEX}};
  --ds-color-neutral-border: {{COLOR_NEUTRAL_BORDER_HEX}};
  --ds-color-neutral-bg-soft: {{COLOR_NEUTRAL_BG_SOFT_HEX}};
  --ds-color-neutral-card: {{COLOR_NEUTRAL_CARD_HEX}};

  /* Cores — Status */
  --ds-color-status-success: {{COLOR_STATUS_SUCCESS_HEX}};
  --ds-color-status-error: {{COLOR_STATUS_ERROR_HEX}};
  --ds-color-status-warning: {{COLOR_STATUS_WARNING_HEX}};
  --ds-color-status-info: {{COLOR_STATUS_INFO_HEX}};

  /* Border Radius */
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
}
```

---

## Regras práticas de implementação

- Nunca usar outra família tipográfica para UI de produto sem atualização explícita deste arquivo.
- Nunca usar cores arbitrárias fora dos tokens acima. Em caso de necessidade de nova cor, adicionar o token aqui primeiro.
- Em componentes de biblioteca de UI, sobrescrever variantes para refletir este design system.
- Textos de apoio e secundários devem preferir `neutral-text-secondary`.
- Bordas, grids e divisores devem preferir `neutral-border`.
- Cards claros devem preferir `neutral-card`; fundos editoriais suaves podem usar `neutral-bg-soft`.
- Botões e CTAs devem partir de `brand-primary`.
- Estados de erro, sucesso, aviso e informação devem usar os tokens de status desta documentação.
- Espaçamentos devem seguir a escala de tokens `space-*` — evitar valores soltos.
- Border radius deve seguir os tokens `radius-*` — evitar px avulsos.
- Sombras devem seguir os tokens `shadow-*` — evitar `box-shadow` manual.

---

## Decisão em caso de dúvida

1. **Figma + este arquivo vencem** — sempre.
2. Depois, aplicar os componentes e padrões da biblioteca de UI do projeto.
3. Se ainda faltar algum token, **atualizar este arquivo antes de inventar um novo**.
4. Registrar na seção "Notas de interpretação" qualquer decisão não óbvia tomada.
