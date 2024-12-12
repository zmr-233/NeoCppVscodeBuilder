#!/bin/bash

set -e

# 引入颜色工具脚本
source "$(dirname "$0")/color_utils.sh"

get_config_file() {
    # 获取配置文件路径
    if [ -f "${SOURCE_DIR}/cfg.conf" ]; then
        CONFIG_FILE="${SOURCE_DIR}/cfg.conf"
    else
        CONFIG_FILE="${PWD}/.vscode/cfg.conf"
    fi
}

read_compile_options() {
    COMPILE_OPTIONS=$(awk '
        BEGIN { flag=0 }
        /^\[compile_options\]/{flag=1; next}
        /^\[/{flag=0}
        flag && NF && $1 !~ /^#/ {printf "%s ", $0}
    ' "$CONFIG_FILE")
}

read_libraries() {
    LIBS=$(awk '
        BEGIN { flag=0 }
        /^\[libraries\]/{flag=1; next}
        /^\[/{flag=0}
        flag && NF && $1 !~ /^#/ {printf "-l%s ", $1}
    ' "$CONFIG_FILE")
}

select_compiler() {
    case "$SOURCE_EXT" in
        c)
            COMPILER="gcc"
            ;;
        cpp|cc|cxx|CPP|C|c++|C++)
            COMPILER="g++"
            ;;
        *)
            ERROR "不支持的源文件扩展名: $SOURCE_EXT"
            exit 1
            ;;
    esac
}

compile_source() {
    # 创建必要的目录
    mkdir -p "$OUTPUT_DIR"

    # 编译源文件
    INFO "正在编译 => $SOURCE_FILE ..."
    DEBUG "$COMPILER $COMPILE_OPTIONS $SOURCE_FILE -o ${OUTPUT_DIR}/${SOURCE_NAME} $LIBS"
    $COMPILER $COMPILE_OPTIONS "$SOURCE_FILE" -o "${OUTPUT_DIR}/${SOURCE_NAME}" $LIBS

    # 检查编译是否成功
    if [ $? -eq 0 ]; then
        SUCCESS "编译成功 => ${OUTPUT_DIR}/${SOURCE_NAME}"
    else
        ERROR "编译失败！"
        exit 1
    fi
}

main() {
    # 检查参数
    if [ -z "$1" ]; then
        ERROR "未指定源文件。"
        exit 1
    fi

    # 获取当前源文件的路径和相关信息
    SOURCE_FILE=$1
    if [ ! -f "$SOURCE_FILE" ]; then
        ERROR "源文件不存在: $SOURCE_FILE"
        exit 1
    fi

    SOURCE_DIR=$(dirname "$SOURCE_FILE")
    SOURCE_BASENAME=$(basename "$SOURCE_FILE")
    SOURCE_NAME="${SOURCE_BASENAME%.*}"
    SOURCE_EXT="${SOURCE_BASENAME##*.}"
    RELATIVE_PATH=${SOURCE_DIR#${PWD}/}
    OUTPUT_DIR="${PWD}/.bin/${RELATIVE_PATH}"

    get_config_file
    read_compile_options
    read_libraries
    select_compiler
    compile_source
}

main "$@"