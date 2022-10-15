import 'dart:collection';

import './models/models.dart';

class ApiParser {
  static final Map<String, Judge> _siteJudgeMap = HashMap()
    ..addAll({
      'CodeForces': Judge.codeforces,
      'CodeForces::Gym': Judge.others,
      'TopCoder': Judge.topCoder,
      'AtCoder': Judge.atCoder,
      'CS Academy': Judge.csAcademy,
      'CodeChef': Judge.codechef,
      'HackerRank': Judge.hackerRank,
      'HackerEarth': Judge.hackerEarth,
      'Kick Start': Judge.kickStart,
      'LeetCode': Judge.leetCode,
      'Toph': Judge.others
    });

  static DateTime strToLocalDateTime(String str) {
    late DateTime dateTime;

    if (str != '-') {
      // parsing to standard format
      if (str.contains('UTC')) {
        List<String> splittedTime = str.split(' ');
        str = splittedTime[0] + 'T' + splittedTime[1] + 'Z';
      }

      dateTime = DateTime.parse(str);
    } else {
      throw FormatException();
    }

    dateTime = dateTime.toLocal();
    return dateTime;
  }

  static Duration tryStrToDuration(String str) {
    late Duration duration;
    if (str != '-') {
      duration = Duration(
        seconds: double.parse(str).toInt(),
      );
    } else {
      throw FormatException();
    }
    return duration;
  }

  static ContestStatus apiResToStatus(String apiStatus, String apiIn24hrs) {
    apiStatus = apiStatus.toLowerCase();
    apiIn24hrs = apiIn24hrs.toLowerCase();

    if (apiStatus == 'coding') {
      return ContestStatus.onGoing;
    } else if (apiIn24hrs == 'yes') {
      return ContestStatus.upcomingIn24Hrs;
    } else if (apiStatus == 'before') {
      return ContestStatus.upcoming;
    }
    return ContestStatus.unknown;
  }

  static Judge siteToJudge(String site) {
    if (_siteJudgeMap.containsKey(site)) {
      return _siteJudgeMap[site]!;
    }
    return Judge.others;
  }
}
