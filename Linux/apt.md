**<span style="font-size:3em;color:black">Apt</span>**
***

[apt-key](https://manpages.debian.org/testing/apt/apt-key.8.en.html) being deprecated.  Instead simply put the GPG key file (.gpg or .asc) at ```/etc/apt/keyrings/```, and used ```signed-by=<the file path>``` in the Apt source.  Example: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Apt sources placed in files at: ```/etc/apt/sources.list.d/```   [Reference](https://manpages.debian.org/stretch/apt/sources.list.5.en.html)

GPG key files:
- .asc: armoured
- .gpg: de-armoured

Show the contents of a GPG key file:
```bash
cat <the file path> | gpg --with-colons --import-options show-only --import
```
