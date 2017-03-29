defmodule Blackbird.Query.RequestSpec do
  use ESpec

  alias Blackbird.Query.Request

  describe ".build" do
    let :result, do: Request.build(params())

    context "when passed invalid parameters" do
      context "when a required parameter is missing" do
        let :params, do: %{ "resultType" => "recent" }

        it "returns an :error" do
          expect(result()) |> to(eq {:error, :validation, %{"query" => ["is a required parameter"]}})
        end
      end

      context "when resultType is not valid" do
        let :params, do: %{"query" => "query", "resultType" => "foo"}

        it "returns an appropriate validation error" do
          expect(result()) |> to(eq {:error, :validation, %{"resultType" => ["must be either 'recent' or 'popular'"]}})
        end
      end
    end

    context "when passed valid parameters" do
      let :params, do: %{"query" => "query", "resultType" => "recent"}

      it "returns the request" do
        expect(result()) |> to(eq {:ok, %Request{term: "query", result_type: "recent"}})
      end
    end
  end
end
