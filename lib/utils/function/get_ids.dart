List<int> getIds(List<String> ids) {
  final newIds = <int>[];
  for (var element in ids) {
    final id = element.split('/').last;
    newIds.add(int.parse(id));
  }
  return newIds;
}
