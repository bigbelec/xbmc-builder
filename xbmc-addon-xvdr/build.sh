#!/bin/sh
set -e

PKG_NAME='xbmc-addon-xvdr'
PPA='xbmc-addons'
SRC_URL='https://github.com/pipelka/xbmc-addon-xvdr.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='7'
    local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local sha=$(git --git-dir="$SRC_DIR/.git" log --format='%h' -n1 $REV)
    local ci_count=$(git --git-dir="$SRC_DIR/.git" log --format='%H' $REV | wc -l)
    local v_major=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.in | grep -E 'm4_define\(\[MAJOR\]' | awk '{print $2}' | tr -d ')')
    local v_minor=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.in | grep -E 'm4_define\(\[MINOR\]' | awk '{print $2}' | tr -d ')')
    local v_micro=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.in | grep -E 'm4_define\(\[MICRO\]' | awk '{print $2}' | tr -d ')')
    local version="${v_major}.${v_minor}.${v_micro}-$(($ci_count + $bs_ci_count + $delta))~${sha}"
    echo "$version"
}

_checkout() {
     local src="$1"
    _git_checkout "$src"
    cd "$src"
    ./autogen.sh
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    cp -r "$SRC_DIR/debian" "$deb_dir"
    cp -r "$DIR/debian"/* "$deb_dir"
    echo "$deb_dir"
}

_main $@