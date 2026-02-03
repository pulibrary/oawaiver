# Open Access (OA) Waiver

[![CircleCI](https://circleci.com/gh/pulibrary/oawaiver.svg?style=svg)](https://circleci.com/gh/pulibrary/oawaiver)
[![Coverage Status](https://coveralls.io/repos/github/pulibrary/oawaiver/badge.svg)](https://coveralls.io/github/pulibrary/oawaiver)
[![Ruby 3.2.3](https://img.shields.io/badge/ruby-3.2.3-CC342D?logo=ruby "Ruby 3.2.3")](https://www.ruby-lang.org/en/news/2024/01/18/ruby-3-2-3-released/)
[![Node.js 22.13.1](https://img.shields.io/badge/node.js-22.13.1-5FA04E?logo=nodedotjs "Node.js 22.13.1")](https://nodejs.org/en/blog/release/v22.13.1)

The Open Access (OA) Waiver service provides faculty and researchers with the ability to submit and manage access to publications managed by the [Scholarly Communications Office](https://library.princeton.edu/services/scholarly-communications). Currently, Princeton aims to ensure that all published scholarly articles are released under the [Open Access Policy](https://dof.princeton.edu/policies-procedure/policies/open-access), and as such, are available to the general public. This service ensures that faculty and researchers may submit waivers which may restrict access to any articles which may be (or have been) released as Open Access articles.

## Development

### Prerequisites

This application expects:

- Ruby `3.2.3`
- Node.js `22.13.1`
- Yarn `1.x`
- A Postgres database (typically via Lando in local development)

You can satisfy Ruby/Node/Yarn either via **Devbox** (recommended) or by installing them yourself.

---

### Option A: Devbox (recommended)

This repo includes a `devbox.json` which provides a consistent Ruby/Node/Yarn toolchain and common native dependencies (e.g. for `pg`, `nokogiri`, `ffi`).

1. Install Devbox:
   - <https://www.jetpack.io/devbox>

2. Start a shell with the repo toolchain:

  ```bash
  devbox shell
  ```

3. Install dependencies and prepare the database:

  ```sh
  devbox run setup
  ```

4. Start the app:

  ```sh
  devbox run server
  ```

Then access the application at: [http://localhost:3000](http://localhost:3000)
> Tip: Devbox shells are isolated. If you use direnv, add .envrc with use devbox so the environment loads automatically.

---

### Option B: Manual toolchain install

If you don’t want to use Devbox, install the versions from .tool-versions:

- Ruby 3.2.3

- Node.js 22.13.1

- Yarn 1.22.x

Then install dependencies:

#### Bundler

```sh
bundle install
```

#### Yarn

```sh
yarn install
```

#### Database services (Lando)

We use Lando to start and initialize local database services:

```sh
bundle exec rake servers:start
```

To stop services:

```sh
bundle exec rake servers:stop
# or
lando stop
```

---

#### Running the application

From a Devbox shell (recommended) or with the toolchain installed:

```sh
bundle exec foreman start
```

Then access the application at: [http://localhost:3000](http://localhost:3000/)

---

#### Running the test suites

Prepare the database (if needed):

```sh
bundle exec rake db:setup
```

Run specs:

```sh
bundle exec rspec
```

#### Deployment

To deploy the Rails app to the staging environment:

```sh
bundle exec cap staging deploy
```

To create a tagged release use the [steps in the RDSS handbook](https://github.com/pulibrary/rdss-handbook/blob/main/release_process.md)

#### Staging mail

Please note that mail will not be delivered on the staging server. This is expected behavior.

#### Administration

##### Solr indexing

To reindex the data models into the Solr collection:

```sh
bundle exec rake oawaiver:solr:reindex
```

For reindexing on remote server environments:

```sh
bundle exec cap $RAILS_ENV oawaiver:solr:reindex
```

#### Managing roles for user accounts

##### Local deployments

Add administrative privileges:

```sh
bundle exec rake oawaiver:accounts:add_admin_role[$NET_ID]
```

Remove administrative privileges:

```sh
bundle exec rake oawaiver:accounts:remove_admin_role[$NET_ID]
```

Remote deployments

```sh
bundle exec cap staging oawaiver:accounts:add_admin_role[$NET_ID]
```

```sh
bundle exec cap staging oawaiver:accounts:remove_admin_role[$NET_ID]
```
