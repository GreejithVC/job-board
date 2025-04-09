import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/presentation/jobs/saved_jobs.dart';
import 'package:job_board/providers/saved_job_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSavedJobsNotifier extends SavedJobsNotifier {
  final AsyncValue<List<JobModel>> stateToReturn;

  FakeSavedJobsNotifier(this.stateToReturn);

  @override
  Future<List<JobModel>> build() async {
    state = stateToReturn;
    return stateToReturn.value ?? [];
  }
}

void main() {
  late List<JobModel> mockJobs;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockJobs = [
      JobModel(id: '1', title: 'Flutter Dev', company: 'NNN', location: 'Remote', description: ' Sample'),
    ];
  });

  Widget createWidgetUnderTest(AsyncValue<List<JobModel>> fakeState) {
    return ProviderScope(
      overrides: [
        savedJobsProvider.overrideWith(() => FakeSavedJobsNotifier(fakeState)),
      ],
      child: const MaterialApp(home: SavedJobsScreen()),
    );
  }

  testWidgets('Displays loading indicator', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const AsyncLoading()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays error message', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(AsyncError('Something went wrong', StackTrace.empty)),
    );
    await tester.pump();
    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });

  testWidgets('Displays list of saved jobs', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncData(mockJobs)));
    await tester.pump();
    expect(find.text('Flutter Dev'), findsOneWidget);
    expect(find.text('NNN'), findsOneWidget);
  });
}
