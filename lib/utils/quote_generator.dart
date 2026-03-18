import 'dart:math';

class QuoteGenerator {
  static final List<String> quotes = [
    "You have the right to perform your duty, not the results. — Bhagavad Gita",
    "Calm mind brings inner strength and self-confidence. — Dalai Lama",
    "Discipline is devotion in action.",
    "A healthy outside starts from the inside.",
    "The body is your temple. Keep it pure and clean.",
    "Let food be thy medicine and medicine be thy food.",
    "Small daily habits build the life you deserve.",
    "What you do every day matters more than what you do once in a while.",
  ];

  static String getQuote() {
    return quotes[Random().nextInt(quotes.length)];
  }
}
