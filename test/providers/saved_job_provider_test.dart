


import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/models/job_model/job_model.dart';
import 'package:job_board/providers/saved_job_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
 late  ProviderContainer container ;
 const job = JobModel(id: '1', title: 'Flutter Dev', company: 'XYZ', location: 'Remote', description: 'sample');
 
 setUp((){
   SharedPreferences.setMockInitialValues({});
   container = ProviderContainer();
 });

 tearDown((){
   container.dispose();
 });

 test('loads empty initially when no saved jobs exist', () async {
   final saved = await container.read(savedJobsProvider.future);
   expect(saved, isEmpty);
 });
 test('loads saved jobs from SharedPreferences', () async {
   final prefs = await SharedPreferences.getInstance();
   final encoded = jsonEncode([job.toJson()]);
   await prefs.setString('saved_jobs', encoded);

   final saved = await container.read(savedJobsProvider.future);
   expect(saved, equals([job]));
 });


 test("toggles - adds job if not present", () async {
   final notifier = container.read(savedJobsProvider.notifier);
   await notifier.toggle(job);
   final updated = container.read(savedJobsProvider);
   expect((updated as AsyncData).value, [job]);
   final prefs = await SharedPreferences.getInstance();
   final stored = prefs.getString("saved_jobs");
   final storedList = (jsonDecode(stored!) as List)
       .map((e) => JobModel.fromJson(e))
       .toList();
   expect(storedList, [job]);
 });

 test("toggles - remove job if  present", () async {
   final notifier = container.read(savedJobsProvider.notifier);
   await notifier.toggle(job);
   await notifier.toggle(job);
   final updated = container.read(savedJobsProvider);
   expect((updated as AsyncData).value, []);
   final prefs = await SharedPreferences.getInstance();
   final stored = prefs.getString("saved_jobs");
   final storedList = (jsonDecode(stored!) as List)
       .map((e) => JobModel.fromJson(e))
       .toList();
   expect(storedList, [ ]);
 });


}

