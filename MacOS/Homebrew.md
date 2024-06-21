**<span style="font-size:3em;color:black">Homebrew</span>**
***

See [here](https://brew.sh/) to install.  (Not strictly MacOS...)

In general everything gets installed under ```/opt/homebrew```, with binaries linked from ```/opt/homebrew/bin``` (so put that into your ```$PATH```.)

But using the ```--cask``` option it can also install into "special" MacOS locations (for apps, fonts, etc.)

# Usage

Install: ```brew install wget```

Upgrade: ```brew upgrade wget```

Uninstall: ```brew remove wget```

# Install (and uninstall) an older version of a fomula
```bash
brew tap-new $USER/local-podman
brew extract --version=5.0.3 podman $USER/local-podman
brew search /podman/
brew install podman@5.0.3
brew remove podman@5.0.3
```