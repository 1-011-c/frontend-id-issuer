import 'package:meta/meta.dart';

enum CoronaStatus {
  NOT_TESTED,
  IN_PROGRESS,
  POSITIVE,
  NEGATIVE
}

CoronaStatus getCoronaStatusFromString(String status) {
  status = 'CoronaStatus.$status';
  return CoronaStatus.values.firstWhere((f)=> f.toString() == status, orElse: () => null);
}

class CoronaTestCase {
  final String uuidRead;
  final String uuidWrite;
  final CoronaStatus infected;
  final String date;

  const CoronaTestCase({
    @required this.uuidRead,
    @required this.uuidWrite,
    @required this.infected,
    @required this.date
  });

  factory CoronaTestCase.fromJson(Map<String, dynamic> json) {
    return new CoronaTestCase(
        uuidRead: json["uuid_read"],
        uuidWrite: json["uuid_write"],
        infected: getCoronaStatusFromString(json["infected"]),
        date: json["date"]
    );
  }
}