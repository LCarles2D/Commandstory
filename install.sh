#!/bin/env bash
# ==============================================================================
# Script: install.sh (Commandstory Installer)
# Description: Setup script to install Commandstory on your system.
# Author: LCarles2D
# License: MIT
# Version: 1.0.0
# Repository: https://github.com/LCarles2D/Commandstory
# ==============================================================================
 
set -euo pipefail

# 1. Validar privilegios
if [ "$EUID" -ne 0 ]; then 
  echo -e "\e[31m[ERROR] Por favor, ejecuta con sudo: sudo bash install.sh\e[0m"
  exit 1
fi

# 2. Identificar al usuario real que llamó a sudo
# Si no hay SUDO_USER (ej. corres como root puro), usamos el usuario actual
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
MANDIR="/usr/local/share/man/man1"

INSTALL_PATH="/usr/local/bin/commandstory"

echo "Instalando Commandstory para el usuario: $REAL_USER..."

setup_shell_history() {
    echo "Configurando persistencia de historial en $REAL_HOME..."

    # --- CONFIGURACIÓN PARA BASH ---
    local BASHRC="$REAL_HOME/.bashrc"
    if [ -f "$BASHRC" ]; then
        local BASH_CONF=$(cat <<EOF

# Commandstory: Configuración de historial
export PROMPT_COMMAND="history -a; \$PROMPT_COMMAND"
export HISTTIMEFORMAT="%F %T " 
EOF
)
        if ! grep -q "HISTTIMEFORMAT" "$BASHRC"; then
            echo "$BASH_CONF" >> "$BASHRC"
            chown "$REAL_USER":"$REAL_USER" "$BASHRC" # Asegurar que el dueño sigue siendo el usuario
            echo "[Bash] Configuración de timestamps añadida a $BASHRC"
        fi
    fi

    # --- CONFIGURACIÓN PARA ZSH ---
    local ZSHRC="$REAL_HOME/.zshrc"
    if [ -f "$ZSHRC" ]; then
        local ZSH_OPTS=("INC_APPEND_HISTORY" "SHARE_HISTORY")
        for opt in "${ZSH_OPTS[@]}"; do
            if ! grep -q "setopt $opt" "$ZSHRC"; then
                echo "setopt $opt" >> "$ZSHRC"
                echo "[Zsh] Opción $opt añadida a $ZSHRC"
            fi
        done
        chown "$REAL_USER":"$REAL_USER" "$ZSHRC"
    fi
}

# Ejecutar configuración de historial
setup_shell_history

# 3. Instalación del binario
echo "Copiando ejecutable a $INSTALL_PATH..."
cp commandstory "$INSTALL_PATH"

# Permisos correctos: root es dueño, pero todos pueden ejecutar
chmod 755 "$INSTALL_PATH"

if [ -f "commandstory.1" ]; then
    mkdir -p "$MANDIR" > /dev/null 2>&1
    cp commandstory.1 "$MANDIR/"
    chmod 644 "$MANDIR/commandstory.1"
    
    # Actualizar base de datos de manuales en silencio
    if command -v mandb > /dev/null; then
        mandb -q > /dev/null 2>&1
    elif command -v makewhatis > /dev/null; then
        makewhatis > /dev/null 2>&1
    fi
fi

echo "------------------------------------------------"
echo "¡Instalación completada con éxito!"
echo "IMPORTANTE: El usuario $REAL_USER debe reiniciar su terminal"
echo "o ejecutar: source ~/.bashrc (o .zshrc)"
echo "------------------------------------------------"
