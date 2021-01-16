defmodule DpsWeb.PageControllerTest do
  use DpsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Poems"
  end

  test "GET /poems", %{conn: conn} do
    conn = get(conn, "/poems")
    assert html_response(conn, 200) =~ "Poems"
  end
end
