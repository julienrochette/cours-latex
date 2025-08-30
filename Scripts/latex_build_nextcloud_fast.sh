#!/usr/bin/env zsh

if [ -z "$1" ]; then
    echo "Usage: $0 fichier.tex"
    exit 1
fi

SRC_FILE="$1"
BASE_NAME=$(basename "$SRC_FILE" .tex)

BUILD_DIR=~/.latex_build
mkdir -p "$BUILD_DIR"

NEXTCLOUD_DIR=~/Bureau/Nextcloud
mkdir -p "$NEXTCLOUD_DIR"

# Compilation (une seule passe rapide avec lualatex)
lualatex -interaction=nonstopmode -output-directory="$BUILD_DIR" "$SRC_FILE"

PDF_FILE="$BUILD_DIR/$BASE_NAME.pdf"
if [ ! -f "$PDF_FILE" ]; then
    echo "Erreur : le PDF n'a pas été généré."
    exit 1
fi

# Déplacer le PDF vers Nextcloud
cp "$PDF_FILE" "$NEXTCLOUD_DIR/"

# Nettoyer les fichiers auxiliaires (sans relancer latexmk)
rm -f "$BUILD_DIR/$BASE_NAME".{aux,log,toc,out,fls,fdb_latexmk}

echo "Compilation terminée. PDF copié dans $NEXTCLOUD_DIR"

