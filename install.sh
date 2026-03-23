#!/usr/bin/env bash
set -e

COMMANDS_DIR="$HOME/.claude/commands"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "lifters-skills — instalando skills..."
echo ""

mkdir -p "$COMMANDS_DIR"

for file in "$REPO_DIR/commands"/*.md; do
  name=$(basename "$file")
  ln -sf "$file" "$COMMANDS_DIR/$name"
  echo "  ✓ /${name%.md}"
done

echo ""
echo "Instalação completa. Comandos disponíveis em qualquer projeto:"
echo "  /discovery     — inicia o discovery de uma nova feature"
echo "  /new-feature   — gera briefing, specs e wps a partir do discovery"
echo ""
echo "Para atualizar: git -C ~/.lifters-skills pull  (se instalado via clone)"
echo "               npx skills update twinfo-io/lifters-skills  (se instalado via registry)"
