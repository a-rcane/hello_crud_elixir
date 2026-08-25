defmodule HelloCrudElixir.Application do
  @moduledoc """
  The entry point for the HelloCrudElixir OTP application.
  """
  use Application
  @impl true
  def start(_type, _args) do
    children = [
      # Starts the in-memory Task Store Agent
      {HelloCrudElixir.Store, []},
      # Starts the HTTP Web Server on port 4000 using HelloCrudElixir.Router
      {Plug.Cowboy, scheme: :http, plug: HelloCrudElixir.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: HelloCrudElixir.Supervisor]

    IO.puts("""
    ========================================================
      🚀 HelloCrudElixir Server is running!
      🌐 Open UI: http://localhost:4000
    ========================================================
    """)

    Supervisor.start_link(children, opts)
  end
end
