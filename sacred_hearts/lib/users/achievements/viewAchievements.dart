import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sacred_hearts/api_connection/api_connection.dart';

class ViewAchievements extends StatefulWidget {
  final String userId;

  ViewAchievements({required this.userId});

  @override
  _ViewAchievementsState createState() => _ViewAchievementsState();
}

class _ViewAchievementsState extends State<ViewAchievements> {
  late Future<List<dynamic>> _achievements;

  @override
  void initState() {
    super.initState();
    _achievements = _fetchAchievements();
  }

  Future<List<dynamic>> _fetchAchievements() async {
    final url = Uri.parse('${API.fetchAchievement}?user_id=${widget.userId}');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['success']) {
        return responseData['achievements'];
      } else {
        throw Exception('Failed to load achievements');
      }
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  void _editAchievement(int id) async {
    // Fetch the current data of the achievement
    final url = Uri.parse('${API.fetchAchievement}?user_id=${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Check if achievements exist in the response
      if (responseData['achievements'] != null) {
        // Try to find the achievement by ID
        final achievementsList = responseData['achievements'];
        final achievement = achievementsList.firstWhere(
              (ach) => ach['id'].toString() == id.toString(),
          orElse: () => null, // Return null if no matching element is found
        );

        if (achievement != null) {
          final TextEditingController dateController = TextEditingController(text: achievement['date']);
          final TextEditingController descriptionController = TextEditingController(text: achievement['description']);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Edit Achievement'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(text: achievement['title']),
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: TextEditingController(text: achievement['sub_group']),
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Sub-group'),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final updatedData = {
                      'id': id.toString(),
                      'date': dateController.text,
                      'description': descriptionController.text,
                    };

                    final editUrl = Uri.parse('${API.editAchievement}');
                    final response = await http.post(
                      editUrl,
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode(updatedData),
                    );

                    if (response.statusCode == 200) {
                      setState(() {
                        _achievements = _fetchAchievements(); // Refresh the list
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to edit achievement')),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Achievement not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No achievements available')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load achievement details')),
      );
    }
  }

  void _removeAchievement(int id) async {
    // Convert ID to String if needed
    final idString = id.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Achievement'),
        content: Text('Are you sure you want to remove this achievement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final url = Uri.parse('${API.deleteAchievement}?id=$idString');
              final response = await http.delete(url);

              if (response.statusCode == 200) {
                setState(() {
                  _achievements = _fetchAchievements(); // Refresh the list
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to remove achievement')),
                );
              }
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Achievements'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _achievements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No achievements found.'));
          } else {
            final achievements = snapshot.data!;

            // Group by category
            final groupedAchievements = <String, List<dynamic>>{};
            for (var achievement in achievements) {
              final category = achievement['category'] ?? 'Uncategorized';
              if (!groupedAchievements.containsKey(category)) {
                groupedAchievements[category] = [];
              }
              groupedAchievements[category]!.add(achievement);
            }

            // Sort categories
            final sortedCategories = groupedAchievements.keys.toList()
              ..sort((a, b) => a.compareTo(b));

            return ListView(
              children: sortedCategories.map((category) {
                final categoryAchievements = groupedAchievements[category]!;

                return ExpansionTile(
                  title: Text(
                    category,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: categoryAchievements.map((achievement) {
                    final id = achievement['id'];
                    final subGroup = achievement['sub_group'] ?? 'No sub-group';
                    final date = achievement['date'] ?? 'No date';
                    final description = achievement['description'] ?? 'No description';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 24.0),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    subGroup,
                                    style: Theme.of(context).textTheme.headline6?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Date: $date',
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                color: Colors.blueGrey[600],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _editAchievement(id),
                                  child: Text('Edit'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                TextButton(
                                  onPressed: () => _removeAchievement(id),
                                  child: Text('Remove'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
