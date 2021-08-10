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

#### Running the Application

```bash
$ bundle exec rails server
```

Then, please access the application using http://localhost:3000/

### Running the Test Suites
```bash
$ bundle exec rake db:setup
```

## Deployment

In order to deploy the Rails app. to the `staging` environment, please invoke:
```bash
$ bundle exec cap staging deploy
```

## Administration
### Importing from MySQL

Please request the URL for the last database export from the MySQL database, and assuming that this is downloaded to `$HOME/Downloads/oawaiver_export.mysql.sql`, then invoke the following:

```bash
$ cp $HOME/Downloads/oawaiver_export.mysql.sql .
$ bundle exec rake oawaiver:mysql:import[oawaiver_export.mysql.sql]
$ bundle exec rake oawaiver:mysql:migrate
```

Then, for the export process, please invoke:

```bash
$ bundle exec rake oawaiver:postgresql:export[oawaiver_export.psql.sql]
$ bundle exec cap staging oawaiver:postgresql:copy[oawaiver_export.psql.sql]
```

### Managing Roles for User Accounts

For adding administrative privileges, please use the following:
```bash
$ bundle exec rake oawaiver:accounts:add_admin_role[$NET_ID]
```

For removing administrative privileges, please use the following:
```bash
$ bundle exec rake oawaiver:accounts:remove_admin_role[$NET_ID]
```
