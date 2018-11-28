#!/bin/bash
set -eu
unameOut="$(uname -s)"
case "${unameOut}" in
  Darwin*)    readlink=greadlink;;
  *BSD*)      readlink=greadlink;;
  *)          readlink=readlink;;
esac
myloc="$($readlink -f "$(dirname "$0")")" || {
  echo 'need GNU coreutils!'
  exit 1
}
usage() {
  echo "Usage: install.sh install|uninstall"
}

dirs=(completions lib)

_link_libex_d() {
  ln -s "$myloc/${1}" "${HOME}/.libexec/shgit_${1}"
}
case ${1:-} in
  install)
    git config --global alias.sh "!'$myloc/shgit.sh'"
    echo "added alias 'sh' to your global git config."

    [[ -d "${HOME}/.libexec" ]] || {
      mkdir "${HOME}/.libexec"
      echo "created ${HOME}/.libexec"
    }
    for dir in dirs; do
      ln -s "$myloc/$dir" "${HOME}/.libexec/shgit_$dir"
    done
    echo "You can invoke the shell via 'git sh' from within a repo."
    ;;

  uninstall)
    for dir in dirs; do
      rm -r "${HOME}/.libexec/shgit_$dir"
      echo "Removed ${HOME}/.libexec/shgit_$dir"
    done
    git config --global --unset alias.sh
    echo "Removed alias 'sh' from your global git config"
    ;;
  *|-h)
    usage
    ;;
esac
