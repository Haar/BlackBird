defmodule Blackbird.Query.Sentiment do

  @endpoint "http://text-processing.com/api/sentiment/"

  alias ExTwitter.Model.Tweet
  alias Blackbird.Query.Result

  def analyse(_, url \\ @endpoint)

  def analyse(tweets, url) when is_list(tweets) do
    tweets
    |> Enum.map(&Task.async(__MODULE__, :analyse, [&1, url]))
    |> Enum.map(&Task.await(&1))
    |> present_result
  end

  def analyse(tweet = %Tweet{text: text}, url) do
    with {:ok, %HTTPoison.Response{status_code: 200} = response} <- HTTPoison.post(url, "text=#{text}"),
         {:ok, parsed}                                           <- Poison.decode(response.body),
         {:ok, label}                                            <- Map.fetch(parsed, "label")
    do
      %Result{
        text: text, created_at: tweet.created_at, real_name: tweet.user.name,
        twitter_name: tweet.user.screen_name, sentiment: map_sentiment(label),
      }
    else
      result -> {:error, %{tweet: tweet, error: result}}
    end
  end

  defp map_sentiment("pos"),     do: "POSITIVE"
  defp map_sentiment("neg"),     do: "NEGATIVE"
  defp map_sentiment("neutral"), do: "NEUTRAL"
  defp map_sentiment(_),         do: "¯\_(ツ)_/¯"

  defp present_result(results) when is_list(results) do
    results
    |> Enum.map(__MODULE__, :present_result)
    |> Enum.filter(&(&1))
    |> (&{:ok, &1}).()
  end

  defp present_result(%Result{} = result), do: result
  defp present_result(_result) do
    # log result
    nil
  end
end
