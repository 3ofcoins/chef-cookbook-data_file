#!/bin/sh
set -e

eval "$(/opt/chefdk/embedded/bin/chef shell-init sh)"

set -x
chef --version
rubocop --version
rubocop

foodcritic --version
foodcritic .

kitchen --version
kitchen test
