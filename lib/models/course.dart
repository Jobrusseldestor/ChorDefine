class Course {
  String name;
  String thumbnail;
  String description;

  Course({
    required this.name,
    required this.thumbnail,
    required this.description,
  });
}

List<Course> courses = [
  Course(
    name: "Learn Basic Chords",
    thumbnail: "assets/pics/chord1.png",
    description: "Definition of Every Chord",
  ),
  Course(
    name: "Chord Library",
    thumbnail: "assets/pics/library.png",
    description: "Learn the basic positioning of chords in the fretboard",
  ),
  Course(
    name: "Ear Trainer",
    thumbnail: "assets/pics/trainerear.png",
    description: "Practice your pitch",
  ),
];
