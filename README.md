[![Code Climate](https://codeclimate.com/github/igorshapiro/quaker/badges/gpa.svg)](https://codeclimate.com/github/igorshapiro/quaker)
[![Gem Version](https://badge.fury.io/rb/quaker.svg)](https://badge.fury.io/rb/quaker)
[![CircleCI](https://circleci.com/gh/igorshapiro/quaker.svg?style=svg)](https://circleci.com/gh/igorshapiro/quaker)
[![Test Coverage](https://codeclimate.com/github/igorshapiro/quaker/badges/coverage.svg)](https://codeclimate.com/github/igorshapiro/quaker/coverage)

# Quaker

Extend docker-compose by adding support to:
- include files
- run services (and their dependencies) by tag
- automatically detect service directories by git repository

## Installation

```
gem install quaker
```

## Usage

Suppose, you're developing microservices and want to launch all dependencies
while working on some service.

Quaker can help you by:

- Better organizing your docker-compose definitions by adding `include` directive
- Get rid of hard-coded build paths by automatically resolving service directories using the `git` directive
- Being able to limit the services you want to run with the `tag` directives

### Directory layout

Suppose all your services are located in `~/projects`

You'll need the following directory structure to get running:

```
-projects
  |-| docker
  | |-| services
  |   |- all.yml
  |- warehouse_service
  |- web
  |- billing_service
```

Here `backend`, `web` and `background` are cloned git repositories you're working on.

You're `all.yml` file might look like:

```yaml
---
include:
  - infra.yml
warehouse:
  git: git@github.com:company/warehouse.git
  links:
    - mongo
  tags:
  - backend
  - warehouse
billing:
  git: git@github.com:company/billing.git
  links:
    - postgres
  tags:
  - backend
  - billing
web:
  git: git@github.com:company/web.git
  links:
    - redis
  tags:
  - warehouse
  - billing
  - ui
```

In your `infra.yml` file you'll have:

```yml
---
redis:
  image: redis
postgres:
  image: postgres
mongo:
  image: mongo
```

In this case you can generate `docker-compose.yml` for only the `backend` services and their dependencies by running:

```sh
quaker -t backend
```

`Note:` - the generated `docker-compose.yml` will not include the `redis` service as it is
not a dependency of any service with the `backend` tag, but will include `mongo`
and `postgres` even if they don't explicitly have the `backend` tag.

Then you can feed the generated `docker-compose.yml` to docker-compose like this:

```sh
qaker -t backend | docker-compose -f - up
```

# Roadmap

- Support service templates
- Automatically feed `docker-compose` with the generated YAML file
