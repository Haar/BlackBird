defmodule Blackbird.Query.TwitterSpec do
  use ESpec, async: false

  alias Blackbird.Query.{Request, Twitter}

  describe ".search" do
    let :result, do: Twitter.search(request())

    context "when an error is raised" do
      let :request, do: %Request{result_type: "popular"}
      let :error, do: %ExTwitter.Error{code: 25, message: "Query parameters are missing."}

      before do: allow ExTwitter |> to(accept :search, fn _term, _opts -> raise error() end)

      it "returns the error correctly" do
        expect(result()) |> to(eq {:error, :twitter, error()})
      end
    end

    context "when results are returned" do
      let :request, do: %Request{term: "term", result_type: "popular"}
      let :tweet, do: %ExTwitter.Model.Tweet{ text: "My Tweet" }

      before do: allow ExTwitter |> to(accept :search, fn _term, _opts -> [tweet()] end)

      it "returns the results as an array" do
        case result() do
          {:ok, result} -> expect(result) |> to(have tweet())
        end
      end
    end
  end

end
