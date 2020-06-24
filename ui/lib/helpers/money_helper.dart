class MoneyHelper {
  static String formatCash(int value) {
    return "R\$ " + (value.toDouble() / 100).toStringAsFixed(2).replaceAll('.', ',');
  }
}