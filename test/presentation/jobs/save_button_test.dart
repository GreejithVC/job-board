import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/presentation/jobs/save_button.dart';
import 'package:job_board/providers/saved_job_provider.dart';

class FakeSavedJobsNotifier extends SavedJobsNotifier {
  final List<JobModel> initial;
  bool toggleCalled = false;

  FakeSavedJobsNotifier({this.initial = const []});

  @override
  Future<List<JobModel>> build() async {
    return initial;
  }

  @override
  Future<void> toggle(JobModel job) async {
    toggleCalled = true;
    // We won't simulate the internal state update because it's not needed here
  }
}

void main() {
  final job = JobModel(
    id: '1',
    title: 'Flutter Dev',
    company: 'X Corp',
    location: 'Remote',
    description: 'Build apps',
  );

  testWidgets('Displays bookmark_border if job not saved', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          savedJobsProvider.overrideWith(() => FakeSavedJobsNotifier(initial: [])),
        ],
        child: MaterialApp(home: SaveButton(job: job)),
      ),
    );

    await tester.pump(); // wait for AsyncNotifier build
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
  });

  testWidgets('Displays bookmark if job is saved', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          savedJobsProvider.overrideWith(() => FakeSavedJobsNotifier(initial: [job])),
        ],
        child: MaterialApp(home: SaveButton(job: job)),
      ),
    );

    await tester.pump();
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  testWidgets('Toggles job when button tapped', (tester) async {
    final fakeNotifier = FakeSavedJobsNotifier(initial: []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          savedJobsProvider.overrideWith(() => fakeNotifier),
        ],
        child: MaterialApp(home: SaveButton(job: job)),
      ),
    );

    await tester.pump(); // wait for state to load
    await tester.tap(find.byType(IconButton));
    expect(fakeNotifier.toggleCalled, isTrue);
  });
}
