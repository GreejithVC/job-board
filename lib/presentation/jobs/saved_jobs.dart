import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/saved_job_provider.dart';
import 'job_details.dart';

class SavedJobsScreen extends ConsumerWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobsAsync = ref.watch(savedJobsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Jobs")),
      body: savedJobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Text(
                "Error: $error",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Text(
                "No Saved Jobs Are available.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  job.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  job.company,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetails(id: job.id),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 1),
          );
        },
      ),
    );
  }
}
