# OA Waiver Service
[![CircleCI](https://circleci.com/gh/pulibrary/oawaiver.svg?style=svg)](https://circleci.com/gh/pulibrary/oawaiver)

The Open Access (OA) Waiver provides faculty and researchers with the ability to submit and manage access to publications managed by the [Scholarly Communications Office](https://library.princeton.edu/services/scholarly-communications). Currently, Princeton aims to ensure that all published scholarly articles are released under the [Open Access Policy](https://dof.princeton.edu/policies-procedure/policies/open-access), and as such, are available to the general public. This service ensures that faculty and researchers may submit waivers which may restrict access to any articles which may be (or have been) released as Open Access articles.

## Development

### Dependencies Setup

- Ruby 3.0.3
- Bundler 2.3.11

```bash
$ bundle install
```

#### Lando

- Install Lando from https://github.com/lando/lando/releases (at least 3.x)
- See .tool-versions for language version requirements (ruby)

Then, please use Lando to run services required for both test and development environments.

Start and initialize database services with `rake servers:start`

To stop database services: `rake servers:stop` or `lando stop`

#### Running the Application

```bash
$ bundle exec rails server
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
