defmodule DpsWeb.AuthorControllerTest do
  use DpsWeb.ConnCase
  alias Dps.Author

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
      conn = login(conn)

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
      conn = login(conn)

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
      conn = login(conn)

      conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Author"
    end
  end

  describe "edit author" do
    test "is blocked with auth", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :edit, 1))
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "get edit author", %{conn: conn} do
      conn = login(conn)

      {:ok, new_author} = Author.Query.create_author(%{name: random_string()})

      conn = get(conn, Routes.author_path(conn, :edit, new_author.id))

      assert html_response(conn, 200) =~ "Edit Author"
    end
  end

  describe "update author" do
    test "is blocked with auth", %{conn: conn} do
      conn = put(conn, Routes.author_path(conn, :update, 1), author: @create_attrs)
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "redirects to author when data is valid", %{conn: conn} do
      conn = login(conn)

      old_name = random_string()
      {:ok, new_author} = Author.Query.create_author(%{name: old_name})

      new_name = random_string()
      conn = put(conn, Routes.author_path(conn, :update, new_author.id), author: %{name: new_name})

      # Assert that we got redirected to the author page
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.author_path(conn, :show, id)

      # Assert get on author shows the newly created author
      conn = get(conn, Routes.author_path(conn, :index))
      assert html_response(conn, 200) =~ new_name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = login(conn)

      {:ok, new_author} = Author.Query.create_author(%{name: random_string()})

      conn = put(conn, Routes.author_path(conn, :update, new_author.id), author: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Author"
    end
  end
end
