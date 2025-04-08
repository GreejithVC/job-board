import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/networks/api_handler.dart';
import 'package:job_board/services/jobs_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiHandler extends Mock implements ApiHandler {}

void main() {
  final MockApiHandler mockApiHandler = MockApiHandler();

  final JobService jobService = JobService(apiHandler: mockApiHandler);

  final jobJson = {
    "id": "1",
    "title": "Flutter Dev",
    "company": "XYZ",
    "location": "Remote",
    "description": "sample",
  };
  final jobModel = JobModel.fromJson(jobJson);

  test("fetch jobs successfully", () async {
    when(
      () => mockApiHandler.get(url: any(named: "url")),
    ).thenAnswer((_) async => [jobJson]);
    final result = await jobService.fetchJobs(page: 1);
    expect(result, [jobModel]);
  });

  test("fetch jobs error", () async {
    when(
      () => mockApiHandler.get(url: any(named: "url")),
    ).thenThrow(Exception("Failed to fetch jobs"));
    expect(
      () async => await jobService.fetchJobs(page: 1),
      throwsA(isA<Exception>()),
    );
  });
  test("create job successfully", () async {
    when(
      () =>
          mockApiHandler.post(url: any(named: "url"), body: any(named: "body")),
    ).thenAnswer((_) async => jobJson);
    final result = await jobService.createJob(jobModel);
    expect(result, jobModel);
  });

  test("create job error", () async {
    when(
      () =>
          mockApiHandler.post(url: any(named: "url"), body: any(named: "body")),
    ).thenThrow(Exception("Failed to Create jobs"));
    expect(
      () async => await jobService.createJob(jobModel),
      throwsA(isA<Exception>()),
    );
  });

  test("fetch job by id successfully", () async {
    when(
      () => mockApiHandler.get(url: any(named: "url")),
    ).thenAnswer((_) async => jobJson);
    final result = await jobService.fetchJobById("1");
    expect(result, jobModel);
  });

  test("fetch job by id error", () async {
    when(
      () => mockApiHandler.get(url: any(named: "url")),
    ).thenThrow(Exception("Failed to fetch job details"));
    expect(
      () async => await jobService.fetchJobById("1"),
      throwsA(isA<Exception>()),
    );
  });
  test("fetch job by id - invalid response format", () async {
    when(
      () => mockApiHandler.get(url: any(named: "url")),
    ).thenAnswer((_) async => ["unexpected"]);

    expect(
      () => jobService.fetchJobById("1"),
      throwsA(
        predicate(
          (e) =>
              e is Exception &&
              e.toString().contains(
                "Invalid response format for single job details",
              ),
        ),
      ),
    );
  });
  test("fetch jobs - invalid response format", () async {
    when(
      () => mockApiHandler.get(url: any(named: "url")),
    ).thenAnswer((_) async => {"unexpected": "structure"});

    expect(
      () => jobService.fetchJobs(page: 1),
      throwsA(
        predicate(
          (e) =>
              e is Exception &&
              e.toString().contains("Invalid response format"),
        ),
      ),
    );
  });
}
