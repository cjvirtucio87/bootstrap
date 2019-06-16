# bootstrap

Bootstrap scripts for setting up your local dev environment. Specifically, with these scripts, your machine will have the following:

* dotfiles deployed to a specified folder, with symlinks in your `$HOME` folder pointing to them
* python and ansible

Simply copy the scripts to your `/usr/local/bin` directory.

# scripts

## stowsh

### Overview
A linux command for setting up your local development environment. It clones your dotfiles project, deploys them to your `$DOTFILES_DEPLOY_DIR` (e.g. `/mnt/c/Users/foo`), and creates symbolic links that point to these dotfiles in your `$HOME` folder.

You can also update your dotfiles project by running `stowsh update`, copying your dotfiles back into the cloned dotfiles repo.

There is also a pass-thru to the `git` command to manage your dotfiles repo, e.g. `stowsh git status` to view the status of your dotfiles repo.

### Caveats

Currently only supports `Ubuntu 18.04 (Bionic Beaver)`.

### Setup

Install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

Clone this repo.

Make sure the required environment variables are setup correctly; specifically:

* `$HOME` must point to your home directory.
* `$DOTFILES_URL` must point to your remote repo.
* `$DOTFILES_PLATFORM` must point to your desired platform _within_ your dotfiles repo.
* `$DOTFILES_DEPLOY_DIR` must point to where you want your dotfiles to be deployed.

The script has defaults that could possibly serve as examples. They're currently setup to run on my machine (`Ubuntu 18.04` on `WSL`).

### Usage
See the help message for more information:

```
stowsh -h
```

## install-ansible

### Overview

A platform-independent script for installing python and ansible.

This command is _idempotent_, i.e. you can run this command several times over with the guarantee that the _end state_ will always be the same.

### Caveats

Currently only supports `Ubuntu 18.04 (Bionic Beaver)`.

### Usage
See the help message for more information:

```
stowsh -h
```

