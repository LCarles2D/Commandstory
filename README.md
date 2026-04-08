# Commandstory
A tool for saving the recent commands used. Ideal for students taking coding class

## Description
A lightweight Bash and Zsh utility to save specific command line sessions. Perfect for students and developers to document their workflow.

## Instalation
```bash
git clone https://github.com/LCarles2D/Commandstory.git && cd Commandstory && ./install.sh
```
### Post-installation
The installer modifies your .bashrc or .zshrc to ensure the history is synchronized in real-time. To apply changes immediately without restarting:
Bash

```bash
source ~/.bashrc  # or ~/.zshrc
```

## How to use it
Commandstory works like  a logic switch, first we need to "turn on" with the `start` command and then use the `stop` to generate the output file
```bash
commandstory start # To start saving commands.
```
```bash
commandstory stop # To stop saving commands and generate the output file by default `./comandos.txt`
```

also you can use
```bash
commandstory stop -o ./commands.txt # Use the -o option to give a path for naming your output file.
```

| Command / Option | Description |
| :--- | :--- |
| `start` | Sets the anchor point to begin recording commands. |
| `stop` | Processes the history from the start point and generates the output file. |
| `-o <path>` | (Stop only) Defines a custom location or name for the generated file. |
| `-h` | Displays the basic help menu. |
| `-v` | Prints the current version of the tool. |

## Help and documentation
If you need technical details about commandstory or know some temporal file that create you can read the man documentation
```bash
man commandstory
```
or a technical description
```bash
whatis commandstory
```

**Autor: LCarles2D**

**Licencia: MIT**
