#!/bin/bash
. $(dirname $0)/common.inc

cat <<EOF | $CC -c -o $t/a.o -xc -
#include <stdio.h>
void hello() { printf("Hello world\n"); }
EOF

cat <<EOF | $CC -c -o $t/b.o -xc -
void hello();
int main() { hello(); }
EOF

./mold --relocatable -o $t/c.o $t/a.o $t/b.o

$CC -B. -o $t/exe $t/c.o
$QEMU $t/exe
