#!/bin/bash

# Variáveis
servico="nginx"
# Variável para armazenar o dia, data, hora e segundo
tempo=$(date '+%Y-%m-%d %H:%M:%S')

status_online=~/monitoracao_online.log
status_offline=~/monitoracao_offline.log


# Verifica o status do nginx
if systemctl is-active --quiet $servico; then
    echo "$tempo - $servico - ONLINE - Serviço está online." >> $status_online
else
    echo "$tempo - $servico - OFFLINE - Serviço está parado." >> $status_offline
fi
