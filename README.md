# Oranchelo Tools
Developments and build tools for [Oranchelo Icon Theme](https://github.com/OrancheloTeam/oranchelo-icon-theme).

### Requirements

##### Ubuntu

    sudo apt install git curl dh-make devscripts

### Installation

    git clone https://github.com/Madh93/oranchelo-tools/ && cd oranchelo-tools
    make
    sudo make install

### Oranchelo Environment Setup

Initialize a default workspace:

    oranchelo-tools init

Get last release of Oranchelo Icon Theme:

    oranchelo-tools update

Edit configuration file:

    oranchelo-tools config --edit

Config sample:

    BEGINBUILD
    ----------
    # TYPE    VERSION   CODENAME
    # deb     14.04     trusty

    # Add your builds here
    deb     15.10     wily
    deb     16.04     xenial
    ---------
    ENDBUILD

And build packages!

    oranchelo-tools build

### Contributing

1. Fork it ( https://github.com/Madh93/oranchelo-tools/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
