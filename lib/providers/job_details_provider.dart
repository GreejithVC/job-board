import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/job_model/job_model.dart';
import 'jobs_provider.dart';

final jobDetailsProvider = FutureProvider.family<JobModel, String>((
    ref,
    id,
    ) async {
  final jobService = ref.watch(jobServiceProvider);
  return jobService.fetchJobById(id);
});