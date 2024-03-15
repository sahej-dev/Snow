import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './constants.dart';
import './models/models.dart';

enum ContestsLoadStatus { success, fail, unknown }

class ContestsRepository {
  static final Uri _apiUri = Uri.parse(ApiConstants.apiUrl);

  List<Contest>? _contestsList;
  ContestsLoadStatus onlineLoadStatus = ContestsLoadStatus.unknown;
  ContestsLoadStatus cacheLoadStatus = ContestsLoadStatus.unknown;

  /// Fetches contests from local cache and api and returns them
  Future<List<Contest>?> getContestsList({
    bool forceNetworkFetch = false,
  }) async {
    if (!forceNetworkFetch &&
        onlineLoadStatus == ContestsLoadStatus.success &&
        _contestsList != null) return _contestsList;

    await _buildContestsList();

    // cacheContests();

    _contestsList?.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

    if (_contestsList != null) {
      _contestsList = _removeEndedContests(_contestsList!);
      _contestsList = _fixContestsStatuses(_contestsList!);
    }

    return _contestsList;
  }

  Future<void> _buildContestsList() async {
    List<Contest>? apiContests = await _loadGetOnlineContests();
    List<Contest>? cachedContests = await _loadGetCachedContests();
    _deleteExpiredCachedContests(cachedContests);

    onlineLoadStatus = apiContests == null
        ? ContestsLoadStatus.fail
        : ContestsLoadStatus.success;

    cacheLoadStatus = cachedContests == null
        ? ContestsLoadStatus.fail
        : ContestsLoadStatus.success;

    if (onlineLoadStatus == ContestsLoadStatus.fail ||
        cacheLoadStatus == ContestsLoadStatus.fail) {
      _contestsList = apiContests ?? cachedContests;
      return;
    }

    if (_contestsList == null) {
      _contestsList = [];
    } else {
      _contestsList!.clear();
    }

    Map<String, bool> cachedFavMap = HashMap()
      ..addEntries(
          cachedContests!.map((c) => MapEntry(c.uniqueStr, c.isFavorite)));

    List<Contest> newApiContests = apiContests!
        .where((c) => !cachedFavMap.containsKey(c.uniqueStr))
        .toList();

    List<Contest> oldApiContests = apiContests
        .where((c) => cachedFavMap.containsKey(c.uniqueStr))
        .toList();

    _contestsList!.addAll(newApiContests);

    for (Contest apiContest in oldApiContests) {
      // Add with newly fetched details and old cached ID.

      Contest toBeAddedContest = Contest.withIdAndFav(
        cachedContests
            .firstWhere((c) => c.uniqueStr == apiContest.uniqueStr)
            .id,
        cachedFavMap[apiContest.uniqueStr] ?? false,
        apiContest,
      );

      _contestsList!.add(toBeAddedContest);
    }
  }

  List<Contest> _removeEndedContests(List<Contest> contests) {
    final DateTime now = DateTime.now();

    return contests
        .where((contest) => contest.endDateTime.isAfter(now))
        .toList();
  }

  List<Contest> _fixContestsStatuses(List<Contest> contests) {
    final DateTime now = DateTime.now();
    final DateTime aDayFromNow = now.add(const Duration(days: 1));
    final List<Contest> res = [];

    contests.forEach((contest) {
      if (contest.startDateTime.isBefore(now)) {
        if (contest.endDateTime.isAfter(now)) {
          res.add(contest.copyWith(status: ContestStatus.onGoing));
        }
      } else {
        if (contest.startDateTime.isBefore(aDayFromNow)) {
          res.add(contest.copyWith(status: ContestStatus.upcomingIn24Hrs));
        } else {
          res.add(contest.copyWith(status: ContestStatus.upcoming));
        }
      }
    });

    return res;
  }

  Future<List<Contest>?> _loadGetOnlineContests() async {
    late http.Response response;
    try {
      response = await http.get(_apiUri).timeout(
            Duration(seconds: 15),
          );
    } catch (e) {
      return null;
    }

    if (response.statusCode != 200) {
      return null;
    }

    List<Contest> contestsList = [];
    List<dynamic> rawContests = jsonDecode(response.body);

    for (Map<String, dynamic> rawContest in rawContests) {
      try {
        contestsList.add(Contest.fromApiContest(rawContest));
      } catch (e) {
        log(e.toString());
      }
    }

    return contestsList;
  }

  Future<List<Contest>?> _loadGetCachedContests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Contest> cachedContests = [];

    List<String>? uuids =
        await prefs.getStringList(LocalStorageConsts.contestsIdsStoreKey);

    if (uuids == null) {
      return null;
    }

    for (int i = 0; i < uuids.length; i++) {
      String? contestsString = prefs.getString(uuids[i]);
      if (contestsString == null) {
        continue;
      }
      // TODO: update Contest.status for loaded contests
      Contest c = Contest.fromJson(jsonDecode(contestsString));
      cachedContests.add(Contest.withIdAndFav(uuids[i], c.isFavorite, c));
    }
    return cachedContests;
  }

  Future<void> _deleteExpiredCachedContests(
    List<Contest>? allCachedContests,
  ) async {
    List<Contest>? expiredContests = allCachedContests
        ?.where((contest) => contest.endDateTime.compareTo(DateTime.now()) <= 0)
        .toList();

    _deleteCachedContests(
        expiredContests?.map((c) => c.id).toList() ?? const []);
  }

  Future<void> _deleteCachedContests(List<String> uuids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String id in uuids) {
      await prefs.remove(id);
    }
  }

  Future<void> cacheContests() async {
    if (_contestsList == null) {
      return;
    }
    log('cache started', name: 'cache');

    final Future<SharedPreferences> tempPrefs = SharedPreferences.getInstance();
    List<String> uuids = _contestsList!.map((contest) => contest.id).toList();
    final SharedPreferences prefs = await tempPrefs;

    bool everythingAlright = true;
    everythingAlright = await prefs.setStringList(
        LocalStorageConsts.contestsIdsStoreKey, uuids);
    if (!everythingAlright) return;

    for (int i = 0; i < uuids.length; i++) {
      everythingAlright = await prefs.setString(
          uuids[i], jsonEncode(_contestsList![i].toJson()));
      if (!everythingAlright) return;
    }
    log('cache ended', name: 'cache');
  }

  void setFavoriteStatus(String contestId, bool favStatus) async {
    if (_contestsList == null) return;

    int contestIdx = _contestsList!.indexWhere((c) => c.id == contestId);
    _contestsList![contestIdx] =
        Contest.withToggledFav(_contestsList![contestIdx]);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        contestId, jsonEncode(_contestsList![contestIdx].toJson()));
  }
}
