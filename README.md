# Open Access (OA) Waiver

[![CircleCI](https://circleci.com/gh/pulibrary/oawaiver.svg?style=svg)](https://circleci.com/gh/pulibrary/oawaiver)
[![Coverage Status](https://coveralls.io/repos/github/pulibrary/oawaiver/badge.svg)](https://coveralls.io/github/pulibrary/oawaiver)
[![Ruby 3.2.3](https://img.shields.io/badge/ruby-3.2.3-CC342D?logo=ruby "Ruby 3.2.3")](https://www.ruby-lang.org/en/news/2024/01/18/ruby-3-2-3-released/)
[![Node.js 22.13.1](https://img.shields.io/badge/node.js-22.13.1-5FA04E?logo=nodedotjs "Node.js 22.13.1")](https://nodejs.org/en/blog/release/v22.13.1)

The Open Access (OA) Waiver service provides faculty and researchers with the ability to submit and manage access to publications managed by the [Scholarly Communications Office](https://library.princeton.edu/services/scholarly-communications). Currently, Princeton aims to ensure that all published scholarly articles are released under the [Open Access Policy](https://dof.princeton.edu/policies-procedure/policies/open-access), and as such, are available to the general public. This service ensures that faculty and researchers may submit waivers which may restrict access to any articles which may be (or have been) released as Open Access articles.

## Development

You can run the app with **Devbox** or your **system tools** (Bundler/Yarn/Lando). Pick one path below.

**Option A - Devbox**

This repo includes a devbox.json that provisions Ruby, Node/Yarn, PostgreSQL client libs, Nokogiri deps, and handy scripts.

**Prerequisites**

* [bin/first-time-setup.sh](bin/first-time-setup.sh)

**Quick start**

```bash
git clone git@github.com:pulibrary/oawaiver.git
cd oawaiver

# enter the reproducible dev environment
devbox shell

# install Ruby gems + JS deps (bundler is pinned by Devbox)
devbox run setup

# (optional) start local Solr for Sunspot
devbox run solr:start

# run the app
devbox run rails:server      # http://localhost:3000

# if the app uses Vite during dev, you can also run:
devbox run vite:dev

```

### Devbox command reference

Inside `devbox shell` you can use:

* devbox run setup – Install Bundler (pinned) + bundle install + yarn install

* devbox run rails:server – Start Rails (-b 0.0.0.0 -p 3000)

* devbox run vite:dev / devbox run vite:build – Front-end build/dev

* devbox run solr:start / solr:stop / solr:reindex – Sunspot helpers

* devbox run test – Run RSpec

* devbox run cap:staging / cap:prod – Capistrano deploy helpers

  > Tip: You can still run `bundle exec...` directly after `devbox shell`

## Option B - System tools (Bundler/Yarn/Lando)

**Dependencies**

* Ruby (as specified in the repo)

* Node.js + Yarn

* Lando (for local DB services), if you use rake servers:start

**Setup and run**

```bash
bundle install
yarn install
rake servers:start          # starts local services if you use Lando
bundle exec foreman start   # or: bundle exec rails s
# visit http://localhost:3000
```

To stop DB services: `rake servers:stop` or `lando stop`

## Tests

**With Devbox**

```bash
devbox shell
RAILS_ENV=test bundle exec rake db:setup
devbox run test            # or: bundle exec rspec
```

**Without Devbox**

```bash
RAILS_ENV=test bundle exec rake db:setup
bundle exec rspec
```

### Dependencies Setup

* `ruby 3.2.3`
* `node.js 22.13.1`

#### [Bundler](https://rubygems.org/gems/bundler/versions/2.3.22)

Please install Gem dependencies with the following:

```bash
bundle install
```

#### [Yarn](https://github.com/yarnpkg/yarn/releases/tag/v1.22.10)

Please install NPM dependencies with the following:

```bash
yarn install
```

#### [Lando](https://github.com/lando/lando/releases/tag/v3.20.8)

Start and initialize database services with `rake servers:start`

To stop database services: `rake servers:stop` or `lando stop`

#### Running the Application

```bash
bundle exec foreman start
```

Then, please access the application using [http://localhost:3000/](http://localhost:3000/)

### Running the Test Suites

```bash
bundle exec rake db:setup
```

## Deployment

In order to deploy the Rails app. to the `staging` environment, please invoke:

```bash
bundle exec cap staging deploy
```

To create a tagged release use the [steps in the RDSS handbook](https://github.com/pulibrary/rdss-handbook/blob/main/release_process.md)

### Staging Mail

Please note that mail will not be delivered on the stagig server.  This is expected behavior.

## Administration

### Solr Indexing

In order to reindex the data models into the Solr Collection, please invoke the following:

```bash
bundle exec rake oawaiver:solr:reindex
```

For reindexing on the remote server environments, please invoke:

```bash
bundle exec cap $RAILS_ENV oawaiver:solr:reindex
```

### Managing Roles for User Accounts

#### Local Deployments

For adding administrative privileges, please use the following:

```bash
bundle exec rake oawaiver:accounts:add_admin_role[$NET_ID]
```

For removing administrative privileges, please invoke:

```bash
bundle exec rake oawaiver:accounts:remove_admin_role[$NET_ID]
```

#### Remote Deployments

```bash
bundle exec cap staging oawaiver:accounts:add_admin_role[$NET_ID]
```

```bash
bundle exec cap staging oawaiver:accounts:remove_admin_role[$NET_ID]
```
