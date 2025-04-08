import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/providers/jobs_provider.dart';
import 'package:job_board/services/jobs_service.dart';
import 'package:mocktail/mocktail.dart';


class MockJobService extends Mock implements JobService {}

void main() {
  late ProviderContainer container;
  late MockJobService mockService;

  final job1 = JobModel(id: '1', title: 'Flutter Dev', company: 'X', location: 'Remote', description: 'sample');
  final job2 = JobModel(id: '2', title: 'Backend Dev', company: 'Y', location: 'Hybrid', description: 'sample');
  final job3 = JobModel(id: '3', title: 'Fullstack Dev', company: 'Z', location: 'Onsite', description: 'sample');

  setUp(() {
    mockService = MockJobService();

    container = ProviderContainer(
      overrides: [
        jobNotifierProvider.overrideWith(() {
          final notifier = JobNotifier()..jobService = mockService;
          return notifier;
        }),
      ],
    );
  });

  tearDown(() => container.dispose());

  void expectData<T>(AsyncValue<T> actual, T expected) {
    expect(actual, isA<AsyncData<T>>());
    expect((actual as AsyncData<T>).value, expected);
  }


  test('build() should return jobs list', () async {
    when(() => mockService.fetchJobs(page: 1)).thenAnswer((_) async => [job1, job2,job3]);

    final jobs = await container.read(jobNotifierProvider.future);

    expect(jobs, [job1, job2,job3]);
    verify(() => mockService.fetchJobs(page: 1)).called(1);
  });

  test('fetchJobs successfully', () async {
    when(() => mockService.fetchJobs(page: 1)).thenAnswer((_) async => [job1]);

    final notifier = container.read(jobNotifierProvider.notifier);
    await notifier.fetchJobs(page: 1);

    expectData(container.read(jobNotifierProvider), [job1]);


  });
  test('fetchJobs error handling', () async {
    when(() => mockService.fetchJobs(page: 1)).thenThrow(Exception("Failed to fetch jobs"));

    final notifier = container.read(jobNotifierProvider.notifier);
    await notifier.fetchJobs(page: 1);
    expect(container.read(jobNotifierProvider).error, isA<Exception>());
  });

  test('addJob() successfully', () async {
    when(() => mockService.fetchJobs(page: 1)).thenAnswer((_) async => [job1]);
    when(() => mockService.createJob(job2)).thenAnswer((_) async => job2);

    final notifier = container.read(jobNotifierProvider.notifier);
    await notifier.build();
    await notifier.addJob(job2);
    expectData(container.read(jobNotifierProvider), [job1, job2]);
  });





  test('addJob() should emit error state on failure', () async {
    when(() => mockService.fetchJobs(page: 1)).thenAnswer((_) async => []);
    when(() => mockService.createJob(job3)).thenThrow(Exception('Create failed'));

    final notifier = container.read(jobNotifierProvider.notifier);
    await notifier.build();
    await notifier.addJob(job3);

    expect(container.read(jobNotifierProvider), isA<AsyncError>());
  });


}
