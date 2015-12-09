KDevelop D Language support plugin
-------------------------------------------------

This plugin introduces D language support for KDevelop. D is a programming language developed by Walter Bright and Andrei Alexandrescu. KDevelop is a free and open-source IDE developed by KDevelop community, available on most Unix-like systems and Microsoft Windows.

Features
--------------------
**NOTE**: Only a small part of the D language features is supported at this time. 
Some of the most important features include:
 -   Code highlighting.
 -   KDevelop navigation widgets.
 -   Code completion.

**Installing this plugin**

[Arch Linux](https://aur.archlinux.org/packages/kdevelop-dlang-git/)

**Manual process**

1) Install KDevelop 4.90.90 or better.

2) Install the LDC D compiler version 0.16.1 or better.

3) Go to parser/ and execute the build script: ./build.sh
   This builds the D part of the plugin.

4) Install the D Plugin as you would for a typical cmake project.

**Using this plugin**

Simpy open a .d or .di file and it should work.


Implementation details
---------------------------
**Parser**
Plugin uses libdparse by Brian Schott for parsing D sources.

**DUChain**
Definition-Use chain code is organized like most other language plugins for KDevelop organize it. DeclarationBuilder currently opens declarations and types of variables, functions, methods, modules and imports.

**Completion**
Completion code is mostly based on completion for KDevelop Go and QmlJS plugins, so you can use that for details.


Road map
-----------------------
If you want to contribute to the project look at this list.
- Implementing rest of D language features.
- Implementing smarter completion (try to match type that is needed by expression or function parameter).
- Writing tests and documentation together with improving overall stability of the plugin.
