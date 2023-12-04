String? titleValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Inserisci il titolo del vinile';
  }
  return null;
}

String? authorValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Inserisci l\'autore del vinile';
  }
  return null;
}

String? yearValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Inserisci l\'anno di rilascio del vinile';
  }

  int? number = int.tryParse(value);

  if (number != null) {
    return null;
  } else {
    return 'Inserisci un numero valido';
  }
}
