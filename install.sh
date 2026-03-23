#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "lifters-skills — instalando skills..."
echo ""

for skill_dir in "$REPO_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")

  mkdir -p "$SKILLS_DIR/$skill_name"

  cp -r "$skill_dir"* "$SKILLS_DIR/$skill_name/"

  echo "  ✓ /$skill_name"
done

echo ""
echo "Instalação completa. Skills disponíveis em qualquer projeto:"
echo "  /discovery     — inicia o discovery de uma nova feature"
echo "  /new-feature   — gera briefing, specs e wps a partir do discovery"
echo ""
echo "Para atualizar: git -C ~/.lifters-skills pull && bash ~/.lifters-skills/install.sh"
echo "               npx skills update twinfo-io/lifters-skills  (se instalado via registry)"
