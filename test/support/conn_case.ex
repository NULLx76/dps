defmodule DpsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use DpsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import DpsWeb.ConnCase

      alias DpsWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint DpsWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Dps.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Dps.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @spec login(Plug.Conn.t()) :: Plug.Conn.t()
  def login(conn) do
    Plug.Conn.put_req_header(
      conn,
      "authorization",
      Plug.BasicAuth.encode_basic_auth("user", "secret")
    )
  end

  @spec random_string(non_neg_integer) :: binary
  def random_string(length \\ 32) do
    :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
  end
end
