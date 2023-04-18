import 'dart:collection';

// class Event {
//   final String title;
//   const Event(this.title);
//   @override
//   String toString() => title;
// }

/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.

final kEvents = <DateTime, List>{}..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(10, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, 10): List.generate(
      11,
      (index) => ('0$item:$index'),
    )
}..addAll({
    kToday: [
      // Event('08:00'),
      // Event('09:00'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 1, kToday.day);
