defmodule DpsWeb.FallbackController do
  use DpsWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_flash(:error, "Not Found")
    |> redirect(to: Routes.poem_path(conn, :index))
  end

  def call(conn, {:error, msg}) when is_binary(msg) do
    conn
    |> put_flash(:error, msg)
    |> redirect(to: Routes.poem_path(conn, :index))
  end

  def call(conn, _) do
    conn
    |> put_flash(:error, "Unknown Error Occured")
    |> redirect(to: Routes.poem_path(conn, :index))
  end
end
