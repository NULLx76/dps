# Poems
A minimalistic website to store and view my favourite poems.

## Development
To run dps in dev mode:
```bash
docker-compose up -d db # Start local postgres db inside a docker container
mix.ecto.reset     # Migrate and seed the database
mix phx.server     # Start the live reload server
```
