import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/presentation/jobs/save_button.dart';

import '../../providers/jobs_provider.dart';

class JobDetails extends ConsumerWidget {
  final String id;

  const JobDetails({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<JobModel> jobDetails = ref.watch(jobDetailsProvider(id));
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(jobDetailsProvider(id).future),
        child: jobDetails.when(
          data: (data) {
            return ListView(
              padding: EdgeInsets.all(12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        data.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SaveButton(job: data),
                  ],
                ),
                Text(
                  data.company,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                Text(
                  data.location,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 6),
                Divider(height: 1, color: Colors.grey),
                SizedBox(height: 6),

                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.left,
                ),
              ],
            );
          },
          error: (error, stk) {
            return Text(
              error.toString(),
              style: Theme.of(context).textTheme.labelLarge,
            );
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
