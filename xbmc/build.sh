#!/bin/sh
set -e

: ${PKG_NAME:='xbmc'}
: ${PKG_EPOCH:='2'}
: ${REV:='FernetMenta/frodo'}
: ${SRC_URL:='https://github.com/FernetMenta/xbmc.git'}

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

PPA_DEPENDS="$PPA_DEPENDS
deb http://ppa.launchpad.net/wsnipex/xvba-dev/ubuntu #DISTRIB# main
deb-src $PPA_URL/$PPA/ubuntu #DISTRIB# main
deb http://ppa.launchpad.net/wsnipex/xvba-dev/ubuntu #DISTRIB# main
deb-src http://ppa.launchpad.net/wsnipex/xvba-dev/ubuntu #DISTRIB# main
deb http://ppa.launchpad.net/aap/xbmc/ubuntu #DISTRIB# main
deb-src http://ppa.launchpad.net/aap/xbmc/ubuntu #DISTRIB# main
deb http://ppa.launchpad.net/aap/intel-drivers/ubuntu #DISTRIB# main
deb-src http://ppa.launchpad.net/aap/intel-drivers/ubuntu #DISTRIB# main"

version() {
    local delta='22'
    local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local sha=$(git --git-dir="$SRC_DIR/.git" log --format='%h' -n1 $REV)
    local ci_count=$(git --git-dir="$SRC_DIR/.git" log --format='%H' $REV | wc -l)
    local v_major=$(git --git-dir="$SRC_DIR/.git" show $REV:xbmc/GUIInfoManager.h | grep 'define *VERSION_MAJOR' | awk '{print $3}')
    local v_minor=$(git --git-dir="$SRC_DIR/.git" show $REV:xbmc/GUIInfoManager.h | grep 'define *VERSION_MINOR' | awk '{print $3}')
    local version="${v_major}.${v_minor}-$(($ci_count + $bs_ci_count + $delta))~${sha}"
    echo "$version"
}

_checkout() {
     local src="$1"
    _git_checkout "$src"
}

_main $@
