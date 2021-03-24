# Script for populating the database.

alias Dps.Repo
alias Dps.Poem
alias Dps.Author

coleridge = Repo.insert!(%Author{name: "Samuel Taylor Coleridge"}).id
robert_frost = Repo.insert!(%Author{name: "Robert Frost"}).id
edgar_allan_poe = Repo.insert!(%Author{name: "Edgar Allan Poe"}).id
clare_cavanagh = Repo.insert!(%Author{name: "Clare Cavanagh"}).id
adam_zagajewski = Repo.insert!(%Author{name: "Adam Zagajewski"}).id

Repo.insert!(%Poem{
  author_id: coleridge,
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
Enfolding sunny spots of greenery.

But oh! that deep romantic chasm which slanted
Down the green hill athwart a cedarn cover!
A savage place! as holy and enchanted
As e’er beneath a waning moon was haunted
By woman wailing for her demon-lover!
And from this chasm, with ceaseless turmoil seething,
As if this earth in fast thick pants were breathing,
A mighty fountain momently was forced:
Amid whose swift half-intermitted burst
Huge fragments vaulted like rebounding hail,
Or chaffy grain beneath the thresher’s flail:
And mid these dancing rocks at once and ever
It flung up momently the sacred river.
Five miles meandering with a mazy motion
Through wood and dale the sacred river ran,
Then reached the caverns measureless to man,
And sank in tumult to a lifeless ocean;
And ’mid this tumult Kubla heard from far
Ancestral voices prophesying war!
   The shadow of the dome of pleasure
   Floated midway on the waves;
   Where was heard the mingled measure
   From the fountain and the caves.
It was a miracle of rare device,
A sunny pleasure-dome with caves of ice!

   A damsel with a dulcimer
   In a vision once I saw:
   It was an Abyssinian maid
   And on her dulcimer she played,
   Singing of Mount Abora.
   Could I revive within me
   Her symphony and song,
   To such a deep delight ’twould win me,
That with music loud and long,
I would build that dome in air,
That sunny dome! those caves of ice!
And all who heard should see them there,
And all should cry, Beware! Beware!
His flashing eyes, his floating hair!
Weave a circle round him thrice,
And close your eyes with holy dread
For he on honey-dew hath fed,
And drunk the milk of Paradise."
})

Repo.insert!(%Poem{
  author_id: robert_frost,
  title: "The Road Not Taken",
  content: "Two roads diverged in a yellow wood,
And sorry I could not travel both
And be one traveler, long I stood
And looked down one as far as I could
To where it bent in the undergrowth;

Then took the other, as just as fair,
And having perhaps the better claim,
Because it was grassy and wanted wear;
Though as for that the passing there
Had worn them really about the same,

And both that morning equally lay
In leaves no step had trodden black.
Oh, I kept the first for another day!
Yet knowing how way leads on to way,
I doubted if I should ever come back.

I shall be telling this with a sigh
Somewhere ages and ages hence:
Two roads diverged in a wood, and I—
I took the one less traveled by,
And that has made all the difference."
})

Repo.insert!(%Poem{
  author_id: edgar_allan_poe,
  title: "The Raven",
  content: "Once upon a midnight dreary, while I pondered, weak and weary,
Over many a quaint and curious volume of forgotten lore—
      While I nodded, nearly napping, suddenly there came a tapping,
As of some one gently rapping, rapping at my chamber door.
“’Tis some visitor,” I muttered, “tapping at my chamber door—
            Only this and nothing more.”

      Ah, distinctly I remember it was in the bleak December;
And each separate dying ember wrought its ghost upon the floor.
      Eagerly I wished the morrow;—vainly I had sought to borrow
      From my books surcease of sorrow—sorrow for the lost Lenore—
For the rare and radiant maiden whom the angels name Lenore—
            Nameless here for evermore.

      And the silken, sad, uncertain rustling of each purple curtain
Thrilled me—filled me with fantastic terrors never felt before;
      So that now, to still the beating of my heart, I stood repeating
      “’Tis some visitor entreating entrance at my chamber door—
Some late visitor entreating entrance at my chamber door;—
            This it is and nothing more.”

      Presently my soul grew stronger; hesitating then no longer,
“Sir,” said I, “or Madam, truly your forgiveness I implore;
      But the fact is I was napping, and so gently you came rapping,
      And so faintly you came tapping, tapping at my chamber door,
That I scarce was sure I heard you”—here I opened wide the door;—
            Darkness there and nothing more.

      Deep into that darkness peering, long I stood there wondering, fearing,
Doubting, dreaming dreams no mortal ever dared to dream before;
      But the silence was unbroken, and the stillness gave no token,
      And the only word there spoken was the whispered word, “Lenore?”
This I whispered, and an echo murmured back the word, “Lenore!”—
            Merely this and nothing more.

      Back into the chamber turning, all my soul within me burning,
Soon again I heard a tapping somewhat louder than before.
      “Surely,” said I, “surely that is something at my window lattice;
      Let me see, then, what thereat is, and this mystery explore—
Let my heart be still a moment and this mystery explore;—
            ’Tis the wind and nothing more!”

      Open here I flung the shutter, when, with many a flirt and flutter,
In there stepped a stately Raven of the saintly days of yore;
      Not the least obeisance made he; not a minute stopped or stayed he;
      But, with mien of lord or lady, perched above my chamber door—
Perched upon a bust of Pallas just above my chamber door—
            Perched, and sat, and nothing more.

Then this ebony bird beguiling my sad fancy into smiling,
By the grave and stern decorum of the countenance it wore,
“Though thy crest be shorn and shaven, thou,” I said, “art sure no craven,
Ghastly grim and ancient Raven wandering from the Nightly shore—
Tell me what thy lordly name is on the Night’s Plutonian shore!”
            Quoth the Raven “Nevermore.”

      Much I marvelled this ungainly fowl to hear discourse so plainly,
Though its answer little meaning—little relevancy bore;
      For we cannot help agreeing that no living human being
      Ever yet was blessed with seeing bird above his chamber door—
Bird or beast upon the sculptured bust above his chamber door,
            With such name as “Nevermore.”

      But the Raven, sitting lonely on the placid bust, spoke only
That one word, as if his soul in that one word he did outpour.
      Nothing farther then he uttered—not a feather then he fluttered—
      Till I scarcely more than muttered “Other friends have flown before—
On the morrow he will leave me, as my Hopes have flown before.”
            Then the bird said “Nevermore.”

      Startled at the stillness broken by reply so aptly spoken,
“Doubtless,” said I, “what it utters is its only stock and store
      Caught from some unhappy master whom unmerciful Disaster
      Followed fast and followed faster till his songs one burden bore—
Till the dirges of his Hope that melancholy burden bore
            Of ‘Never—nevermore’.”

      But the Raven still beguiling all my fancy into smiling,
Straight I wheeled a cushioned seat in front of bird, and bust and door;
      Then, upon the velvet sinking, I betook myself to linking
      Fancy unto fancy, thinking what this ominous bird of yore—
What this grim, ungainly, ghastly, gaunt, and ominous bird of yore
            Meant in croaking “Nevermore.”

      This I sat engaged in guessing, but no syllable expressing
To the fowl whose fiery eyes now burned into my bosom’s core;
      This and more I sat divining, with my head at ease reclining
      On the cushion’s velvet lining that the lamp-light gloated o’er,
But whose velvet-violet lining with the lamp-light gloating o’er,
            She shall press, ah, nevermore!

      Then, methought, the air grew denser, perfumed from an unseen censer
Swung by Seraphim whose foot-falls tinkled on the tufted floor.
      “Wretch,” I cried, “thy God hath lent thee—by these angels he hath sent thee
      Respite—respite and nepenthe from thy memories of Lenore;
Quaff, oh quaff this kind nepenthe and forget this lost Lenore!”
            Quoth the Raven “Nevermore.”

      “Prophet!” said I, “thing of evil!—prophet still, if bird or devil!—
Whether Tempter sent, or whether tempest tossed thee here ashore,
      Desolate yet all undaunted, on this desert land enchanted—
      On this home by Horror haunted—tell me truly, I implore—
Is there—is there balm in Gilead?—tell me—tell me, I implore!”
            Quoth the Raven “Nevermore.”

      “Prophet!” said I, “thing of evil!—prophet still, if bird or devil!
By that Heaven that bends above us—by that God we both adore—
      Tell this soul with sorrow laden if, within the distant Aidenn,
      It shall clasp a sainted maiden whom the angels name Lenore—
Clasp a rare and radiant maiden whom the angels name Lenore.”
            Quoth the Raven “Nevermore.”

      “Be that word our sign of parting, bird or fiend!” I shrieked, upstarting—
“Get thee back into the tempest and the Night’s Plutonian shore!
      Leave no black plume as a token of that lie thy soul hath spoken!
      Leave my loneliness unbroken!—quit the bust above my door!
Take thy beak from out my heart, and take thy form from off my door!”
            Quoth the Raven “Nevermore.”

      And the Raven, never flitting, still is sitting, still is sitting
On the pallid bust of Pallas just above my chamber door;
      And his eyes have all the seeming of a demon’s that is dreaming,
      And the lamp-light o’er him streaming throws his shadow on the floor;
And my soul from out that shadow that lies floating on the floor
            Shall be lifted—nevermore!"
})

Repo.insert!(%Poem{
      author_id: adam_zagajewski,
      translator_id: clare_cavanagh,
      title: "Try to Praise the Mutilated World",
      content: "Try to praise the mutilated world.
Remember June's long days,
and wild strawberries, drops of rosé wine.
The nettles that methodically overgrow
the abandoned homesteads of exiles.
You must praise the mutilated world.
You watched the stylish yachts and ships;
one of them had a long trip ahead of it,
while salty oblivion awaited others.
You've seen the refugees going nowhere,
you've heard the executioners sing joyfully.
You should praise the mutilated world.
Remember the moments when we were together
in a white room and the curtain fluttered.
Return in thought to the concert where music flared.
You gathered acorns in the park in autumn
and leaves eddied over the earth's scars.
Praise the mutilated world
and the gray feather a thrush lost,
and the gentle light that strays and vanishes
and returns."
    })
