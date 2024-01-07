defmodule Syncit.Lobby.PlayerAgent do
  use Agent
  alias Syncit.Lobby.Player

  def start_link(_opts) do
    Agent.start_link(fn -> %Player{} end, name: __MODULE__)
  end

  def get_state, do: Agent.get(__MODULE__, & &1)

  def get_viewers_count, do: get_state().viewers_count

  def get_video_id, do: get_state().video_id

  def update_video_id(id), do: Agent.update(__MODULE__, &%{&1 | video_id: id})

  def increment_viewers_count(), do: Agent.update(__MODULE__, & %{&1 | viewers_count: &1.viewers_count + 1})

  def decrement_viewers_count(), do: Agent.update(__MODULE__, & %{&1 | viewers_count: &1.viewers_count - 1})
end