defmodule Blackbird.Query do

  alias Blackbird.Query.{Sentiment, Twitter}

  def perform(query = %{}) do
    with {:ok, query}   <- validate(query),
         {:ok, tweets}  <- Twitter.search(query),
         {:ok, results} <- Sentiment.analyse(tweets),
         do: {:ok, results}
  end

  defp validate(query) do
    {:ok, query}
  end
end
