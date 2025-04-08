import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/presentation/jobs/saved_jobs.dart';
import 'package:job_board/providers/jobs_provider.dart';
import '../../providers/theme_provider.dart';
import 'job_details.dart';

class Jobs extends ConsumerWidget {
  Jobs({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobState = ref.watch(jobNotifierProvider);
    final jobNotifier = ref.read(jobNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedJobsScreen()),
                ),
          ),
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).state =
                  themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
        ],
      ),
      body: jobState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Text("Error: $error", style: theme.textTheme.bodyMedium),
            ),
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Text(
                "No jobs available.",
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          return _JobList(jobs: jobs);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Job"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Enter Title",
                      ),
                    ),
                    TextFormField(
                      controller: companyController,
                      decoration: const InputDecoration(
                        labelText: "Enter Company",
                      ),
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: "Enter Location",
                      ),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Enter Description",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty &&
                          companyController.text.trim().isNotEmpty &&
                          locationController.text.trim().isNotEmpty &&
                          descriptionController.text.trim().isNotEmpty) {
                        jobNotifier.addJob(
                          JobModel(
                            title: titleController.text,
                            company: companyController.text,
                            location: locationController.text,
                            description: descriptionController.text,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _JobList extends ConsumerWidget {
  final List<JobModel> jobs;

  const _JobList({required this.jobs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(job.title, style: theme.textTheme.titleMedium),
          subtitle: Text(job.company, style: theme.textTheme.bodyMedium),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobDetails(id: job.id)),
            );
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }
}
