FROM hexpm/elixir:1.16.0-erlang-25.3.2.8-ubuntu-jammy-20231004

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

WORKDIR /app

RUN apt-get update && \
    apt-get -y install build-essential

RUN mix local.hex --force && \
    mix local.rebar --force

# config
RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/

# deps
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# assets
COPY priv priv
COPY assets assets
RUN mix assets.deploy

# compile project
COPY lib lib
RUN mix compile

# copy runtime config
COPY config/runtime.exs config

RUN mix release

CMD mix ecto.setup && mix phx.server