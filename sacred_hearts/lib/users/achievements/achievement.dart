import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sacred_hearts/api_connection/api_connection.dart';
import 'dart:convert';
import 'package:sacred_hearts/users/achievements/viewAchievements.dart';

class AchievementScreen extends StatefulWidget {
  final String userId;

  AchievementScreen({required this.userId});

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final List<String> _categories = [
    'Religious and Spiritual Contributions',
    'Academic Achievements',
    'Social and Humanitarian Work',
    'Institutional and Administrative Roles',
    'Cultural and Artistic Contributions',
  ];

  final Map<String, List<String>> _subGroups = {
    'Religious and Spiritual Contributions': [
      'Leadership Roles',
      'Spiritual Guidance',
      'Community Service',
    ],
    'Academic Achievements': [
      'Degrees Earned',
      'Teaching and Research',
      'Awards and Honors',
    ],
    'Social and Humanitarian Work': [
      'Healthcare Contributions',
      'Education Initiatives',
      'Advocacy',
    ],
    'Institutional and Administrative Roles': [
      'Leadership in Religious Institutions',
      'Project Management',
      'Organizational Development',
    ],
    'Cultural and Artistic Contributions': [
      'Art and Music',
      'Cultural Preservation',
      'Performing Arts',
    ],
  };

  final Map<String, String> _subGroupDescriptions = {
    'Leadership Roles': 'Positions held within the religious community, such as Mother Superior or Prioress.',
    'Spiritual Guidance': 'Roles in providing spiritual direction, retreats, or counseling.',
    'Community Service': 'Involvement in religious missions, charity work, and outreach programs.',
    'Degrees Earned': 'Educational qualifications like Bachelor\'s, Master\'s, or Doctorate degrees.',
    'Teaching and Research': 'Academic positions held and contributions to research in theology or other fields.',
    'Awards and Honors': 'Academic recognitions received.',
    'Healthcare Contributions': 'Work in healthcare, especially in underserved areas or missions.',
    'Education Initiatives': 'Founding or running schools, orphanages, or educational programs.',
    'Advocacy': 'Involvement in social justice, human rights, or environmental causes.',
    'Leadership in Religious Institutions': 'Administrative roles in convents, monasteries, or related institutions.',
    'Project Management': 'Leading significant projects, such as building new facilities or developing programs.',
    'Organizational Development': 'Contributions to the growth and development of religious institutions.',
    'Art and Music': 'Contributions to religious art, music, or liturgical design.',
    'Cultural Preservation': 'Efforts to preserve religious or cultural heritage.',
    'Performing Arts': 'Involvement in choir, theater, or other religious performances.',
  };

  String? _selectedCategory;
  String? _selectedSubGroup;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subGroupController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _addAchievement() async {
    final url = Uri.parse('${API.addAchievement}?user_id=${widget.userId}');
    final response = await http.post(
      url,
      body: {
        'category': _selectedCategory ?? '',
        'sub_group': _selectedSubGroup ?? '',
        'title': _titleController.text,
        'date': _dateController.text,
        'description': _descriptionController.text,
      },
    );

    try {
      final responseBody = response.body;
      final responseData = json.decode(responseBody);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Achievement added successfully!')),
        );
        // Optionally clear the form fields
        setState(() {
          _selectedCategory = null;
          _selectedSubGroup = null;
          _titleController.clear();
          _subGroupController.clear();
          _dateController.clear();
          _descriptionController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add achievement.')),
        );
      }
    } catch (e) {
      // Handle JSON decode errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing response: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              ),
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedSubGroup = null;
                  _titleController.text = value ?? '';
                  _subGroupController.clear();
                });
              },
            ),
            SizedBox(height: 16.0),
            if (_selectedCategory != null)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Sub-group',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      ),
                      value: _selectedSubGroup,
                      items: _subGroups[_selectedCategory!]?.map((String subGroup) {
                        return DropdownMenuItem<String>(
                          value: subGroup,
                          child: Text(subGroup),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSubGroup = value;
                          _subGroupController.text = _selectedSubGroup ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAchievements(userId: widget.userId),
                    ),
                  );
                },
                child: const Text('View All Achievements'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            if (_selectedCategory != null && _selectedSubGroup != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Achievement',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: _subGroupController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Achieved for',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.info, color: Colors.deepPurple),
                                onPressed: () {
                                  if (_selectedSubGroup != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(_selectedSubGroup!),
                                          content: Text(
                                            _subGroupDescriptions[_selectedSubGroup!] ?? 'No description available.',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _addAchievement,
                            child: const Text('Add Achievement'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
