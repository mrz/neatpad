defmodule Neatpad.Supervisor do
  use Supervisor

  @impl true
  def init(:ok) do
    children = [
      {Neatpad.TextDocument, name: Neatpad.TextDocument},
      {Ratatouille.Runtime.Supervisor, runtime: [app: Neatpad.TextView]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end
end
