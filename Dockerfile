FROM elixir:1.11 AS builder

ENV MIX_ENV=prod

WORKDIR /build/dps

# Download + Compile dependencies
RUN mix local.rebar --force && mix local.hex --force
COPY mix.* .
RUN mix do deps.get, deps.compile

# Compile static assets
COPY config config
COPY priv/static priv/static
RUN mix phx.digest

# Build
COPY . .
RUN mkdir -p /opt/release && \
    mix release && \
    mv _build/${MIX_ENV}/rel/dps /opt/release

# Runner image
FROM erlang:23-slim AS runner

WORKDIR /app/

COPY --from=builder /opt/release/dps .

CMD ["/app/bin/dps", "start"]
