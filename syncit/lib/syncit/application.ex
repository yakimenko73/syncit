defmodule Syncit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SyncitWeb.Telemetry,
      Syncit.Repo,
      {DNSCluster, query: Application.get_env(:syncit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Syncit.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Syncit.Finch},
      # Start a worker by calling: Syncit.Worker.start_link(arg)
      # {Syncit.Worker, arg},
      # Start to serve requests, typically the last entry
      SyncitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Syncit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SyncitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
