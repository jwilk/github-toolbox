#!/usr/bin/env bash

# Copyright © 2021 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u
pdir="${0%/*}/.."
prog="$pdir/github-actions-logs"
prg="${prog##*/}";
echo 1..3
out=$("$prog" -h)
if [ -n "$out" ]
then
    echo "ok 1 $prg -h"
    sed -e 's/^/# /' <<< "$out"
else
    echo "not ok 1 $prg -h"
fi
if [ -z "${JWILK_GITHUB_TOOLBOX_NETWORK_TESTING-}" ]
then
    printf 'ok %d # skip set JWILK_GITHUB_TOOLBOX_NETWORK_TESTING=1 to enable tests that exercise network\n' 2 3
    exit
fi
url='https://github.com/jwilk/github-toolbox/actions/runs/2073216953'
tmpdir=$(mktemp -d -t github-actions-logs.tap.XXXXXX)
"$prog" "$url" "$tmpdir/out"
out=$(cd "$tmpdir/out" && find . -mindepth 1 -maxdepth 1 -ls)
if [ -n "$out" ]
then
    echo "ok 2 $prog URL DESTDIR"
    sed -e 's/^/# /' <<< "$out"
else
    echo "not ok 2 $prog URL DESTDIR"
fi
mkdir "$tmpdir/bin"
cat > "$tmpdir/bin/mc" <<EOF
#!/bin/sh
set -e -u
if [ "\$1" = '-h' ]
then
    exit 0
fi
cd "\$1"
find . -mindepth 1 -maxdepth 1 -ls
EOF
chmod +x "$tmpdir/bin/mc"
out=$(PATH="$tmpdir/bin:$PATH" "$prog" -m "$url")
if [ -n "$out" ]
then
    echo "ok 3 $prg URL DESTDIR"
    sed -e 's/^/# /' <<< "$out"
else
    echo "not ok 3 $prg URL DESTDIR"
fi
rm -rf "$tmpdir"

# vim:ts=4 sts=4 sw=4 et ft=sh
