
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/presentation/jobs/job_details.dart';
import 'package:job_board/providers/job_details_provider.dart';


final mockJob = JobModel(id: '1', title: 'Flutter Dev', company: 'X', location: 'Remote', description: 'sample');

void main(){

  testWidgets("display loading indicator while loading", (WidgetTester tester) async {
    final completer = Completer<JobModel>();
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            jobDetailsProvider.overrideWith((ref,id)=>completer.future)
          ],
          child: const MaterialApp(home: JobDetails(id: "1"),))

    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("display error message on failure", (WidgetTester tester) async {
    await tester.pumpWidget(
        ProviderScope(
            overrides: [
              jobDetailsProvider.overrideWith((ref,id) async => throw Exception("Failed To Load"))
            ],
            child: const MaterialApp(home: JobDetails(id: "1"),))

    );
    await tester.pumpAndSettle();
    expect(find.textContaining("Failed To Load"), findsOneWidget);
  });
  testWidgets('displays job details when data is available', (
      WidgetTester tester,
      ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobDetailsProvider.overrideWith((ref, id) async => mockJob),
          ],
          child: const MaterialApp(home: JobDetails(id: "1")),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(mockJob.title), findsOneWidget);
      expect(find.text(mockJob.company), findsOneWidget);
      expect(find.text(mockJob.location), findsOneWidget);
      expect(find.text(mockJob.description), findsOneWidget);
  });
}