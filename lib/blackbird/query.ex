defmodule Blackbird.Query do

  alias Blackbird.Query.{Sentiment, Twitter}

  def perform(term) do
    term
    |> Twitter.search
    |> Sentiment.analyse
    |> build_response
  end

  defp build_response(_results) do

  end
end
