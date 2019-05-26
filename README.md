# bootstrap

## Overview
A linux command for setting up your local development environment. Currently, it clones your dotfiles project, deploys them to your `$MNT_USER_PATH` (e.g. `/mnt/c/Users/foo`), and creates symbolic links that point to these dotfiles in your `$HOME` folder. Plans for more capabilities are currently in place.

This command is _idempotent_, i.e. you can run this command several times over with the guarantee that the _end state_ will always be the same.

# Usage
See the help message for more information:

```
./bootstrap install -h
```

