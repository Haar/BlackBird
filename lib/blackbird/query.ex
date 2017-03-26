defmodule Blackbird.Query do

  alias Blackbird.Query.{Sentiment, Twitter}

  def perform(request = %{}) do
    with {:ok, tweets}  <- Twitter.search(request),
         {:ok, results} <- Sentiment.analyse(tweets),
         do: {:ok, results}
  end
end
