defmodule Blackbird.Web.TweetsView do
  use Blackbird.Web, :view

  def render("results.json", %{results: results}) do
    render_many(results, __MODULE__, "result.json", as: :result)
  end

  def render("result.json", %{result: result}) do
    %{
      createdAt: result.created_at,
      text: result.text,
      realName: result.real_name,
      twitterName: result.twitter_name,
      sentiment: result.sentiment,
    }
  end
end
