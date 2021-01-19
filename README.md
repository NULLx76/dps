# Poems
A minimalistic website to store and view my favourite poems.

An online version is hosted at <https://poems.xirion.net/>

For screenshots see [screenshots.md](./docs/screenshots.md)

## Development
Requirements:
* Docker (Optional, but very useful)
* Elixir and mix

To run dps in dev mode:
```bash
docker-compose up -d db # Start local postgres db inside a docker container
mix.ecto.reset     # Migrate and seed the database
mix phx.server     # Start the live reload server
```

For running the tests simply do
```bash
# Start db if it isn't running already
docker-compose up -d db

# Run tests
mix test
```

## Deployment
Some notes on how to deploy The application.

### K8s Deployment (recommended)
For deploying on k8s the files in `k8s` give an example of how to do so.

Make sure to set the FQDNs and the env vars correctly.

### Docker deployment
To deploy in docker you can use `docker-compose.yml` like so.

```bash
# Build the container
docker build . -t dps

# Start the docker-compose db
docker-compose up -d db

# Setup schema
mix ecto.reset

# Start dps itself
docker-compose up -d dps

# Verify its working
curl localhost:4000
```

### Running locally
To run the application locally in release mode do the following:

```bash
# Generate static digests (make sure to not commit these)
mix phx.digest

# Build the release
MIX_ENV=prod mix release

# Ensure database is populated
mix ecto.reset

# Run the program with correct parameters
DATABASE_URL=ecto://postgres:postgres@localhost/dps_prod \
RELEASE_COOKIE=secret-cookie \
SECRET_KEY_BASE=kZ3O750w/sd7CcXO9053xWGTlOW3dYtLORLiYKqOL25UwboP/TJZz5g+YhOVLzOy \
HOSTNAME=127.0.0.1 \
SERVICE_NAME=localhost.svc \
APP_HOST=localhost \
APP_PORT=4000      \
AUTH_USERNAME=user \
AUTH_PASSWORD=pass \
PORT=4000 \
_build/prod/rel/dps/bin/dps start
```

#### Deployment References
* [Elixir + Kubernetes = 💜 by Drew Cain](https://medium.com/@groksrc/elixir-plus-kubernetes-part-1-80129eab14f0)
* [Upcoming phoenix runtime config](https://github.com/phoenixframework/phoenix/pull/4040)
* [Phoenix Deployment Docs](https://hexdocs.pm/phoenix/deployment.html)
