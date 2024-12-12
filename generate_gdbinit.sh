#!/bin/bash

# 引入颜色工具脚本
source "$(dirname "$0")/color_utils.sh"

check_arguments() {
    if [ -z "$1" ]; then
        ERROR "未指定源文件。"
        exit 1
    fi
}

initialize_variables() {
    SOURCE_FILE=$1
    if [ ! -f "$SOURCE_FILE" ]; then
        ERROR "源文件不存在: $SOURCE_FILE"
        exit 1
    fi

    SOURCE_DIR=$(dirname "$SOURCE_FILE")
    SOURCE_BASENAME=$(basename "$SOURCE_FILE")
    SOURCE_NAME="${SOURCE_BASENAME%.*}"
    RELATIVE_PATH=${SOURCE_DIR#${PWD}/}
    BIN_PATH="${PWD}/.bin/${RELATIVE_PATH}/${SOURCE_NAME}"
}

get_config_file() {
    if [ -f "${SOURCE_DIR}/cfg.conf" ]; then
        CONFIG_FILE="${SOURCE_DIR}/cfg.conf"
    else
        CONFIG_FILE="${PWD}/.vscode/cfg.conf"
    fi
}

read_redirect_settings() {
    INPUT_REDIRECT="OFF"
    OUTPUT_REDIRECT="OFF"
    ERROR_REDIRECT="OFF"
    FLAG_REDIRECT="OFF"

    while IFS='= ' read -r key value; do
        case "$key" in
            input) INPUT_REDIRECT="$value" ;;
            output) OUTPUT_REDIRECT="$value" ;;
            error) ERROR_REDIRECT="$value" ;;
            flag) FLAG_REDIRECT="$value" ;;
        esac
    done < <(awk '/^\[redirect\]/,/^\[/{if($0 !~ /^\[|^#|^[[:space:]]*$/) print}' "$CONFIG_FILE")
}

generate_run_command() {
    RUN_CMD="run"

    INPUT_PATHS=("${PWD}/.in/${RELATIVE_PATH}/${SOURCE_NAME}.in" "${PWD}/${RELATIVE_PATH}/${SOURCE_NAME}.in")
    FLAG_PATHS=("${PWD}/.flag/${RELATIVE_PATH}/${SOURCE_NAME}.flag" "${PWD}/${RELATIVE_PATH}/${SOURCE_NAME}.flag")
    OUTPUT_FILE="${PWD}/.out/${RELATIVE_PATH}/${SOURCE_NAME}.out"
    ERROR_FILE="${PWD}/.err/${RELATIVE_PATH}/${SOURCE_NAME}.err"

    # 输入重定向
    if [ "$INPUT_REDIRECT" = "ON" ]; then
        for path in "${INPUT_PATHS[@]}"; do
            if [ -f "$path" ]; then
                INPUT_FILE="$path"
                break
            fi
        done
        if [ -n "$INPUT_FILE" ]; then
            mkdir -p "$(dirname "$INPUT_FILE")"
            RUN_CMD+=" < $INPUT_FILE"
        fi
    fi

    # 命令行参数
    if [ "$FLAG_REDIRECT" = "ON" ]; then
        for path in "${FLAG_PATHS[@]}"; do
            if [ -f "$path" ]; then
                FLAG_FILE="$path"
                break
            fi
        done
        if [ -n "$FLAG_FILE" ]; then
            FLAGS=$(cat "$FLAG_FILE")
            RUN_CMD+=" $FLAGS"
        fi
    fi

    # 输出重定向
    if [ "$OUTPUT_REDIRECT" = "ON" ]; then
        mkdir -p "$(dirname "$OUTPUT_FILE")"
        RUN_CMD+=" > $OUTPUT_FILE"
    fi

    # 错误重定向
    if [ "$ERROR_REDIRECT" = "ON" ]; then
        mkdir -p "$(dirname "$ERROR_FILE")"
        RUN_CMD+=" 2> $ERROR_FILE"
    fi
}

generate_gdbinit() {
    if [ "$RUN_CMD" = "run" ]; then
        INFO "无需生成 GDB 脚本"
    else
        DEBUG_DIR="${PWD}/.debug/${RELATIVE_PATH}"
        GDBINIT_PATH="${DEBUG_DIR}/${SOURCE_NAME}.gdb"
        mkdir -p "$DEBUG_DIR"
        cat > "$GDBINIT_PATH" <<EOL
# GDB Debug Script: ${GDBINIT_PATH}
# Binary File: ${BIN_PATH}
${RUN_CMD}
EOL
        SUCCESS "生成 GDB 脚本 => $GDBINIT_PATH"
    fi
}

main() {
    check_arguments "$@"
    initialize_variables "$@"
    get_config_file
    read_redirect_settings
    generate_run_command
    generate_gdbinit
}

main "$@"

