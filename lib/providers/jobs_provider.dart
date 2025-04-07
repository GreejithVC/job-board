import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_board/models/job_model/job_model.dart';

import '../services/jobs_service.dart';

final jobServiceProvider = Provider<JobService>((ref) {
  return JobService();
});

class JobNotifier extends AsyncNotifier<List<JobModel>> {
  JobService _jobService = JobService();

  @visibleForTesting
  set jobService(JobService value) {
    _jobService = value;
  }

  @override
  Future<List<JobModel>> build() async {
    return await _jobService.fetchJobs(page: 1);
  }

  Future<void> fetchJobs({int page = 1}) async {
    state = const AsyncLoading();
    try {
      final users = await _jobService.fetchJobs(page: page);
      state = AsyncData(users);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addJob(JobModel job) async {
    final currentState = state;
    state = const AsyncLoading();
    try {
      final created = await _jobService.createJob(job);


      if (currentState is AsyncData<List<JobModel>>) {
        final value = currentState.value;
        state = AsyncData([...value, created]);
      } else {
        state = AsyncData([created]);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteJob(String id) async {
    final currentState = state;

    state = const AsyncLoading();

    try {
      await _jobService.deleteJob(id);

      if (currentState case AsyncData(:final value)) {
        state = AsyncData(value.where((user) => user.id != id).toList());
      } else {
        state = const AsyncData([]);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void updateJob(JobModel updatedJob) {
    if (state case AsyncData(:final value)) {
      state = AsyncData([
        for (final user in value)
          if (user.id == updatedJob.id) updatedJob else user,
      ]);
    }
  }
}

final jobNotifierProvider = AsyncNotifierProvider<JobNotifier, List<JobModel>>(
  () => JobNotifier(),
);
final jobDetailsProvider = FutureProvider.family<JobModel, String>((ref, id) async {
  final jobService = ref.watch(jobServiceProvider);
  return jobService.fetchJobById(id);
});
