defmodule Blackbird.Query.Sentiment do

  @endpoint "http://text-processing.com/api/sentiment/"

  alias ExTwitter.Model.Tweet

  def analyse([tweets]) do
    tweets
    |> Enum.map(&Task.async(Sentiment, :analyse, [&1]))
    |> Enum.map(&Task.await(&1))
  end

  def analyse(tweet = %Tweet{}) do

  end
end
