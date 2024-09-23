#!/usr/bin/env bash

# Copyright © 2020-2024 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u
pdir="${0%/*}/.."
prog="$pdir/mail-filter"
echo 1..2
in='From: Jakub Wilk <notifications@github.com>
Date: Mon, 23 Sep 2024 11:50:37 -0700
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
xout='Date: Mon, 23 Sep 2024 18:50:37 -0000'
fout=$(grep '^Date:' <<< "$out")
if [ "$fout" = "$xout" ]
then
    echo 'ok 2'
else
    echo 'not ok 2'
fi

# vim:ts=4 sts=4 sw=4 et ft=sh
