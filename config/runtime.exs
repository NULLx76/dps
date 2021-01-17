# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :dps, Dps.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :dps, DpsWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [host: System.fetch_env!("APP_HOST"), port: 443],
    secret_key_base: secret_key_base

  config :dps, DpsWeb.Endpoint, server: true

  auth_user = System.fetch_env!("AUTH_USERNAME")
  auth_pass = System.fetch_env!("AUTH_PASSWORD")

  config :dps, :basic_auth, username: auth_user, password: auth_pass

  service_name = System.fetch_env!("SERVICE_NAME")

  config :peerage, via: Peerage.Via.Dns,
    dns_name: service_name,
    app_name: "dps"

end
