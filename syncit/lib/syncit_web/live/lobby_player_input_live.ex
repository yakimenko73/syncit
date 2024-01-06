defmodule SyncitWeb.LobbyPlayerInputLive do
  use SyncitWeb, :live_view

  @topic "lobby:player"

  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <.input field={@form[:uri]} type="url" phx-keydown="new_uri" phx-key="Enter" phx-click="lv:clear-flash" placeholder="Try another one..." />
    """
  end

  def mount(_params, _session, socket) do
    uri = live_flash(socket.assigns.flash, :uri)
    form = to_form(%{"uri" => uri}, as: "video")
    {
      :ok,
      assign(socket, form: form),
      temporary_assigns: [
        form: form
      ],
      layout: false
    }
  end

  def handle_event("new_uri", %{"key" => "Enter", "value" => uri}, socket) do
    uri
    |> Syncit.extract_video_id
    |> broadcast_video_id(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  defp broadcast_video_id(id, socket) when id != nil do
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "update_video", %{video_id: id})
    {:noreply, socket}
  end

  defp broadcast_video_id(id, socket) when id == nil do
    {:noreply, put_flash(socket, :error, "Invalid YouTube link")}
  end
end
