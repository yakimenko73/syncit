defmodule SyncitWeb.PlayerInputLive do
  use SyncitWeb, :live_view

  @topic "lobby:player"
  @youtube_video_id_regex ~r/(?<=watch\?v=)([a-zA-Z0-9_-]{11})/

  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <.input field={@form[:url]} type="url" phx-keydown="new_url" phx-key="Enter" phx-click="lv:clear-flash" placeholder="Try another one..." />
    """
  end

  def mount(_params, _session, socket) do
    url = live_flash(socket.assigns.flash, :url)
    form = to_form(%{"url" => url}, as: "video")
    {
      :ok,
      assign(socket, form: form),
      temporary_assigns: [
        form: form
      ],
      layout: false
    }
  end

  def handle_event("new_url", %{"key" => "Enter", "value" => uri}, socket) do
    uri
    |> extract_video_id
    |> broadcast_video_id(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  defp extract_video_id(uri) do
    case Regex.run(@youtube_video_id_regex, uri) do
      [_, id] -> id
      _ -> nil
    end
  end

  defp broadcast_video_id(id, socket) when id != nil do
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "update_video", %{video_id: id})
    {:noreply, socket}
  end

  defp broadcast_video_id(id, socket) when id == nil do
    {:noreply, put_flash(socket, :error, "Invalid YouTube link")}
  end
end
