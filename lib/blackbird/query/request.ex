defmodule Blackbird.Query.Request do

  defstruct term: nil, result_type: nil, errors: %{}

  alias Blackbird.Query.Request

  @required_params ~w(query resultType)
  @permitted_result_types ~w(popular recent)

  def build(params) do
    params
    |> validate_required
    |> validate_result_type
    |> generate_struct
  end

  defp validate_required(params) do
    Enum.reduce(@required_params, params, fn (param, acc) ->
      case Map.fetch(params, param) do
        :error         -> put_error(acc, param, "is a required parameter")
        {:ok, nil}     -> put_error(acc, param, "is a required parameter")
        {:ok, _result} -> acc
      end
    end)
  end

  defp validate_result_type(params) do
    case Enum.member?(@permitted_result_types, params["resultType"]) do
      true  -> params
      false -> put_error(params, "resultType", "must be either 'recent' or 'popular'")
    end
  end

  defp put_error(request, param, error_message) do
    errors = request
             |> Map.get(:errors, %{})
             |> Map.update(param, [error_message], &(&1 ++ [error_message]))

    Map.put(request, :errors, errors)
  end

  defp generate_struct(%{errors: errors}) do
    {:error, :validation, errors}
  end

  defp generate_struct(%{"query" => term, "resultType" => result_type}) do
    {:ok, %Request{term: term, result_type: result_type}}
  end
end
