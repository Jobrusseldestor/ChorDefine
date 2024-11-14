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
    thumbnail: "assets/pics/Majorr.png",
    description: "Bright and uplifting, major chords are built with a root, major third, and perfect fifth, creating a joyful sound.",
  ),
  chor(
    name: "Minor Chords",
    thumbnail: "assets/pics/Minorr.png",
    description: "Minor chords use a root, minor third, and perfect fifth for a darker, more emotional tone, often evoking sadness or mystery",
  ),
];
