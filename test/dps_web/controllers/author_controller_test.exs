defmodule DpsWeb.AuthorControllerTest do
  use DpsWeb.ConnCase

  @create_attrs %{name: "Some Author"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "GET /authors", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :index))

      assert html_response(conn, 200) =~ "Authors"
    end
  end

  describe "new author" do
    test "is blocked with auth", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :new))
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "GET /authors/new", %{conn: conn} do
      conn =
        put_req_header(conn, "authorization", Plug.BasicAuth.encode_basic_auth("user", "secret"))

      conn = get(conn, Routes.author_path(conn, :new))

      assert html_response(conn, 200) =~ "Add Author"
    end
  end

  describe "create author" do
    test "is blocked with auth", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @create_attrs)
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "redirects to poem when data is valid", %{conn: conn} do
      conn =
        put_req_header(conn, "authorization", Plug.BasicAuth.encode_basic_auth("user", "secret"))

      conn = post(conn, Routes.author_path(conn, :create), author: @create_attrs)

      # Assert that we got redirected to create a new poem
      poem_path = Routes.poem_path(conn, :new, %{author: 0}) |> String.slice(0..-2)
      assert redirected_to(conn) |> String.starts_with?(poem_path)
      id = redirected_to(conn) |> String.trim(poem_path)
      assert redirected_to(conn) == Routes.poem_path(conn, :new, %{author: id})

      # Assert get on author shows the newly created author
      conn = get(conn, Routes.author_path(conn, :show, id))
      assert html_response(conn, 200) =~ @create_attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        put_req_header(conn, "authorization", Plug.BasicAuth.encode_basic_auth("user", "secret"))

      conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Author"
    end
  end
end
