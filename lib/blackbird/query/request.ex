defmodule Blackbird.Query.Request do

  defstruct term: nil, result_type: nil, errors: %{}

  alias Blackbird.Query.Request

  @required_params ~w(query resultType)

  def build(params) do
    params
    |> validate_required
    |> generate_struct
  end

  def validate_required(model) do
    errors = Enum.reduce(@required_params, %{}, fn (param, acc) ->
      case Map.fetch(model, param) do
        {:ok, nil} ->
          existing_errors = Map.get(acc, param) || []
          Map.put(acc, param, existing_errors ++ ["is a required parameter"])
        :error ->
          existing_errors = Map.get(acc, param) || []
          Map.put(acc, param, existing_errors ++ ["is a required parameter"])
        {:ok, _result} -> acc
      end
    end)
    Map.put(model, :errors, errors)
  end

  def generate_struct(%{errors: errors}) when map_size(errors) > 0 do
    {:error, :validation, errors}
  end

  def generate_struct(%{"query" => term, "resultType" => result_type}) do
    {:ok, %Request{term: term, result_type: result_type}}
  end
end
