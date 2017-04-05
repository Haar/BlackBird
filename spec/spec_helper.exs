Code.require_file("spec/phoenix_helper.exs")

Application.ensure_all_started(:bypass)

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    {:shared, tags: tags}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
