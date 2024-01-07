defmodule SyncitWeb.LobbyPlayerInputLive do
  use SyncitWeb, :live_view

  @topic "lobby:player"
  @invalid_youtube_link_error "invalid YouTube link"

  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <.input name="uri" value="" phx-keydown="new_uri" phx-key="Enter" phx-click="lv:clear-flash" phx-blur="lv:clear-flash" placeholder="Drop a YouTube link, let the magic sync begin 🚀🎬" />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  def handle_event("new_uri", %{"key" => "Enter", "value" => uri}, socket) do
    uri
    |> Syncit.extract_video_id
    |> broadcast_video_id(socket)
  end

  defp broadcast_video_id(id, socket) when id != nil do
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "update_video", %{video_id: id})

    {:noreply, socket}
  end

  defp broadcast_video_id(id, socket) when id == nil do
    {:noreply, put_flash(socket, :error, @invalid_youtube_link_error)}
  end
end
