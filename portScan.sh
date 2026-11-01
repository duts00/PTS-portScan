#!/bin/bash
#
# portscan.sh - Descobre quais hosts de uma rede /24 possuem uma porta aberta.
#
# Objetivo: o usuario informa a rede (3 primeiros octetos) e a porta; o script
# varre os hosts de .1 a .254 e lista os que respondem com a porta aberta.
#
# Uso:     sudo ./portscan.sh REDE PORTA
# Exemplo: sudo ./portscan.sh 172.16.1 80
#
# Estudo de seguranca - usar apenas em redes proprias ou autorizadas.
# Requer root (hping3 envia pacotes SYN crus).

set -u

# --- Verificacao de argumentos ---
if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
    echo "_____ DUTS00 SECURITY - PORTSCAN NETWORK _____"
    echo "Modo de uso: sudo $0 REDE PORTA"
    echo "Exemplo:     sudo $0 172.16.1 80"
    exit 1
fi

# --- Verifica se e root (hping3 precisa) ---
if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Este script precisa de root. Rode com: sudo $0 $*"
    exit 1
fi

# --- Verifica se o hping3 esta instalado ---
if ! command -v hping3 >/dev/null 2>&1; then
    echo "[!] hping3 nao encontrado. Instale com: sudo apt install hping3"
    exit 1
fi

REDE="$1"
PORTA="$2"

echo "[*] Varrendo a rede $REDE.0/24 na porta $PORTA ..."
echo "---------------------------------------------"

encontrados=0

for ip in {1..254}; do
    alvo="$REDE.$ip"
    # -S: flag SYN | -p: porta | -c 1: um pacote | -W 1: timeout curto
    # Uma resposta com "flags=SA" indica porta ABERTA (SYN-ACK).
    if hping3 -S -p "$PORTA" -c 1 "$alvo" 2>/dev/null | grep -q "flags=SA"; then
        echo "[+] $alvo  ->  porta $PORTA ABERTA"
        encontrados=$((encontrados + 1))
    fi
done

echo "---------------------------------------------"
echo "[ok] Concluido. $encontrados host(s) com a porta $PORTA aberta."
