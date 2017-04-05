defmodule Blackbird.Query.Twitter do
  def search(%{term: term, result_type: result_type}) do
    try do
      {:ok, ExTwitter.search(term, [count: 5, result_type: result_type])}
    rescue
      e in ExTwitter.Error -> {:error, :twitter, e}
      e -> {:error, :generic, e}
    end
  end
end
