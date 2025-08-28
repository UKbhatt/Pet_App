class Pet {
  final String id;
  final String name;
  final String type;
  final int age;
  final String notes;

  Pet({required this.id, required this.name, required this.type, required this.age, required this.notes});

  factory Pet.fromJson(Map<String, dynamic> j) =>
      Pet(id: j["id"], name: j["name"], type: j["type"], age: j["age"], notes: j["notes"] ?? "");
}
