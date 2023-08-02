# Java版本切换工具

## 目录

- [项目背景](#项目背景)
- [安装](#安装)
- [目录结构](#目录结构)
- [使用](#使用)
- [拓展方式](#拓展方式)
- [开源协议](#开源协议)
- [贡献指南](#贡献指南)

## 项目背景

开发者在日常工作中，难免会遇到需要切换不同厂商开源的JDK，不同版本的JDK，同时有很多开发者没有统一管理配置JDK的方式方法，安装路径和环境配置会比较凌乱，基于此原因，本项目采用 **Tree**结构进行Java的安装和管理，并通过系统脚本完成选择式，一键式的厂商/版本切换。

## 安装

```git
git clone https://github.com/NotoChen/JavaVersionChoice.git
```

## 目录结构

```
Java
│───Corretto
│   │
│   │   8
│   └───11
│       │   bin
│       │   ...
│   Dragonwell
│   IBM
│   │
│   │   8
│   │   11
│   └───17
│       │   bin
│       │   ...
│   Kona
│   OpenJdk
│   OracleJdk
│   RedHat
│   JavaVersionChoice.bat
```


## 使用

1. 在命令行中运行[JavaVersionChoice.bat](JavaVersionChoice.bat)文件：

```bash
JavaVersionChoice.bat
```

2. 选择需要切换的Java厂商和版本，按照提示操作即可完成切换

![image](https://github.com/NotoChen/JavaVersionChoice/assets/46807914/4b2b61cb-5181-45fd-8ae8-6c901c33ce63)

3. 切换成功后，脚本会自动设置对应的JAVA_HOME和PATH环境变量。


## 拓展方式

如果需要添加其他厂商或版本的JDK，可以按照以下步骤进行拓展：

1. 下载安装其他厂商/版本的JDK，并将目录结构按照 **/厂商/版本/bin** 及其他目录的形式放置在仓库中。

2. 运行[JavaVersionChoice.bat](JavaVersionChoice.bat)，工具会自动识别并兼容新添加的厂商/版本。


## 开源协议

[Apache License 2.0](https://github.com/NotoChen/JavaVersionChoice/blob/main/LICENSE) © NotoChen

## 贡献指南

如果你发现了Bug或者有改进的建议，欢迎提交Issue和PR，帮助我们完善这个工具。


