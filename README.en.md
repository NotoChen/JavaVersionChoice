# Java version switching tool


## Directory

- [Project background](#ProjectBackground)
- [Installation](#Installation)
- [Directory structure](#DirectoryStructure)
- [use](#Use)
- [Ways to expand](#WaysToExpand)
- [Open Source License](#OpenSourceLicense)

## ProjectBackground

Developers in their daily work, will inevitably encounter the need to switch different manufacturers of open source JDK, different versions of JDK, and many developers do not have a unified management of the way to configure JDK, the installation path and environment configuration will be more messy, for this reason, this project uses the Tree structure for Java installation and management, and through the system script to complete the selection, one-click vendor/version switching.

## Installation

```git
git clone https://github.com/NotoChen/JavaVersionChoice.git
```

## DirectoryStructure

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


## Use

Run **[JavaVersionChoice.bat](https://github.com/NotoChen/JavaVersionChoice/blob/main/JavaVersionChoice.bat)**

![image](https://github.com/NotoChen/JavaVersionChoice/assets/46807914/5e429483-df3f-4b87-bcd8-c0bab217a74f)


## WaysToExpand

Download and install JDK from other vendors/versions, and the directory structure is placed in the repository in the form of **/vendor/version/bin and other directories**，and [JavaVersionChoice.bat](https://github.com/NotoChen/JavaVersionChoice/blob/main/JavaVersionChoice.bat)will be automatically compatible.

## OpenSourceLicense

[Apache License 2.0](https://github.com/NotoChen/JavaVersionChoice/blob/main/LICENSE) © NotoChen
