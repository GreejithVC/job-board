import 'package:job_board/models/job_model/job_model.dart';

import '../networks/api_handler.dart';
import '../networks/api_urls.dart';

class JobService {
  final ApiHandler apiHandler;

  JobService({ApiHandler? apiHandler})
    : apiHandler = apiHandler ?? ApiHandler();

  Future<List<JobModel>> fetchJobs({int page = 1}) async {
    final response = await apiHandler.get(url: ApiUrls.jobs);
    if (response is List) {
      return response.map((json) => JobModel.fromJson(json)).toList();
    } else {
      throw Exception("Invalid response format");
    }
  }


  Future<JobModel> createJob(JobModel job) async {
    final response = await apiHandler.post(
      url: ApiUrls.jobs,
      body: job.toJson(),
    );

    if (response is Map<String, dynamic>) {
      return JobModel.fromJson(response);
    } else {
      throw Exception("Failed to create job");
    }
  }

  Future<JobModel> fetchJobById(String id) async {
    final response = await apiHandler.get(url: "${ApiUrls.jobs}/$id");
    if (response is Map<String, dynamic>) {
      return JobModel.fromJson(response);
    } else {
      throw Exception("Invalid response format for single job details");
    }
  }


  Future<JobModel> updateJob({required int id, required JobModel user}) async {
    final response = await apiHandler.put(
      url: "${ApiUrls.jobs}/$id",
      body: user.toJson(),
    );

    if (response is Map<String, dynamic>) {
      return JobModel.fromJson(response);
    } else {
      throw Exception("Failed to update job");
    }
  }

  Future<bool> deleteJob(String id) async {
    final response = await apiHandler.delete(url: "${ApiUrls.jobs}/$id");
    return response != null;
  }
}
