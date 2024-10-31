class Course {
  String name;
  double completedPercentage;
  String author;
  String thumbnail;

  Course({
    required this.author,
    required this.completedPercentage,
    required this.name,
    required this.thumbnail,
  });
}

List<Course> courses = [
  Course(
    author: "Chordefine",
    completedPercentage: .10,
    name: "Learn Basic Chords",
    thumbnail: "assets/pics/chord1.png",
  ),
  Course(
    author: "Chordefine",
    completedPercentage: .10,
    name: "Chord Library",
    thumbnail: "assets/pics/library.png",
  ),
  Course(
    author: "Chordefine",
    completedPercentage: .10,
    name: "Ear Trainer",
    thumbnail: "assets/pics/trainerear.png",
  ),
  Course(
    author: "Chordefine",
    completedPercentage: .10,
    name: "Chord Diagram",
    thumbnail: "assets/pics/diagram.png",
  ),
];
