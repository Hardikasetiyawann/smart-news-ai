class NumberFormatter {
// fungsi untuk memformat angka menjadi format yang lebih ringkas
  // Contoh:
  // 999      -> 999
  // 1200     -> 1,2 rb
  // 10000    -> 10 rb
  // 137500   -> 137 rb
  // 1000000  -> 1 jt
  // 1200000  -> 1,2 jt
  static String compact(int value) {
    if (value < 1000) {
      return value.toString();
    }

    // Ribuan
    if (value < 1000000) {
      final result = value / 1000;
      if (result < 10 && result % 1 != 0) {
        return '${_decimal(result)} rb';
      }
      return '${result.floor()} rb';
    }

    // Jutaaan
    final result = value / 1000000;
    if (result < 10 && result % 1 != 0) {
      return '${_decimal(result)} jt';
    }
    return '${result.floor()} jt';
  }

// helper untuk format desimal dengan 1 angka di belakang koma
  static String _decimal(double value) {
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }
}
