import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/job_model/job_model.dart';
import '../../providers/saved_job_provider.dart';

class SaveButton extends ConsumerWidget {
  final JobModel job;

  const SaveButton({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobs = ref.watch(savedJobsProvider);
    final isSaved = savedJobs.maybeWhen(
      data: (jobs) => jobs.any((j) => j.id == job.id),
      orElse: () => false,
    );
    return IconButton(
      icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () {
        ref.read(savedJobsProvider.notifier).toggle(job);
      },
    );
  }
}
