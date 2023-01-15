import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :preview_controller, PreviewControllerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "t2n71Nm6YF9OAdr7Gyso4wI0lJXhzubFUQIJ28A9S2IAVF3QBoCul8pwJQz5daOy",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
