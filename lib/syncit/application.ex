defmodule Syncit.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SyncitWeb.Telemetry,
      Syncit.Repo,
      {DNSCluster, query: Application.get_env(:syncit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Syncit.PubSub},
      {Finch, name: Syncit.Finch},
      SyncitWeb.Endpoint,
      Syncit.Lobby.PlayerAgent
    ]

    opts = [strategy: :one_for_one, name: Syncit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SyncitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
