defmodule ESpec.Phoenix.Extend do
  def controller do
    quote do
      alias Blackbird
      import Blackbird.Router.Helpers

      @endpoint Blackbird.Endpoint
    end
  end

  def view do
    quote do
      import Blackbird.Router.Helpers
    end
  end

  def channel do
    quote do
      @endpoint Blackbird.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
