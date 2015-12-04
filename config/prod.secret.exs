use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :vapir, Vapir.Endpoint,
  secret_key_base: "i5Okdhx9kxdpEJnH61rHnjzNTin9EMFtj2UKvwEdAL+I0HZB8pfG+fqUBkdgx2uh"

# Configure your database
config :vapir, Vapir.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "vapir_prod",
  pool_size: 20
