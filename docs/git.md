### Using git

This repository uses the tool `git` via the command line. On Linux and Mas OS, the `bash` terminal should come pre-installed. `git` may be installed but if not it can be installed as follows:

- Linux Ubuntu-based distros

```
sudo apt-get install git
```

- Linux Fedora

```
yum install git
```

or

```
sudo dnf install git-all
```

- Linux Install from Debian file

Download the `.deb` file for your OS from here:

https://pkgs.org/download/git

```
dpkg -i git_2.11.0-3+deb9u4_amd64.deb
```

- Linux Build from source

Download the latest version of git:

https://github.com/git/git/releases

or

https://mirrors.edge.kernel.org/pub/software/scm/git/

```
tar -zxf git-2.0.0.tar.gz
cd git-2.0.0
make configure
./configure --prefix=/usr
make all doc info
sudo make install install-doc install-html install-info
```

- Windows

Download Git for Windows (Git-Bash) by following the instructions here:

https://gitforwindows.org/

or

https://git-scm.com/

- Mac OS

Install usiing homebrew (requires Xcode): https://docs.brew.sh/Installation

```
brew install git
```
