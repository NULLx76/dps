FROM elixir:1.11-alpine AS builder

ENV MIX_ENV=prod

WORKDIR /build/dps

# Download + Compile dependencies
RUN mix local.rebar --force && mix local.hex --force
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# Compile static assets
COPY priv/static priv/static
RUN mix phx.digest

# Build
COPY . .
RUN mkdir -p /opt/release && \
    mix release && \
    mv _build/${MIX_ENV}/rel/dps /opt/release

# Runner image
FROM alpine:3 AS runner
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app/
ENV HOME=/app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --chown=nobody:nobody --from=builder /opt/release/dps .

CMD ["/app/bin/dps", "start"]
