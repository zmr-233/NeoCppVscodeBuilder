#!/bin/bash

# 引入颜色工具脚本
source "$(dirname "$0")/color_utils.sh"

INFO "正在清理构建文件..."

# 清理 .bin 目录
rm -rf .bin/*

# 清理输入、和标志文件
# rm -rf .in/* .out/* .err/* .flag/*

# 输出、错误文件
rm -rf .out/* .err/*

# 清理生成的 .gdb 脚本文件
rm -rf .debug/*

SUCCESS "清理完成"