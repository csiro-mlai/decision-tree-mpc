#!/bin/bash

if test -z "$3"; then
    echo "Usage: $0 <protocol> <height> <n_threads>"
    exit 1
fi

protocol=$1
height=$2
n_threads=$3
shift 3

cd MP-SPDZ

test -e logs || mkdir logs

case $protocol in
    sh2) protocol=hemi; PLAYERS=2; ;;
    sh3) protocol=ring; PLAYERS=3 ;;
    emul) protocol=emulate; compile_args="-K ''" ;;
esac

export PLAYERS

args="$*"

if [[ $protocol =~ ring || $protocol == emulate ]]; then
    ring=1
    compile_args="-R 64 $compile_args"
    if [[ $protocol == rep4-ring ]]; then
	args="split4 $args"
    elif [[ $protocol != emulate ]]; then
	args="split3 $args"
    fi
else
    ring=0
    args="edabit $args"
fi

args="adult $height $n_threads mixed nearest f15 k31 $args"

pypy3 ./compile.py $compile_args -CD $args | grep -v WARNING

touch ~/.rnd
Scripts/setup-ssl.sh 3

N=$PLAYERS

for i in $(seq 0 $[N-1]); do
    echo $i
    echo "${hosts[$i]}"
done

args=${args% }
prog=${args// /-}

bin=$protocol-party.x

if [[ $protocol = ring ]]; then
    bin=replicated-ring-party.x
elif [[ $protocol = emulate ]]; then
    bin=emulate.x
fi
