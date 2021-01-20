defmodule Dps.PoemTest do
  use Dps.DataCase
  alias Dps.{Author, Poem}

  @create_attrs %{
    title: "Some Title",
    epigraph: "Some Epi",
    content: "Some Content",
    author_id: nil
  }

  def poem_fixture(attrs \\ %{}) do
    {:ok, author} = Author.create_author(%{name: "Some Name"})

    if get_in(attrs, [:author_id]) do
      {:ok, poem} =
        attrs
        |> Enum.into(@create_attrs)
        |> Poem.create_poem()

      poem
    else
      {:ok, poem} =
        attrs
        |> Enum.into(%{@create_attrs | author_id: author.id})
        |> Poem.create_poem()

      poem
    end
  end

  test "list_poems/0 lists all poems" do
    p = poem_fixture()

    list = Poem.list_poems()
    assert length(list) == 1
    other = hd(list)

    assert p.id == other.id
    assert p.title == other.title
    assert p.author_id == other.author_id
  end

  test "get_poem/1 returns the correct poem" do
    p = poem_fixture()

    other = Poem.get_poem(p.id)

    assert p.title == other.title
    assert p.author_id == other.author_id
    assert p.content == other.content
    assert p.epigraph == other.epigraph

    cached = Poem.get_poem(p.id)

    assert p.title == cached.title
    assert p.author_id == cached.author_id
    assert p.content == cached.content
    assert p.epigraph == cached.epigraph
  end
end
