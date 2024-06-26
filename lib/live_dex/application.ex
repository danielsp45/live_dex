defmodule LiveDex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @cache Application.compile_env(:live_dex, :cache_name)

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cachex, name: @cache},
      LiveDexWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:live_dex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveDex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveDex.Finch},
      # Start a worker by calling: LiveDex.Worker.start_link(arg)
      # {LiveDex.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveDexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveDex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveDexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
