# bootstrap

## Overview
A linux command for setting up your local development environment. Currently, it clones your dotfiles project, deploys them to your `$MNT_USER_PATH` (e.g. `/mnt/c/Users/foo`), and creates symbolic links that point to these dotfiles in your `$HOME` folder. Plans for more capabilities are currently in place.

This command is _idempotent_, i.e. you can run this command several times over with the guarantee that the _end state_ will always be the same.

## Caveats

Currently only supports `Ubuntu 18.04 (Bionic Beaver)`.

## Setup

Install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

Clone this repo.

Make sure the required environment variables are setup correctly; specifically:

* `$HOME` must point to your home directory.
* `$DOTFILES_URL` must point to your remote repo.
* `$DOTFILES_PLATFORM` must point to your desired platform _within_ your dotfiles repo.
* `$MNT_USER_PATH` must point to where you want your dotfiles to be deployed.

The script has defaults that could possibly serve as examples. They're currently setup to run on my machine (`Ubuntu 18.04` on `WSL`).

## Usage
See the help message for more information:

```
./bootstrap install -h
```

