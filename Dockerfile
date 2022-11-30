FROM bitwalker/alpine-elixir:latest as build
WORKDIR /app
COPY mix* ./
RUN mix deps.get
RUN mix deps.compile
# TODO: hacer que funcione mongodb
FROM build AS start
WORKDIR /app
COPY . .
RUN mix compile
CMD [ "mix", "run", "--no-halt" ]
