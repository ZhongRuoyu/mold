#!/bin/bash
set -e
cd $(dirname $0)
echo -n "Testing $(basename -s .sh $0) ... "
t=$(pwd)/tmp/$(basename -s .sh $0)
mkdir -p $t

cat <<EOF | cc -o $t/a.o -c -x assembler -
  .text
  .globl _start
_start:
  nop
EOF

../mold -o $t/exe $t/a.o --filter foo -F bar

readelf --dynamic $t/exe > $t/log
fgrep -q 'Filter library: [foo]' $t/log
fgrep -q 'Filter library: [bar]' $t/log

echo OK
