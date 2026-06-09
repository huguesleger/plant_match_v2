extension StringCapitalize on String {
  String toCapitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String toCapitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  String toInitials() {
    final words = trim().split(RegExp(r'[\s\-]+')).where((w) => w.isNotEmpty);
    return words.isEmpty ? '' : words.take(2).map((w) => w[0].toUpperCase()).join();
  }
}
