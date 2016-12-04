#!/usr/bin/env bash

set -euo pipefail

AOSP_PATH=${AOSP_PATH:-/aosp}
APP_PATH=${APP_PATH:-/app}
ARTIFACTS_PATH=${ARTIFACTS_PATH:-/artifacts}
MIRROR_PATH=${MIRROR_PATH:-/mirror}

usage() {
  cat <<USAGE
Usage: $0 <command>
命令:
  checkout一个分支：checkout-branch <mirrorurl> <branch> [sync-options]
    必须的volumes:
      /aosp       你想要存放aosp源码的目录
    Checks out 一个指定的分支到 /aosp。
  编译全部全部：build-all <target> [make-options]
    必须的volumes:
      /aosp       存放aosp源码的目录
    用你指定的target编译所有的/aosp 目录中的源码树。
  编译指定模块：build <target> <appname> [make-options]
    必须的volumes:
      /app        app存放代码的目录 (i.e.包含 Android.mk 的目录)
      /aosp       存放aosp源码的目录
      /artifacts  app代码生成后的目录
    用你指定的target编译/app源码，程序会先把/app复制到 /aosp/external/MY_<appname>
    . <appname> 必须不有冲突
    with with any built-in project or your module will not build. The
    prefix is added so that even if you accidentally do use a built-in
    name, at the very least you won't overwrite the files. Note that
    <local-module> must match the LOCAL_MODULE value in your Android.mk
    exactly. You will also need to set \`LOCAL_MODULE_TAGS := optional\` in
    your Android.mk because the build system requires it.
    当编辑成功后任何 shared/static libraries and executables 都会被复制到 /artifacts.
  帮助命令：help
    显示此文档
USAGE
}

command="$1"

case "$command" in
  checkout-branch)
    manifest="$2"
    branch="$3"
    shift; shift;shift
    cd "$AOSP_PATH"
    test -d .repo || repo init -u "$manifest" -b "$branch"
    repo sync "$@"
    ;;
  build-all)
    target="$2"
    shift; shift
    cd "$AOSP_PATH"
    set +u
    source build/envsetup.sh
    lunch "$target"
    set -u
    make -j $(nproc) "$@"
    ;;
  build)
    target="$2"; module="$3"
    shift; shift; shift
    cd "$AOSP_PATH"
    set +u
    source build/envsetup.sh
    lunch "$target"
    set -u
    module_path="$AOSP_PATH/external/MY_$module/"
    rm -rf "$module_path"
    cp -R "$APP_PATH/" "$module_path"
    make "$module" -j $(nproc) "$@"
    artifacts=(
      "$OUT/obj/STATIC_LIBRARIES/${module}_intermediates/${module}.a"
      "$OUT/system/lib/${module}.so"
      "$OUT/system/lib64/${module}.so"
      "$OUT/system/bin/$module"
    )
    for file in "${artifacts[@]}"; do
      if test -f "$file"; then
        cp "$file" "$ARTIFACTS_PATH/"
      fi
    done
    ;;
  help | "--help" | "-h")
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac