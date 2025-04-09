
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/presentation/jobs/job_details.dart';
import 'package:job_board/presentation/jobs/jobs.dart';
import 'package:job_board/providers/job_details_provider.dart';
import 'package:job_board/providers/jobs_provider.dart';
import 'package:job_board/services/jobs_service.dart';
import 'package:mocktail/mocktail.dart';

class MockJobService extends Mock implements JobService{}

class MockJobNotifier extends JobNotifier{}


void main(){
  late MockJobService mockJobService;
  late MockJobNotifier mockJobNotifier;
  late List<JobModel> mockJobs;

  final job1 = JobModel(id: '1', title: 'Flutter Dev', company: 'X', location: 'Remote', description: 'sample');
  final job2 = JobModel(id: '2', title: 'Backend Dev', company: 'Y', location: 'Hybrid', description: 'sample');
  final job3 = JobModel(id: '3', title: 'Fullstack Dev', company: 'Z', location: 'Onsite', description: 'sample');

  setUp((){
    mockJobNotifier =MockJobNotifier();
    mockJobService = MockJobService();
    mockJobs = [job1,job2,job3];
  });
  setUpAll(() {
    registerFallbackValue(JobModel(company:"" ,location:"",title:"l", description: "", id: ""));
  });
  Widget createTestWidget() {
    mockJobNotifier.jobService = mockJobService;
    return ProviderScope(
      overrides: [jobNotifierProvider.overrideWith(() => mockJobNotifier)],
      child: MaterialApp(home: Jobs()),
    );
  }
  Widget createTestWidgetForNavigation() {
     mockJobNotifier.jobService = mockJobService;
    return ProviderScope(
      overrides: [
        jobNotifierProvider.overrideWith(() => mockJobNotifier),
        jobDetailsProvider.overrideWith((ref, id) async => mockJobs.first),
      ],
      child: MaterialApp(
        home: Jobs(),
        routes: {"/job_details": (context) => const JobDetails(id: "1")},
      ),
    );
  }

  testWidgets("Displays loading indicator while fetching jobs", (
      WidgetTester tester,
      ) async {
    when(() => mockJobService.fetchJobs(page: 1)).thenAnswer((_) async => []);
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Displays error message when fetching jobs fails", (
      WidgetTester tester,
      ) async {
    when(
          () => mockJobService.fetchJobs(page: 1),
    ).thenThrow(Exception("Failed to fetch jobs"));
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();
    expect(
      find.text("Error: Exception: Failed to fetch jobs"),
      findsOneWidget,
    );
  });

  testWidgets("Displays jobs after fetching", (WidgetTester tester) async {
      when(
            () => mockJobService.fetchJobs(page: 1),
      ).thenAnswer((_) async => mockJobs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Flutter Dev"), findsOneWidget);
      expect(find.text("Backend Dev"), findsOneWidget);
      expect(find.text("Fullstack Dev"), findsOneWidget);
  });
  testWidgets("Can add a new jobs", (WidgetTester tester) async {

      when(
            () => mockJobService.fetchJobs(page: 1),
      ).thenAnswer((_) async => [job1]);
      when(
            () => mockJobService.createJob(any()),
      ).thenAnswer((_) async => job2);

      await tester.pumpWidget(createTestWidget());

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), job2.title);
      await tester.enterText(find.byType(TextFormField).at(1), job2.company);
      await tester.enterText(find.byType(TextFormField).at(2), job2.location);
      await tester.enterText(find.byType(TextFormField).at(3), job2.description);
      await tester.tap(find.text("Add"));
      await tester.pumpAndSettle();

      verify(() => mockJobService.createJob(any())).called(1);
      await tester.pumpAndSettle();
      expect(find.text(job2.title), findsOneWidget);
      expect(find.text(job2.company), findsOneWidget);
  });
  testWidgets("Navigates to JobDetails screen on tap", (
      WidgetTester tester,
      ) async {
    when(()=>mockJobService.fetchJobs(page: 1),).thenAnswer((_) async => mockJobs);
    await tester.pumpWidget(createTestWidgetForNavigation());
    await tester.pumpAndSettle();
    await tester.tap(find.text(job1.title));
    await tester.pumpAndSettle();
    expect(find.byType(JobDetails), findsOneWidget);
    expect(find.text(job1.title), findsOneWidget);
    expect(find.text(job1.company), findsOneWidget);
    expect(find.text(job1.location), findsOneWidget);
    expect(find.text(job1.description), findsOneWidget);
  });
}