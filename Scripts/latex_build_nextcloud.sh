#!/usr/bin/env zsh

if [ -z "$1" ]; then
    echo "Usage: $0 fichier.tex"
    exit 1
fi

SRC_FILE="$1"
BASE_NAME=$(basename "$SRC_FILE" .tex)

# Dossier central pour tous les fichiers auxiliaires
BUILD_DIR=~/.latex_build
mkdir -p "$BUILD_DIR"

# Dossier Nextcloud pour les PDFs
NEXTCLOUD_DIR=~/Bureau/Nextcloud
mkdir -p "$NEXTCLOUD_DIR"

# Compiler avec latexmk et LuaLaTeX
latexmk -pdf -pdflatex="lualatex -interaction=nonstopmode" \
        -outdir="$BUILD_DIR" "$SRC_FILE"

PDF_FILE="$BUILD_DIR/$BASE_NAME.pdf"
if [ ! -f "$PDF_FILE" ]; then
    echo "Erreur : le PDF n'a pas été généré."
    exit 1
fi

# Déplacer le PDF vers Nextcloud
mv "$PDF_FILE" "$NEXTCLOUD_DIR/"

# Nettoyer les fichiers auxiliaires dans le dossier central
latexmk -c -outdir="$BUILD_DIR" "$SRC_FILE"

echo "Compilation terminée. PDF déplacé dans $NEXTCLOUD_DIR"
