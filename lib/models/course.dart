class Course {
  String name;
  String thumbnail;

  Course({
    required this.name,
    required this.thumbnail,
  });
}

List<Course> courses = [
  Course(
    name: "Learn Basic Chords",
    thumbnail: "assets/pics/chord1.png",
  ),
  Course(
    name: "Chord Library",
    thumbnail: "assets/pics/library.png",
  ),
  Course(
    name: "Ear Trainer",
    thumbnail: "assets/pics/trainerear.png",
  ),
  Course(
    name: "Chord Diagram",
    thumbnail: "assets/pics/diagram.png",
  ),
];
