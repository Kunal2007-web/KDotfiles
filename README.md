# 🚀 KDotfiles
#### KDotfiles is a project that simplifies the post-installation process of configuring dotfiles for various command-line programs.

![GitHub](https://img.shields.io/github/license/Kunal2007-web/KDotfiles?color=blue&label=License&style=for-the-badge)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Kunal2007-web/KDotfiles?color=g&display_name=tag&label=release&sort=semver&style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/Kunal2007-web/KDotfiles?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/Kunal2007-web/KDotfiles?style=for-the-badge)

This is a project aimed at making the tedious post installation process of configuring your commands and programs from dotfiles easier and faster. It uses bash as the main scripting language. It contains dotfiles for many famous and useful programs people generally use such as:

* ZSH and Additional Scripts
* Git
* Vim
* GPG
* NPM
* LSD: An alternative to the `ls` command.
* Bat: An alternative to the `cat` command.
* Lazygit: A terminal git UI.
* Ngrok: A localhost tunneling software.
* Amfora: A terminal gemini browser.
* Starship: A pretty and highly configurable terminal prompt.
* Topgrade: An program to upgrade all your programs.

more dotfiles will be added with time (and as I start to use them).

## ⚠️ Prerequisites

These programs should be installed before using the script:

1. `git`
2. `zsh`
3. `curl`
4. `rsync`
5. `oh my zsh`

This project only works for Unix-like and Unix-based systems, Ex - Linux, MacOS, etc.

## 💾 Installation & Usage

### Installation

Download KDotfiles .zip or .tar.gz file from [releases](https://github.com/Kunal2007-web/KDotfiles/releases) assets.

or Clone the repository in your home directory:

* with HTTPS:

``` bash
git clone https://github.com/Kunal2007-web/KDotfiles.git
```

* with SSH:

```bash
git clone git@github.com:Kunal2007-web/KDotfiles.git
```

* with Github CLI

```bash
gh repo clone Kunal2007-web/KDotfiles
```

### Usage

To install the dotfiles:

```bash
cd KDotfiles
chmod +x installdotfiles.sh
./installdotfiles.sh
```

## 🤝 Contributions

For contributing to the project, please read the [Code of Conduct](https://github.com/Kunal2007-web/KDotfiles/blob/main/docs/CODE_OF_CONDUCT.md) and [Contributing Guidelines](https://github.com/Kunal2007-web/KDotfiles/blob/main/docs/CONTRIBUTING.md).
