#!/usr/bin/env zsh

if [ -z "$1" ]; then
    echo "Usage: $0 fichier.tex"
    exit 1
fi

SRC_FILE="$1"
BASE_NAME=$(basename "$SRC_FILE" .tex)

SRC_ROOT="/home/jrochette/Bureau/DossierGit/cours-latex"

BUILD_DIR=~/.latex_build
mkdir -p "$BUILD_DIR"

OUTPUT_DIR=/run/media/jrochette/Julien
mkdir -p "$OUTPUT_DIR"

latexmk -pdf -pdflatex="lualatex -interaction=nonstopmode" \
        -outdir="$BUILD_DIR" "$SRC_FILE"

PDF_FILE="$BUILD_DIR/$BASE_NAME.pdf"
if [ ! -f "$PDF_FILE" ]; then
    echo "Erreur : le PDF n'a pas été généré."
    exit 1
fi

# Calcul du chemin relatif pour reproduire l'architecture
REL_PATH=$(realpath --relative-to="$SRC_ROOT" "$SRC_FILE")
REL_DIR=$(dirname "$REL_PATH")
DEST_DIR="$OUTPUT_DIR/$REL_DIR"
mkdir -p "$DEST_DIR"

mv "$PDF_FILE" "$DEST_DIR/$BASE_NAME.pdf"

latexmk -c -outdir="$BUILD_DIR" "$SRC_FILE"

echo "Compilation terminée. PDF déplacé dans $DEST_DIR"

