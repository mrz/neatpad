defmodule Neatpad.TextView do
  @behaviour Ratatouille.App

  import Ratatouille.View

  def init(_context) do
    Neatpad.TextDocument.load_file("/home/dorian/.spacemacs.d/personal.el")
    Neatpad.TextDocument.get()
  end

  def update(model, _msg) do
    model
  end

  def render(%{lineno: lineno}) do
    view do
      panel title: "Neatpad" do
        for line <- 0..lineno do
          label do
            text(content: Neatpad.TextDocument.getline(line))
          end
        end
      end
    end
  end
end
