defmodule SyncitWeb.LobbyChannelTest do
  use SyncitWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      SyncitWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(SyncitWeb.LobbyChannel, "lobby")

    %{socket: socket}
  end

  test "shout broadcasts to lobby", %{socket: socket} do
    push(socket, "shout", %{"hello" => "all"})
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
