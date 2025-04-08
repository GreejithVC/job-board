import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/providers/job_details_provider.dart';
import 'package:job_board/providers/jobs_provider.dart';
import 'package:job_board/services/jobs_service.dart';
import 'package:mocktail/mocktail.dart';

class MockJobService extends Mock implements JobService {}

void main() {
  late ProviderContainer container;
  late MockJobService mockService;

  const jobId = '1';
  final job = JobModel(
    id: jobId,
    title: 'Flutter Dev',
    company: 'XYZ',
    location: 'Remote',
    description: 'sample',
  );

  setUp(() {
    mockService = MockJobService();

    container = ProviderContainer(
      overrides: [
        jobServiceProvider.overrideWithValue(mockService),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('jobDetailsProvider returns job by id', () async {
    when(() => mockService.fetchJobById(jobId)).thenAnswer((_) async => job);

    final asyncValue = await container.read(jobDetailsProvider(jobId).future);

    expect(asyncValue, equals(job));
    verify(() => mockService.fetchJobById(jobId)).called(1);
  });

  test('jobDetailsProvider throws error when fetch fails', () async {
    when(() => mockService.fetchJobById(jobId)).thenThrow(Exception('Failed'));

    final future = container.read(jobDetailsProvider(jobId).future);

    expect(future, throwsA(isA<Exception>()));
  });
}
