class chor {
  String name;
  String thumbnail;
  String description;

  chor({
    required this.name,
    required this.thumbnail,
    required this.description,
  });
}

List<chor> chords = [
  chor(
    name: "Major Chords",
    thumbnail: "assets/pics/chord1.png",
    description: "Definition of Every Chord",
  ),
  chor(
    name: "Minor Chords",
    thumbnail: "assets/pics/library.png",
    description: "Learn the basic positioning of chords in the fretboard",
  ),
];
