# bootstrap

Bootstrap scripts for setting up your local dev environment. Specifically, with these scripts, your machine will have the following:

* dotfiles deployed to a specified folder, with symlinks in your `$HOME` folder pointing to them
* python and ansible

Simply copy the folder of the scripts you want; in Ubuntu, it'd usually be something like `/opt/cjvirtucio87-bootstrap/`, e.g. `/opt/cjvirtucio87-bootstrap/stowsh/bin`. Then add the `bin` folder to your path: `PATH=/opt/cjvirtucio87-bootstrap/stowsh/bin:${PATH}`.

