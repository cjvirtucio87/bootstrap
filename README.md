# bootstrap

Bootstrap scripts for setting up your local dev environment. Specifically, with these scripts, your machine will have the following:

* dotfiles deployed to a specified folder, with symlinks in your `$HOME` folder pointing to them
* python and ansible

Just move the folder for the command you want to your desired install directory, e.g. `mv /path/to/cloned/bootstrap/stowsh /opt/cjvirtucio87-bootstrap/stowsh`. Then, add the `bin` directory to your path: `PATH=/opt/cjvirtucio87-bootstrap/stowsh/bin:$PATH`. You'll also need to copy the project-wide `lib` folder: `mv /path/to/cloned/bootstrap/lib /opt/cjvirtucio87-bootstrap/lib`.

