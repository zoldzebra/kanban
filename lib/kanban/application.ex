defmodule Kanban.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KanbanWeb.Telemetry,
      Kanban.Repo,
      {DNSCluster, query: Application.get_env(:kanban, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Kanban.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Kanban.Finch},
      # Start a worker by calling: Kanban.Worker.start_link(arg)
      # {Kanban.Worker, arg},
      # Start to serve requests, typically the last entry
      KanbanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kanban.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KanbanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
