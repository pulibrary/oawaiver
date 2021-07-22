# OA Waiver Service
[![CircleCI](https://circleci.com/gh/pulibrary/oawaiver.svg?style=svg)](https://circleci.com/gh/pulibrary/oawaiver)

The Open Access (OA) Waiver provides faculty and researchers with the ability to submit and manage access to publications managed by the [Scholarly Communications Office](https://library.princeton.edu/services/scholarly-communications). Currently, Princeton aims to ensure that all published scholarly articles are released under the [Open Access Policy](https://dof.princeton.edu/policies-procedure/policies/open-access), and as such, are available to the general public. This service ensures that faculty and researchers may submit waivers which may restrict access to any articles which may be (or have been) released as Open Access articles.

## Development

### Dependencies Setup

- MySQL (8.0)/MariaDB (10.6)
- Ruby 2.7.4

```bash
% brew install mariadb
% brew services start mariadb
% sudo mysql_upgrade
% sudo mariadb-secure-installation
```

```bash
% bundle config --local build.mysql2 "--with-ldflags=-L$(brew --prefix openssl)/lib"
% bundle install
```

### Running the Test Suites
```bash
% bundle exec rake db:setup
```

## Deployment
**To be drafted**
