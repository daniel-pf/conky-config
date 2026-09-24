#!/bin/bash
# curl -s http://a7.net.br/meuip/
LC_NUMERIC=en_US.UTF-8
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
current_date=$(date +%s)
read last < <( tail -n 1 "$SCRIPT_DIR/last" )
read date < <( tail -n 1 "$SCRIPT_DIR/date" )

date_diff=$((current_date-date))
if [ $date_diff -ge 10 ]; then
  echo $current_date > $SCRIPT_DIR/date
  curl -s --fail-early --fail --connect-timeout 1 --max-time 2 https://a7.net.br/meuip/ | tee $SCRIPT_DIR/last
else
  echo -n $last
fi;
