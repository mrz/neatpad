defmodule NeatpadTest do
  use ExUnit.Case
  doctest Neatpad

  import Neatpad.TextDocument

  describe "TextDocument" do
    setup do
      {:ok, pid} = start_supervised(Neatpad.TextDocument)

      %{pid: pid}
    end

    test "retrieves contents of file", %{pid: pid} do
      expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Aliquam malesuada tellus nulla, mattis aliquam sapien pharetra vel.
Etiam ac aliquet mi.
Maecenas faucibus dolor eu sollicitudin interdum.
Donec imperdiet eros id lacinia consequat.
Nullam ullamcorper sem nec tellus rutrum feugiat.
Proin a consectetur nunc, ac lacinia turpis.
Sed a semper dolor.
"
      load_file(pid, "test/lorem.txt")

      %{data: result} = get(pid)

      assert expected == result
    end

    test "retrieves line by number", %{pid: pid} do
      load_file(pid, "test/lorem.txt")

      expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n"
      assert expected == getline(pid, 1)

      expected = "Etiam ac aliquet mi.\n"
      assert expected == getline(pid, 3)
    end

    test "getline does not crash", %{pid: pid} do
      expected = ""

      load_file(pid, "test/lorem.txt")

      result = getline(pid, 9)

      assert expected == result

      result = getline(pid, 10)

      assert expected == result
    end
  end
end
