#!/usr/bin/env bash

# Copyright © 2020 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u
pdir="${0%/*}/.."
prog="$pdir/mail-filter"
echo 1..1
in='From: Jakub Wilk <notifications@github.com>
X-GitHub-Sender: jwilk

test
'
xout='From: Jakub Wilk <jwilk@users.noreply.github.com>'
out=$("$prog" <<< "$in")
sed -e 's/^/# /' <<< "$out"
fout=$(grep '^From:' <<< "$out")
if [ "$fout" = "$xout" ]
then
    echo 'ok 1'
else
    echo 'not ok 1'
fi

# vim:ts=4 sts=4 sw=4 et ft=sh
