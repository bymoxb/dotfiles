#!/bin/bash

set -euo pipefail

############################################################
# compress.sh
#
# Uso:
#   ./compress.sh <origen>
############################################################

# =========================
# Validación de entrada
# =========================
DIR_INPUT="${1:-}"

if [[ -z "$DIR_INPUT" ]]; then
    echo "[ERROR] Debes proporcionar una ruta."
    exit 1
fi

if [[ ! -d "$DIR_INPUT" ]]; then
    echo "[ERROR] La ruta no existe o no es un directorio."
    exit 1
fi

# =========================
# Tiempo inicio
# =========================
START_TIME=$(date +%s)

echo "[INFO] Ruta recibida: $DIR_INPUT"

# =========================
# Obtener directorios
# =========================
mapfile -t DIRS < <(find "$DIR_INPUT" -mindepth 1 -maxdepth 1 -type d | sort)

TOTAL=${#DIRS[@]}

echo "[INFO] Directorios encontrados: $TOTAL"
echo ""

if [[ "$TOTAL" -eq 0 ]]; then
    echo "[INFO] No hay directorios para comprimir."
    exit 0
fi

# =========================
# Procesar directorios
# =========================
COUNT=0

for DIR in "${DIRS[@]}"; do
    COUNT=$((COUNT + 1))

    NAME=$(basename "$DIR")
    SIZE=$(du -sh "$DIR" | awk '{print $1}')

    echo "[$(printf "%02d" "$COUNT")/$(printf "%02d" "$TOTAL")] Comprimiendo: $NAME"
    echo "        Tamaño: $SIZE"

    OUTPUT_FILE="$DIR_INPUT/${NAME}.tar.gz"

    echo "        Generando: ${NAME}.tar.gz"

    tar --checkpoint=500 \
        --checkpoint-action=dot \
        -czf "$OUTPUT_FILE" \
        -C "$DIR_INPUT" "$NAME"

    echo ""
done

# =========================
# Tiempo final
# =========================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "[OK] Compresión finalizada"
echo "[TIEMPO] Inicio: $(date -d @$START_TIME '+%H:%M:%S')"
echo "[TIEMPO] Fin:   $(date -d @$END_TIME '+%H:%M:%S')"
echo "[TIEMPO] Duración: ${DURATION}s"
