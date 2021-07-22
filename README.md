# OA Waiver Service
[![CircleCI](https://circleci.com/gh/pulibrary/oawaiver.svg?style=svg)](https://circleci.com/gh/pulibrary/oawaiver)

The Open Access (OA) Waiver provides faculty and researchers with the ability to submit and manage access to publications managed by the [Scholarly Communications Office](https://library.princeton.edu/services/scholarly-communications). Currently, Princeton aims to ensure that all published scholarly articles are released under the [Open Access Policy](https://dof.princeton.edu/policies-procedure/policies/open-access), and as such, are available to the general public. This service ensures that faculty and researchers may submit waivers which may restrict access to any articles which may be (or have been) released as Open Access articles.

## Development

### Dependencies Setup

- Ruby 2.7.4
- Bundler 2.2.17

```bash
$ bundle config --local build.mysql2 "--with-ldflags=-L$(brew --prefix openssl)/lib"
$ bundle install
```

#### Lando

- Install Lando from https://github.com/lando/lando/releases (at least 3.x)
- See .tool-versions for language version requirements (ruby)

Then, please use Lando to run services required for both test and development environments.

Start and initialize database services with `rake servers:start`

To stop database services: `rake servers:stop` or `lando stop`

#### MariaDB/MySQL

Or, for running MySQL locally, please install the following:
- MariaDB (10.6)/MySQL (8.0)

```bash
$ brew install mariadb
$ brew services start mariadb
$ sudo mysql_upgrade
$ sudo mariadb-secure-installation
```

### Running the Test Suites
```bash
$ bundle exec rake db:setup
```

## Deployment
**To be drafted**
