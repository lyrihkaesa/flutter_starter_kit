import 'package:intl/intl.dart';

class Formatters {
  // Format currency (TRX)
  static String currency(double amount, {int decimals = 2}) {
    return NumberFormat('#,##0.${'0' * decimals}').format(amount);
  }

  // Format currency with symbol
  static String currencyWithSymbol(double amount, {String symbol = 'TRX'}) {
    return '${currency(amount)} $symbol';
  }

  // Format USD
  static String usd(double amount) {
    return NumberFormat('\$#,##0.00').format(amount);
  }

  // Format number
  static String number(num value, {int decimals = 0}) {
    return NumberFormat('#,##0.${'0' * decimals}').format(value);
  }

  // Format percentage
  static String percentage(double value, {int decimals = 0}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  // Format large numbers (K, M, B)
  static String compactNumber(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  // Format date
  static String date(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  // Format date with time
  static String dateTime(DateTime date, {String format = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(format).format(date);
  }

  // Format time ago
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  // Format TRON address (truncate middle)
  static String tronAddress(String address, {int startChars = 6, int endChars = 4}) {
    if (address.length <= startChars + endChars) {
      return address;
    }
    return '${address.substring(0, startChars)}...${address.substring(address.length - endChars)}';
  }

  // Format duration from hours
  static String duration(int hours) {
    if (hours < 24) {
      return '$hours ${hours == 1 ? 'Hour' : 'Hours'}';
    } else {
      final days = hours ~/ 24;
      return '$days ${days == 1 ? 'Day' : 'Days'}';
    }
  }

  // Format file size
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
