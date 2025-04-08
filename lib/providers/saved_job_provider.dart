import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_model/job_model.dart';

final savedJobsProvider =
AsyncNotifierProvider<SavedJobsNotifier, List<JobModel>>(SavedJobsNotifier.new);

class SavedJobsNotifier extends AsyncNotifier<List<JobModel>> {
  static const _key = 'saved_jobs';

  @override
  Future<List<JobModel>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJson = prefs.getString(_key);

    if (savedJson != null) {
      final current = (jsonDecode(savedJson) as List)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return current;
    }

    return [];
  }

  Future<void> toggle(JobModel job) async {
    final prefs = await SharedPreferences.getInstance();
    final current = state.value ?? [];

    final isAlreadySaved = current.any((j) => j.id == job.id);
    final updated = isAlreadySaved
        ? current.where((j) => j.id != job.id).toList()
        : [...current, job];

    await prefs.setString(_key, jsonEncode(updated.map((j) => j.toJson()).toList()));
    state = AsyncData(updated);
  }
}
