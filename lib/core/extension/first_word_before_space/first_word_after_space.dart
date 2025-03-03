extension StringFirstWordBeforeSpace on String {
  String getFirstWordBeforeSpace() {
    int index = indexOf(" ");
    if (index == -1) {
      return this;
    }
    return substring(0, index);
  }
}
