# Build Container

FROM elixir:1.11-alpine as builder
WORKDIR /app

RUN apk add --no-cache --update build-base git npm

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV prod

COPY mix.exs .
COPY mix.lock .
ADD config ./config/
RUN mix deps.get
RUN mix deps.compile

ADD assets ./assets/
RUN npm --prefix ./assets install
RUN mix assets.compile

COPY . .
RUN mix release

# Release Container

FROM alpine:3.12
RUN apk add --no-cache --update bash openssl
WORKDIR /app

COPY --from=builder /app/_build/prod/rel/shorty/ .

CMD bin/shorty start_iex
ENV MIX_ENV prod
ENV PORT 4000
EXPOSE $PORT
