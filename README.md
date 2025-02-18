# Open Access (OA) Waiver
[![CircleCI](https://circleci.com/gh/pulibrary/oawaiver.svg?style=svg)](https://circleci.com/gh/pulibrary/oawaiver)
[![Coverage Status](https://coveralls.io/repos/github/pulibrary/oawaiver/badge.svg)](https://coveralls.io/github/pulibrary/oawaiver)
[![Ruby 3.2.3](https://img.shields.io/badge/ruby-3.2.3-CC342D?logo=ruby "Ruby 3.2.3")](https://www.ruby-lang.org/en/news/2024/01/18/ruby-3-2-3-released/)
[![Node.js 22.13.1](https://img.shields.io/badge/node.js-22.13.1-5FA04E?logo=nodedotjs "Node.js 22.13.1")](https://nodejs.org/en/blog/release/v22.13.1)

The Open Access (OA) Waiver service provides faculty and researchers with the ability to submit and manage access to publications managed by the [Scholarly Communications Office](https://library.princeton.edu/services/scholarly-communications). Currently, Princeton aims to ensure that all published scholarly articles are released under the [Open Access Policy](https://dof.princeton.edu/policies-procedure/policies/open-access), and as such, are available to the general public. This service ensures that faculty and researchers may submit waivers which may restrict access to any articles which may be (or have been) released as Open Access articles.

## Development

### Dependencies Setup

- `ruby 3.2.3`
- `node.js 22.13.1`

#### [Bundler](https://rubygems.org/gems/bundler/versions/2.3.22)

Please install Gem dependencies with the following:

```bash
$ bundle install
```

#### [Yarn](https://github.com/yarnpkg/yarn/releases/tag/v1.22.10)

Please install NPM dependencies with the following:

```bash
$ yarn install
```

#### [Lando](https://github.com/lando/lando/releases/tag/v3.20.8)

Start and initialize database services with `rake servers:start`

To stop database services: `rake servers:stop` or `lando stop`

#### Running the Application

```bash
$ bundle exec foreman start
```

Then, please access the application using [http://localhost:3000/](http://localhost:3000/)

### Running the Test Suites
```bash
$ bundle exec rake db:setup
```

## Deployment

In order to deploy the Rails app. to the `staging` environment, please invoke:
```bash
$ bundle exec cap staging deploy
```

To create a tagged release use the [steps in the RDSS handbook](https://github.com/pulibrary/rdss-handbook/blob/main/release_process.md)

### Staging Mail
Please note that mail will not be delivered on the stagig server.  This is expected behavior.

## Administration
### Solr Indexing

In order to reindex the data models into the Solr Collection, please invoke the following:

```bash
$ bundle exec rake oawaiver:solr:reindex
```

For reindexing on the remote server environments, please invoke:

```bash
$ bundle exec cap $RAILS_ENV oawaiver:solr:reindex
```

### Managing Roles for User Accounts

#### Local Deployments
For adding administrative privileges, please use the following:

```bash
$ bundle exec rake oawaiver:accounts:add_admin_role[$NET_ID]
```

For removing administrative privileges, please invoke:
```bash
$ bundle exec rake oawaiver:accounts:remove_admin_role[$NET_ID]
```

#### Remote Deployments
```bash
$ bundle exec cap staging oawaiver:accounts:add_admin_role[$NET_ID]
```

```bash
$ bundle exec cap staging oawaiver:accounts:remove_admin_role[$NET_ID]
```
