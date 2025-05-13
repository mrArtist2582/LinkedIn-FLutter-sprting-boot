import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock jobs data
    final jobs = [
      {
        'id': '1',
        'title': 'Senior Flutter Developer',
        'company': 'Tech Corp',
        'location': 'San Francisco, CA',
        'type': 'Full-time',
        'salary': '\$120,000 - \$150,000',
        'description':
            'We are looking for an experienced Flutter developer to join our team...',
        'postedAt': DateTime.now().subtract(const Duration(days: 2)),
        'companyLogo': '',
      },
      {
        'id': '2',
        'title': 'Product Manager',
        'company': 'Innovate Inc',
        'location': 'Remote',
        'type': 'Full-time',
        'salary': '\$100,000 - \$130,000',
        'description':
            'Join our team as a Product Manager and help shape the future...',
        'postedAt': DateTime.now().subtract(const Duration(days: 5)),
        'companyLogo': '',
      },
      {
        'id': '3',
        'title': 'UI/UX Designer',
        'company': 'Design Studio',
        'location': 'New York, NY',
        'type': 'Contract',
        'salary': '\$80,000 - \$100,000',
        'description':
            'We are seeking a talented UI/UX designer to create beautiful...',
        'postedAt': DateTime.now().subtract(const Duration(days: 1)),
        'companyLogo': '',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
      
      ),
     
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index] as Map<String, dynamic>;
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
                        child: Text(job['company'][0].toUpperCase()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              job['company'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job['location'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.work,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job['type'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job['salary'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    job['description'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showJobDetails(context, job);
                          },
                          child: const Text('View Details'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showApplyDialog(context, job);
                          },
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
      ),
    );
  }

  void _showJobDetails(BuildContext context, Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                job['company'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(job['location']),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.work,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(job['type']),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                job['salary'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Job Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(job['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
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
            Text(
              job['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(job['company']),
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
          
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit Application'),
          ),
        ],
      ),
    );
  }
} 