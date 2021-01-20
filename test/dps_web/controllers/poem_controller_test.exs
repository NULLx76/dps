defmodule DpsWeb.PoemControllerTest do
  use DpsWeb.ConnCase

  @create_attrs %{
    title: "Some Title",
    epigraph: "Some Epi",
    content: "Some Content",
    author_id: 1
  }
  @invalid_attrs %{title: nil, epigraph: nil, content: nil, author_id: nil}

  describe "index" do
    test "GET /poems", %{conn: conn} do
      conn = get(conn, Routes.poem_path(conn, :index))
      assert html_response(conn, 200) =~ "poems"
    end
  end

  describe "new poem" do
    test "is blocked without auth", %{conn: conn} do
      conn = get(conn, Routes.poem_path(conn, :new))
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "is available with auth", %{conn: conn} do
      conn = login(conn)

      conn = get(conn, Routes.poem_path(conn, :new))

      assert html_response(conn, 200) =~ "Add Poem"
    end
  end

  describe "create poem" do
    test "renders errors when data is invalid", %{conn: conn} do
      conn = login(conn)

      conn = post(conn, Routes.poem_path(conn, :create), poem: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Poem"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, new_author} = Dps.Author.Query.create_author(%{name: random_string()})

      conn = login(conn)

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

  describe "edit poem" do
    test "is blocked without auth", %{conn: conn} do
      conn = get(conn, Routes.poem_path(conn, :edit, 1))
      assert response(conn, 401) =~ "Unauthorized"
    end

    test "is available with auth", %{conn: conn} do
      conn = login(conn)

      {:ok, new_author} = Dps.Author.Query.create_author(%{name: random_string()})

      {:ok, new_poem} =
        Dps.Poem.Query.create_poem(%{
          author_id: new_author.id,
          title: random_string(),
          content: random_string()
        })

      conn = get(conn, Routes.poem_path(conn, :edit, new_poem.id))

      assert html_response(conn, 200) =~ "Edit Poem"
    end
  end

  describe "update poem" do
    test "renders errors when data is invalid", %{conn: conn} do
      conn = login(conn)

      {:ok, new_author} = Dps.Author.Query.create_author(%{name: random_string()})

      {:ok, new_poem} =
        Dps.Poem.Query.create_poem(%{
          author_id: new_author.id,
          title: random_string(),
          content: random_string()
        })

      conn = put(conn, Routes.poem_path(conn, :update, new_poem.id), poem: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Poem"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = login(conn)

      {:ok, new_author} = Dps.Author.Query.create_author(%{name: random_string()})

      {:ok, new_poem} =
        Dps.Poem.Query.create_poem(%{
          author_id: new_author.id,
          title: random_string(),
          content: random_string()
        })

      new_poem = Map.from_struct(%{new_poem | title: random_string()})
      conn = put(conn, Routes.poem_path(conn, :update, new_poem.id), poem: new_poem)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.poem_path(conn, :show, id)

      conn = get(conn, Routes.poem_path(conn, :show, id))
      assert html_response(conn, 200) =~ new_poem.title
    end
  end
end
