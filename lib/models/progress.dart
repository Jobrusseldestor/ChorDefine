class prog {
  String name;
  String thumbnail;
  String description;

  prog({
    required this.name,
    required this.thumbnail,
    required this.description,
  });
}

List<prog> progre = [
  prog(
    name: "Major Chords Progress",
    thumbnail: "assets/pics/chord1.png",
    description: "Definition of Every Chord",
  ),
  prog(
    name: "Minor Chords Progress",
    thumbnail: "assets/pics/library.png",
    description: "Learn the basic positioning of chords in the fretboard",
  ),
];
