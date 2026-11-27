#!/bin/bash
# [resumo]
# make.sh: concatena os arquivos de FILES em ./builds/build.lua (faz backup datado
# do build anterior).
# ------------------------------------------------------------

# Arquivos predefinidos
FILES=("main.lua") # Substitua pelos nomes dos arquivos reais
OUTPUT="./builds/build.lua"

# Verifica se o arquivo de saída já existe
if [ -f "$OUTPUT" ]; then
    # Cria um backup com a data e hora atuais
    BACKUP="backup_$(date +'%Y%m%d_%H%M%S').txt"
    cp "$OUTPUT" "$BACKUP"
    echo "Backup criado: $BACKUP"
fi

# Cria o arquivo de saída combinando os arquivos
> "$OUTPUT" # Limpa ou cria o arquivo de saída

for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        cat "$FILE" >> "$OUTPUT"
        echo -e "\n" >> "$OUTPUT" # Adiciona uma nova linha entre os arquivos
    else
        echo "Arquivo não encontrado: $FILE"
    fi
done

echo "Arquivos combinados em $OUTPUT."