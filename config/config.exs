# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :blackbird, Blackbird.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VLC+FWuMz0tRSiKHUvufgaNA/X/KA7XctdcEV3Zn7TnmxL6Wmn0inf4Iz9f/8bWr",
  render_errors: [view: Blackbird.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Blackbird.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :extwitter, :oauth, [
  consumer_key: "AyPIvnrnVgBW0XbV2r497WnqC",
  consumer_secret: "6bjSztEawxcV2cVyRlUTdjH9FdxU4KET9h9qkKHpxukmrH44gV",
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
