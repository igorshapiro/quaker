[![Code Climate](https://codeclimate.com/github/igorshapiro/quaker/badges/gpa.svg)](https://codeclimate.com/github/igorshapiro/quaker)

# Quaker

Extend docker-compose by adding support to:
- include files
- run services (and their dependencies) by tag
- automatically detect service directories by git repository

## Installation

```
gem install quaker
```

## Example

### Given:

```
# docker/services/infra.yml
redis:
  image: redis
  links:
    - mongo
mongo:
  image: mongo
postgres:
  image: postgres
```

```
# docker/services/all.yml
include:
  - infra.yml
svc1:
  depends_on:
    - redis
  tags:
    - svc1
svc2:
  depends_on:
    - mongo
  tags:
    - svc2

```

### Generating docker-compose file

```
quaker -t svc1
```

will generate a docker compose consisting only of `svc1` and `redis`.

`Note:` generated docker-compose will be written to stdout

### Using the generated docker-compose.yml

```
quaker -t svc1 | docker-compose -f - up(/down)
```
