defmodule Blackbird.Query.Sentiment do

  @endpoint "http://text-processing.com/api/sentiment/"

  alias ExTwitter.Model.Tweet
  alias Blackbird.Query.Result

  def analyse(tweets) when is_list(tweets) do
    tweets
    |> Enum.map(&Task.async(__MODULE__, :analyse, [&1]))
    |> Enum.map(&Task.await(&1))
    |> present_results
  end

  def analyse(tweet = %Tweet{text: text}) do
    with {:ok, response} <- HTTPoison.post(@endpoint, "text=#{text}"),
         {:ok, parsed}   <- Poison.decode(response.body),
         {:ok, label}    <- Map.fetch(parsed, "label")
    do
      %Result{
        text: text, created_at: tweet.created_at, real_name: tweet.user.name,
        twitter_name: tweet.user.screen_name, sentiment: map_sentiment(label),
      }
    end
  end

  defp map_sentiment("pos"),     do: "POSITIVE"
  defp map_sentiment("neg"),     do: "NEGATIVE"
  defp map_sentiment("neutral"), do: "NEUTRAL"
  defp map_sentiment(_),         do: "¯\_(ツ)_/¯"

  defp present_results(result) do
    {:ok, result}
  end
end
