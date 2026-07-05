#!/usr/bin/env bash

set -euo pipefail

############################################################
# mirror.sh
#
# Replica la estructura de un directorio creando archivos
# vacíos (0 bytes).
#
# Uso:
#   ./mirror.sh <origen> <destino>
############################################################

if [[ $# -ne 2 ]]; then
    echo "Uso: $0 <origen> <destino>"
    exit 1
fi

ORIGEN="${1%/}"
DESTINO="${2%/}"

if [[ ! -d "$ORIGEN" ]]; then
    echo "Error: El directorio origen no existe."
    exit 1
fi

if [[ -d "$DESTINO" ]]; then
    echo "Destino existente: $DESTINO"
    echo "Se agregarán los directorios y archivos faltantes."
else
    mkdir -p "$DESTINO"
    echo "Destino creado: $DESTINO"
fi

############################################################

format_time() {
    local s=$1
    printf "%02d:%02d:%02d" \
        $((s/3600)) \
        $(((s%3600)/60)) \
        $((s%60))
}

############################################################

START_EPOCH=$(date +%s)
START_DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo
echo "Origen  : $ORIGEN"
echo "Destino : $DESTINO"
echo
echo "Inicio  : $START_DATE"

echo

# Obtener directorios de primer nivel (ignorando ocultos)
mapfile -d '' DIRECTORIOS < <(
    find "$ORIGEN" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        ! -name ".*" \
        -print0
)

TOTAL=${#DIRECTORIOS[@]}
INDEX=1

for DIR in "${DIRECTORIOS[@]}"; do

    NOMBRE=$(basename "$DIR")
    TAMANO=$(du -sh "$DIR" | cut -f1)

    echo "--------------------------------------------------"
    echo "[$INDEX/$TOTAL] Procesando: $NOMBRE"
    echo "Tamaño : $TAMANO"
    echo

    DIR_START=$(date +%s)

    DEST_SUB="$DESTINO/$NOMBRE"

    mkdir -p "$DEST_SUB"

    chmod --reference="$DIR" "$DEST_SUB" 2>/dev/null || true
    touch -r "$DIR" "$DEST_SUB" 2>/dev/null || true

    ########################################################
    # Directorios
    ########################################################

    while IFS= read -r -d '' SUBDIR; do

        REL="${SUBDIR#$DIR}"
        NUEVO="$DEST_SUB$REL"

        mkdir -p "$NUEVO"

        chmod --reference="$SUBDIR" "$NUEVO" 2>/dev/null || true
        touch -r "$SUBDIR" "$NUEVO" 2>/dev/null || true

    done < <(
        find "$DIR" \
            -mindepth 1 \
            -type d \
            ! -path '*/.*' \
            -print0
    )

    ########################################################
    # Archivos
    ########################################################

    while IFS= read -r -d '' FILE; do

        REL="${FILE#$DIR}"
        NUEVO="$DEST_SUB$REL"

        touch "$NUEVO"

        chmod --reference="$FILE" "$NUEVO" 2>/dev/null || true
        touch -r "$FILE" "$NUEVO" 2>/dev/null || true

    done < <(
        find "$DIR" \
            -type f \
            ! -path '*/.*' \
            -print0
    )

    DIR_END=$(date +%s)

    echo "Finalizado."
    echo "Tiempo : $(format_time $((DIR_END-DIR_START)))"
    echo

    ((INDEX++))

done

############################################################
# Archivos/directorios que estén directamente en la raíz
############################################################

while IFS= read -r -d '' FILE; do

    REL="${FILE#$ORIGEN}"
    NUEVO="$DESTINO$REL"

    touch "$NUEVO"

    chmod --reference="$FILE" "$NUEVO" 2>/dev/null || true
    touch -r "$FILE" "$NUEVO" 2>/dev/null || true

done < <(
    find "$ORIGEN" \
        -maxdepth 1 \
        -type f \
        ! -name ".*" \
        -print0
)

############################################################

END_EPOCH=$(date +%s)
END_DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "=================================================="
echo "Proceso finalizado"
echo
echo "Inicio                : $START_DATE"
echo "Fin                   : $END_DATE"
echo "Tiempo total          : $(format_time $((END_EPOCH-START_EPOCH)))"
echo "Directorios procesados: $TOTAL"
echo "Destino               : $DESTINO"
echo "=================================================="

