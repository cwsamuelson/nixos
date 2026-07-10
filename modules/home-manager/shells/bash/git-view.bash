#!/usr/bin/env bash

# or could use worktree; not sure which would be better

tmp_dir=$(mktemp -d)

trap 'rm -rf $tmp_dir' EXIT

git archive $1 | tar -x -C $tmp_dir

vi -p $tmp_dir
