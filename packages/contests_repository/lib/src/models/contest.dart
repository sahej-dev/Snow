import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils.dart';
import '../extensions.dart';

part 'contest.g.dart';

@JsonSerializable()
class Contest with EquatableMixin {
  static final Uuid uuidGen = Uuid();

  final String id;
  final String name;
  final Uri? link;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Duration duration;
  final Judge judge;
  final ContestStatus status;
  final bool _isFavorite;
  final String _uniqueStr;

  @override
  List<Object?> get props => [
        id,
        isFavorite,
        name,
        link,
        startDateTime,
        endDateTime,
        duration,
        judge,
        status,
      ];

  Contest({
    required this.name,
    required this.link,
    required this.startDateTime,
    required this.endDateTime,
    required this.duration,
    required this.judge,
    required this.status,
    bool isFavorite = false,
    String? uuid = null,
  })  : this.id = uuid ?? uuidGen.v4(),
        this._isFavorite = isFavorite,
        this._uniqueStr = '$name $link';

  /// Copy data from [contest] and return a new [Contest] object
  /// with [uuid] as id.
  factory Contest.withIdAndFav(String uuid, bool isFavorite, Contest contest) {
    return Contest(
        uuid: uuid,
        name: contest.name,
        link: contest.link,
        startDateTime: contest.startDateTime,
        endDateTime: contest.endDateTime,
        duration: contest.duration,
        judge: contest.judge,
        status: contest.status,
        isFavorite: isFavorite);
  }

  factory Contest.withToggledFav(Contest contest) {
    return Contest(
      uuid: contest.id,
      name: contest.name,
      link: contest.link,
      startDateTime: contest.startDateTime,
      endDateTime: contest.endDateTime,
      duration: contest.duration,
      judge: contest.judge,
      status: contest.status,
      isFavorite: !contest._isFavorite,
    );
  }

  factory Contest.fromApiContest(Map<String, dynamic> apiContest) {
    String name = apiContest['name'].toString().trim();
    Uri? uri = Uri.tryParse(apiContest['url']);
    DateTime startDateTime =
        ApiParser.strToLocalDateTime(apiContest['start_time']);
    DateTime endDateTime = ApiParser.strToLocalDateTime(apiContest['end_time']);
    Duration duration = ApiParser.tryStrToDuration(apiContest['duration']);
    ContestStatus status = ApiParser.apiResToStatus(
        apiContest['status'], apiContest['in_24_hours']);
    Judge judge = ApiParser.siteToJudge(apiContest['site']);

    if ((name.isEmpty || name.length <= 2) && judge == Judge.hackerEarth) {
      name = _contestNameFromLink(uri.toString(), judge);
      print(name);
    }

    return Contest(
      name: name,
      link: uri,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      duration: duration,
      judge: judge,
      status: status,
    );
  }

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);

  Map<String, dynamic> toJson() => _$ContestToJson(this);

  static String _contestNameFromLink(String link, Judge judge) {
    if (judge == Judge.hackerEarth) {
      List<String> splitList = link.split('/');
      String nameStr = splitList[splitList.length - 2];
      return nameStr.toTitleCase();
    }

    throw UnimplementedError();
  }

  /// Use to check if contest link or start/end timing has been updated.
  bool isSame(Contest other) {
    return link == other.link &&
        startDateTime == other.startDateTime &&
        endDateTime == other.endDateTime &&
        duration == other.duration;
  }

  String get uniqueStr => _uniqueStr;

  bool get isFavorite => _isFavorite;
}

enum Judge {
  codeforces,
  // codeforcesGym,
  topCoder,
  atCoder,
  csAcademy,
  codechef,
  hackerRank,
  hackerEarth,
  kickStart,
  leetCode,
  // toph,
  others,
}

enum ContestStatus {
  onGoing,
  upcoming,
  upcomingIn24Hrs,
  unknown,
}

// void main(List<String> args) async {
//   String link =
//       'https://www.hackerearth.com/challenges/hackathon/shift-hackathon-2022/';

//   List<String> splitList = link.split('/');
//   print(splitList);
//   String nameStr = splitList[splitList.length - 2];
//   List<String> nameList = splitList[splitList.length - 2].split('-');
//   print(nameStr.toTitleCase());

//   // -----------------------
//   // http.Response res =
//   //     await http.get(Uri.parse('https://kontests.net/api/v1/all'));

//   // List<dynamic> resJson = jsonDecode(res.body);
//   // List<Contest> contests =
//   //     resJson.map((c) => Contest.fromApiContest(c)).toList();

//   // Set<String> contestSet = Set();

//   // for (Contest contest in contests) {
//   //   if (contestSet.contains(contest.uniqueStr)) {
//   //     print(contest.toJson().toString());
//   //   }
//   //   print(contest.uniqueStr);
//   //   contestSet.add(contest.uniqueStr);
//   // }

//   // print(contests.length);
//   // print(contestSet.length);
// }
