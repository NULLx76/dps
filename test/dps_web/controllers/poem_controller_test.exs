defmodule DpsWeb.PoemControllerTest do
  use DpsWeb.ConnCase

  @create_attrs %{
    title: "Some Title",
    epigraph: "Some Epi",
    content: "Some Content",
    author_id: 1
  }
  @invalid_attrs %{title: nil, epigraph: nil, content: nil, author_id: nil}

  defp random_string(length \\ 32) do
    :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
  end

  describe "index" do
    test "GET /poems", %{conn: conn} do
      conn = get(conn, Routes.poem_path(conn, :index))
      assert html_response(conn, 200) =~ "poems"
    end
  end

  describe "new poem" do
    test "is blocked with auth", %{conn: conn} do
      conn = get(conn, Routes.poem_path(conn, :new))
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "GET /authors/new", %{conn: conn} do
      conn =
        put_req_header(conn, "authorization", Plug.BasicAuth.encode_basic_auth("user", "secret"))

      conn = get(conn, Routes.poem_path(conn, :new))

      assert html_response(conn, 200) =~ "Add Poem"
    end
  end

  describe "create poem" do
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        put_req_header(conn, "authorization", Plug.BasicAuth.encode_basic_auth("user", "secret"))

      conn = post(conn, Routes.poem_path(conn, :create), poem: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Poem"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, new_author} = Dps.Author.Query.create_author(%{name: random_string()})

      conn =
        put_req_header(conn, "authorization", Plug.BasicAuth.encode_basic_auth("user", "secret"))

      conn =
        post(conn, Routes.poem_path(conn, :create),
          poem: %{@create_attrs | author_id: new_author.id}
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.poem_path(conn, :show, id)

      conn = get(conn, Routes.poem_path(conn, :show, id))
      html = html_response(conn, 200)

      Map.to_list(@create_attrs)
      |> Enum.all?(fn
        {_, attr} when is_binary(attr) -> html =~ attr
        _ -> true
      end)
      |> assert
    end
  end
end
