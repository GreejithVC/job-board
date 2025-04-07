import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/providers/jobs_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text("Jobs")),
      body: jobState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error",style: Theme.of(context).textTheme.bodyMedium)),
        data: (jobs) {
          if (jobs.isEmpty) {
            return  Center(
              child: Text("No jobs available.",style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add  Job"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Enter Title"),
                    ),
                    TextFormField(
                      controller: companyController,
                      decoration: InputDecoration(labelText: "Enter Company"),
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: "Enter Location"),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Enter Description",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty &&
                          companyController.text.trim().isNotEmpty &
                              locationController.text.trim().isNotEmpty &
                              descriptionController.text.trim().isNotEmpty) {
                        jobNotifier.addJob(
                          JobModel(
                            title: titleController.text,
                            company: companyController.text,
                            location: locationController.text,
                            description: descriptionController.text,
                          ),
                        );
                      }
                    },
                    child: Text("add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
