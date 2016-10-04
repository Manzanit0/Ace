defmodule Ace.TCPTest do
  use ExUnit.Case, async: true

  test "echos each message" do
    port = 10001

    # Starting a server does not return until a connection has been dealt with.
    # For this reason the call needs to be in a separate process.
    # FIXME have the `start` call complete when the server is ready to accept a connection.
    task = Task.async(fn () ->
      {:ok, server} = Ace.TCP.start(port)
    end)
    :timer.sleep(100)

    {:ok, client} = :gen_tcp.connect({127, 0, 0, 1}, port, [{:active, false}, :binary])
    :ok = :gen_tcp.send(client, "blob\r\n")
    {:ok, "ECHO: blob\r\n"} = :gen_tcp.recv(client, 0)
  end
end
