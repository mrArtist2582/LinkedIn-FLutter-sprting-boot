// ignore: unused_import
import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:linked_in/providers/job_provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> with TickerProviderStateMixin {
  late Future<void> _jobsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _jobsFuture = Provider.of<JobProvider>(context, listen: false).fetchJobs();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _handleRefresh() async {
    await Provider.of<JobProvider>(context, listen: false).fetchJobs();
  }

  Widget _buildJobList(List<Map<String, dynamic>> jobs, bool isAppliedJobs) {
    if (jobs.isEmpty) {
      return const Center(child: Text("No jobs found."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        (job['company'] ?? 'C')[0].toUpperCase(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            job['company'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      job['location'] ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.work, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      job['type'] ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  job['salary'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                Text(
                  job['description'] ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                if (isAppliedJobs)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Provider.of<JobProvider>(context, listen: false)
                                  .removeAppliedJob(job),
                          child: const Text('Remove'),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showJobDetails(context, job),
                          child: const Text('View Details'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showApplyDialog(context, job),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Jobs'),
            Tab(text: 'Applied Jobs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: Theme.of(context).primaryColor,
            height: 150,
            showChildOpacityTransition: false,
            child: FutureBuilder(
              future: _jobsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Consumer<JobProvider>(
                  builder: (context, jobProvider, _) {
                    return _buildJobList(jobProvider.jobs, false);
                  },
                );
              },
            ),
          ),
          Consumer<JobProvider>(
            builder: (context, jobProvider, _) {
              return _buildJobList(jobProvider.appliedJobs, true);
            },
          ),
        ],
      ),
    );
  }

  void _showJobDetails(BuildContext context, Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job['title'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job['company'] ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(job['location'] ?? ''),
                  const SizedBox(width: 16),
                  Icon(Icons.work, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(job['type'] ?? ''),
                ],
              ),
              const SizedBox(height: 8),
              Text(job['salary'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 16),
              const Text('Job Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(job['description'] ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showApplyDialog(context, job);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context, Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Job'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['title'] ?? '',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            Text(job['company'] ?? ''),
            const SizedBox(height: 16),
            const Text(
              'Your application will be sent to the employer. Make sure your profile is up to date.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Provider.of<JobProvider>(context, listen: false).applyForJob(job);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Application submitted successfully!'),
                    backgroundColor: Colors.green),
              );
              _tabController.animateTo(1);
            },
            child: const Text('Submit Application'),
          ),
        ],
      ),
    );
  }
}