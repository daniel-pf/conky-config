#!/bin/bash
# Uso: gpu-info.sh gpu|temp|vram|vram-bar
# Imprime o valor formatado, ou N/A (0 para a barra) quando o nvidia-smi falha.

case "$1" in
  gpu)      campo=utilization.gpu;    formato='%s%%';  falha='N/A' ;;
  temp)     campo=temperature.gpu;    formato='+%s°C'; falha='N/A' ;;
  vram)     campo=utilization.memory; formato='%s%%';  falha='N/A' ;;
  vram-bar) campo=utilization.memory; formato='%s';    falha='0' ;;
  *) echo -n 'N/A'; exit 1 ;;
esac

valor=$(nvidia-smi --query-gpu="$campo" --format=csv,noheader,nounits 2>/dev/null | head -n 1)

if [[ $valor =~ ^[0-9]+$ ]]; then
  printf "$formato" "$valor"
else
  echo -n "$falha"
fi
