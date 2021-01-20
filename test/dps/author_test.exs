defmodule Dps.AuthorTest do
  use Dps.DataCase
  alias Dps.Author

  @valid_attrs %{name: "Some name"}

  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Author.create_author()

    author
  end

  test "list_authors/0 returns all authors" do
    author = author_fixture()
    assert Author.list_authors() == [author]
  end

  test "list_authors/1 queries authors by name" do
    a = author_fixture(%{name: "Author A"})
    _ = author_fixture(%{name: "Author B"})

    assert Author.list_authors("Author A") == [a]
  end

  test "list_authors/2 queries authors by name and sorts" do
    _ = author_fixture(%{name: "AAA"})
    a = author_fixture(%{name: "Author A"})
    b = author_fixture(%{name: "Author B"})

    assert Author.list_authors("Author", desc: :name) == [b, a]
  end

  test "get_author/1 returns the correct entry" do
    author = author_fixture()
    # Cache miss
    assert Author.get_author(author.id) == author
    # Cache hit
    assert Author.get_author(author.id) == author
  end

  test "update_author/2 updates the name correctly" do
    author = author_fixture()
    {:ok, updated} = Author.update_author(author.id, %{name: "new name"})
    assert updated.id == updated.id
    assert updated.name != author.name
    assert Author.get_author(author.id).name == "new name"
  end
end
