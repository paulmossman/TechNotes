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

**Cellar**: Where Homebrew installs things (query: `brew --cellar`)  e.g.  `/opt/homebrew/Cellar`

**rack**: A directory (directly under **Cellar**) where versions of a single Formula (**kegs**) are installed.  e.g. `/opt/homebrew/Cellar/opentofu`

**keg**: The directory (directly under a **rack**) that a specific version of a Formula has been installed into.  e.g. `/opt/homebrew/Cellar/opentofu/1.7.3`

**bottle**: A pre-built **keg** (at https://ghcr.io/ → GitHub Packages (arbitrary binary blobs)), instead of building from source.  e.g. `opentofu--1.7.3.arm64_sonoma.bottle.tar.gz`.  See [Bottle](#Bottle).
```
==> Fetching opentofu
==> Downloading https://ghcr.io/v2/homebrew/core/opentofu/blobs/sha256:ab487579b6d515d1dde550df2196421dd58f16faf6cf41916eb325bad1356e5d
```
Where that `sha256` comes from the `bottle` section of the [homebrew-core opentofu Formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/o/opentofu.rb).

curl --disable --cookie /dev/null --globoff --show-error \
--user-agent Homebrew --header Accept-Language:\ en \
--fail --progress-bar --retry 3 \
--header Accept:\ application/vnd.oci.image.index.v1\+json \
--header Authorization:\ Bearer\ QQ== \
--location --remote-time \
https://ghcr.io/v2/homebrew/core/opentofu/manifests/1.7.3


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

# Bottle
```bash
HOMEBREW_NO_ENV_HINTS=y brew install opentofu
==> Downloading https://ghcr.io/v2/homebrew/core/opentofu/manifests/1.7.3
################################################################################################################################################################################## 100.0%
==> Fetching opentofu
==> Downloading https://ghcr.io/v2/homebrew/core/opentofu/blobs/sha256:ab487579b6d515d1dde550df2196421dd58f16faf6cf41916eb325bad1356e5d
################################################################################################################################################################################## 100.0%
==> Pouring opentofu--1.7.3.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/opentofu/1.7.3: 7 files, 79.8MB
==> Running `brew cleanup opentofu`...
```
Where that `sha256` comes from the `bottle` → `arm64_sonoma` entry of the [homebrew-core opentofu Formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/o/opentofu.rb).

Note also:
```
curl -s https://ghcr.io/v2/homebrew/core/opentofu/manifests/1.7.3 --header Authorization:\ Bearer\ QQ== --header Accept:\ application/vnd.oci.image.index.v1\+json | jq '.manifests[] | select(.annotations."sh.brew.bottle.digest"=="ab487579b6d515d1dde550df2196421dd58f16faf6cf41916eb325bad1356e5d")'
{
  "mediaType": "application/vnd.oci.image.manifest.v1+json",
  "digest": "sha256:dc3ae202643a24ec441b7fdcb1befb0a5c67e34b7e8ceab416da8e403dd6c1a8",
  "size": 1993,
  "platform": {
    "architecture": "arm64",
    "os": "darwin",
    "os.version": "macOS 14.4"
  },
  "annotations": {
    "org.opencontainers.image.ref.name": "1.7.3.arm64_sonoma",
    "sh.brew.bottle.digest": "ab487579b6d515d1dde550df2196421dd58f16faf6cf41916eb325bad1356e5d",
    "sh.brew.bottle.size": "23907822",
    "sh.brew.tab": "{\"homebrew_version\":\"4.3.9-16-gb098b4c\",\"changed_files\":[],\"source_modified_time\":1720530339,\"compiler\":\"clang\",\"runtime_dependencies\":[],\"arch\":\"arm64\",\"built_on\":{\"os\":\"Macintosh\",\"os_version\":\"macOS 14.4\",\"cpu_family\":\"dunno\",\"xcode\":\"15.3\",\"clt\":\"15.3.0.0.1.1708646388\",\"preferred_perl\":\"5.34\"}}",
    "sh.brew.path_exec_files": "bin/tofu"
  }
}
```


