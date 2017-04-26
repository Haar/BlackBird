defmodule Blackbird.Query.SentimentSpec do
  use ESpec, async: true

  alias Blackbird.Query.Sentiment

  describe ".analyse" do
    before do
      bypass = Bypass.open
      {:ok, bypass: bypass}
    end

    context "when passed a list of tweets" do
      let :tweet, do: %ExTwitter.Model.Tweet{ text: "Tweet" }
      let :tweets, do: [tweet(), tweet()]
      let :result, do: Sentiment.analyse(tweets())

      it "returns the result of each tweet analysis"
      it "analyses each of the tweets in parallel"
    end

    context "when passed a single tweet" do
      let :tweet do
        %ExTwitter.Model.Tweet{
          text: "My Tweet", created_at: "Today", user: %{ name: "Me", screen_name: "me" }
        }
      end

      let :result, do: Sentiment.analyse(tweet(), "http://localhost:#{shared.bypass.port}")

      context "when the request fails" do
        before do
          Bypass.expect shared.bypass, fn conn ->
            Plug.Conn.resp(conn, 429, ~s<{"errors": [{"message": "Rate limit exceeded"}]}>)
          end
        end

        it "returns an :error response" do
          expect(result())
          |> to(eq {:error, :sentiment, %{tweet: tweet(), error: :rate_limited}})
        end
      end

      context "when the request passes" do
        before do
          Bypass.expect shared.bypass, fn conn ->
            Plug.Conn.resp(conn, 200, ~s<{"label": "pos"}>)
          end
        end

        it "returns a Query.Result" do
          expect(result()) |> to(be_struct Blackbird.Query.Result)
        end

        it "maps the sentiment correctly" do
          expect(result().sentiment) |> to(be "POSITIVE")
        end
      end

      context "when the text-processing result format changes unexpectedly" do
        it "returns an :error response"
      end
    end
  end
end
