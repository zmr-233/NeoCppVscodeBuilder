## NeoCppVscodeBuilder

NeoCppVscodeBuilder is a tool for building and debugging C++ projects in VSCode.

### Features

- **Build and Debug Support**: Easily build and debug C++ projects in VSCode with simple key presses.
- **Auto-generated GDB Scripts**: Utilize GDB scripts to support integrated debugging in VSCode, with input, output, and error redirection.
- **Custom Compile Options**: Flexibly configure compile parameters, link libraries, and other compile options through the `cfg.conf` file.
- **Flexible Input and Parameter Configuration**: Supports input redirection and command-line parameter configuration using `.flag` and `.in` files in the current directory or a dedicated directory.

### Usage

1. Open the project folder.
2. Press `F5` to start building and debugging.

### Configuration Instructions

```conf
[compile_options]
-g
-O0

[redirect]
input = ON
output = OFF
error = OFF
flag = ON

[libraries]
apue
```

- **cfg.conf**: Used to configure compile options, link libraries, and redirection settings.

  - `[compile_options]`: Specifies compile parameters.
  - `[libraries]`: Specifies the libraries to link.
  - `[redirect]`: Configures the switches for input, output, and error redirection, as well as the use of command-line parameters.

- **GDB Scripts**: Auto-generated GDB scripts that provide integrated debugging and redirection functionality in VSCode.
- **.in and .flag Files**: Supports using `.in` files as input and `.flag` files as command-line parameters in the current directory or predefined directory, providing an efficient and direct configuration method.

### License

This project is licensed under the Apache License 2.0 - see the [LICENSE](./LICENSE) file for details.

***

## NeoCppVscodeBuilder

NeoCppVscodeBuilder 是一个用于在 VSCode 中构建和调试 C++ 项目的工具

### 功能

- **构建和调试支持**：通过简单的按键即可在 VSCode 中构建和调试 C++ 项目
- **自动生成 GDB 脚本**：利用 GDB 脚本，为 VSCode 集成调试提供支持，同时实现输入、输出和错误的重定向
- **自定义编译选项**：通过 `cfg.conf` 文件，灵活配置编译参数、链接库和其他编译选项
- **灵活的输入和参数配置**：支持在当前目录或专用目录下使用 `.flag` 和 `.in` 文件，提供输入重定向和命令行参数的灵活配置

### 使用方法

1. 打开项目文件夹
2. 按下 `F5` 开始构建和调试

### 配置说明

```conf
[compile_options]
-g
-O0

[redirect]
input = ON
output = OFF
error = OFF
flag = ON

[libraries]
apue
```

- **cfg.conf**：用于配置编译选项、链接库和重定向设置

  - `[compile_options]`：指定编译参数
  - `[libraries]`：指定需要链接的库
  - `[redirect]`：配置输入、输出和错误的重定向开关，以及命令行参数的使用

- **GDB 脚本**：自动生成的 GDB 脚本，提供 VSCode 集成调试和重定向功能
- **.in 和 .flag 文件**：支持在当前目录或预定义目录下使用 `.in` 文件作为输入，`.flag` 文件作为程序的命令行参数，提供高效、直接的配置方式

### License

This project is licensed under the Apache License 2.0 - see the [LICENSE](./LICENSE) file for details.

***

