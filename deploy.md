# Deployment notes
Some notes on how to deploy this application and how the deployment configuration works

## K8s Deployment
For deploying on k8s the files in `k8s` give an example of how to do so.

Make sure to set the FQDNs and the env vars correctly.

## Smoke Test Release
To smoke test the application in release mode do the following:

```bash
# Generate static digests (make sure to not commit these)
mix phx.digest

# Build the release
MIX_ENV=prod mix release

# Ensure database is populated
mix ecto.reset

# Run the program with dev parameters
DATABASE_URL=ecto://postgres:postgres@localhost/dps_dev \
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

## Smoke test docker
```bash
# first make sure no postgres container is running
mix postgres stop

# Start the docker-compose db
docker-compose up -d db

# Setup schema
mix ecto.reset

# Start dps itself
docker-compose up -d dps

# Verify its working
curl localhost:4000/api/poems | jq
```

## References
* [Elixir + Kubernetes = 💜 by Drew Cain](https://medium.com/@groksrc/elixir-plus-kubernetes-part-1-80129eab14f0)
* [Upcoming phoenix runtime config](https://github.com/phoenixframework/phoenix/pull/4040)
