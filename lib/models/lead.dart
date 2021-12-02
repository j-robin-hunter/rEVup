class Lead {
  final String name;

  Lead({
    required this.name,
  });

  factory Lead.fromMap(Map data) {
    return Lead(
      name: data['name'] ?? '',
    );
  }
}