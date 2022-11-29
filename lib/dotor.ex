defmodule Dotor do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Dotor.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: Dotor.Supervisor]

    Logger.info("http://127.0.0.1:8080")

    Supervisor.start_link(children, opts)
  end
end
