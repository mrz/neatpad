defmodule Neatpad do
  use Application

  @moduledoc """
  Documentation for `Neatpad`.
  """

  @impl true
  def start(_type, _args) do
    Neatpad.Supervisor.start_link(name: Neatpad.Supervisor)
  end
end
