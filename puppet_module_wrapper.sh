#!/bin/bash

$GIT_PATH = `which git`
$GIT_USER = `git config core.user`
$GIT_ROOT = '~/git/'

puppet module generate ${GIT_USER}-$1
