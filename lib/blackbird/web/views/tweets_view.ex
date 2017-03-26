defmodule Blackbird.Web.TweetsView do
  use Blackbird.Web, :view

  def render("results.json", %{results: results}) do
    Enum.map(results, &present_tweet/1)
  end

  def present_tweet(result) do
    %{
      createdAt: result.created_at,
      text: result.text,
      realName: result.real_name,
      twitterName: result.twitter_name,
      sentiment: result.sentiment,
    }
  end
end
