# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dps.Repo.insert!(%Dps.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dps.Repo
alias Dps.Poem
alias Dps.Author

author_id = Repo.insert!(%Author{name: "Samuel Taylor Coleridge"}).id

Dps.Repo.insert!(%Poem{
  author_id: author_id,
  title: "Kubla Khan",
  epigraph: "Or, a vision in a dream. A Fragment.",
  content: "In Xanadu did Kubla Khan
  A stately pleasure-dome decree:
  Where Alph, the sacred river, ran
  Through caverns measureless to man
     Down to a sunless sea.
  So twice five miles of fertile ground
  With walls and towers were girdled round;
  And there were gardens bright with sinuous rills,
  Where blossomed many an incense-bearing tree;
  And here were forests ancient as the hills,
  Enfolding sunny spots of greenery."
})
