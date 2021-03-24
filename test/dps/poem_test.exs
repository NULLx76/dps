defmodule Dps.PoemTest do
  use Dps.DataCase
  alias Dps.{Author, Poem}

  @create_attrs %{
    title: "Some Title",
    epigraph: "Some Epi",
    content: "Some Content",
    author_id: nil,
    translator_id: nil
  }

  def poem_fixture(attrs \\ %{}) do
    {:ok, author} = Author.create_author(%{name: "Some Name"})

    author_id = case attrs do
      %{author_id: id} -> id
      _ -> author.id
    end

    {:ok, poem} =
      attrs
      |> Enum.into(%{@create_attrs | author_id: author_id})
      |> Poem.create_poem()

    poem
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

  test "that adding a translator works" do
    {:ok, translator} = Author.create_author(%{name: "Some Translator"})
    p = poem_fixture(%{translator_id: translator.id})

    poem = Poem.get_poem(p.id)

    assert poem.translator_id == translator.id
  end
end
