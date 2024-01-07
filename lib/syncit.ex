defmodule Syncit do
  @moduledoc """
  Syncit keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @youtube_video_id_regex ~r/(?<=watch\?v=)([a-zA-Z0-9_-]{11})/

  def extract_video_id(youtube_uri) do
    case Regex.run(@youtube_video_id_regex, youtube_uri) do
      [_, id] -> id
      _ -> nil
    end
  end
end
