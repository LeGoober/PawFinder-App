/// Formats a [DateTime] as a human-readable relative time string
/// like "2 hours ago", "3 days ago", etc.
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return '$m ${m == 1 ? 'min' : 'mins'} ago';
  }
  if (diff.inHours < 24) {
    final h = diff.inHours;
    return '$h ${h == 1 ? 'hour' : 'hours'} ago';
  }
  if (diff.inDays < 7) {
    final d = diff.inDays;
    return '$d ${d == 1 ? 'day' : 'days'} ago';
  }
  if (diff.inDays < 30) {
    final w = diff.inDays ~/ 7;
    return '$w ${w == 1 ? 'week' : 'weeks'} ago';
  }
  if (diff.inDays < 365) {
    final mo = diff.inDays ~/ 30;
    return '$mo ${mo == 1 ? 'month' : 'months'} ago';
  }
  final y = diff.inDays ~/ 365;
  return '$y ${y == 1 ? 'year' : 'years'} ago';
}
