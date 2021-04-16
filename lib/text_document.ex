defmodule Neatpad.TextDocument do
  use GenServer

  # Callback

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:load_file, path}, state) do
    {:ok, contents} = File.read(path)

    linebuffer =
      Regex.scan(~r/\n/, contents, return: :index)
      |> Enum.map(fn [{pos, _}] -> pos + 1 end)
      |> (fn l -> [0 | l] end).()

    state =
      Map.update(state, :data, contents, fn _ -> contents end)
      |> Map.update(:linebuffer, linebuffer, fn _ -> linebuffer end)
      |> Map.update(:lineno, length(linebuffer), fn _ -> length(linebuffer) end)

    {:noreply, state}
  end

  @impl true
  def handle_call(:get, _, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:getline, lineno}, _, %{data: data, linebuffer: linebuffer} = state) do
    line_start = Enum.at(linebuffer, lineno - 1)
    line_end = Enum.at(linebuffer, lineno)

    data =
      case {line_start, line_end} do
        {nil, _} ->
          ""

        {_, nil} ->
          ""

        {_, _} ->
          line_length = line_end - line_start
          String.slice(data, line_start, line_length)
      end

    {:reply, data, state}
  end

  # Private API

  # Public API
  def start_link(opts), do: GenServer.start_link(__MODULE__, %{}, opts)

  def load_file(pid \\ __MODULE__, path), do: GenServer.cast(pid, {:load_file, path})

  def get(pid \\ __MODULE__), do: GenServer.call(pid, :get)

  def getline(pid \\ __MODULE__, lineno)
  def getline(pid, lineno) when lineno > 0, do: GenServer.call(pid, {:getline, lineno})
  def getline(_, _), do: ""
end
