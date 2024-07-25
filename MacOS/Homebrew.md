**<span style="font-size:3em;color:black">Homebrew</span>**
***

See [here](https://brew.sh/) to install.  (Not strictly MacOS...)

In general everything gets installed under ```/opt/homebrew```, with binaries linked from ```/opt/homebrew/bin``` (so put that into your ```$PATH```.)

But using the ```--cask``` option it can also install into "special" MacOS locations (for apps, fonts, etc.)

# Usage

Install: ```brew install wget```

Upgrade: ```brew upgrade wget```

Uninstall: ```brew remove wget```

# Glossary

Official: https://docs.brew.sh/Formula-Cookbook#homebrew-terminology

**tap**: A source of formulae

**Cellar**: Where Homebrew installs things (query: `brew --cellar`)

# Install (and uninstall) an older version of a fomula
```bash
brew tap-new $USER/local-podman
brew extract --version=5.0.3 podman $USER/local-podman
brew search /podman/
brew install podman@5.0.3
brew remove podman@5.0.3
```

# Custom Formula

[Add Software to Homebrew](https://docs.brew.sh/Adding-Software-to-Homebrew) - This is aimed at submitting to `homebrew-core`, but much is relevant.` 

[Ruby Formula (superclass) doc](https://rubydoc.brew.sh/Formula)