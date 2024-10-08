import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sacred_hearts/api_connection/api_connection.dart';
import 'package:open_file/open_file.dart';
import 'package:sacred_hearts/users/updateMember/edit_member.dart';
import 'package:sacred_hearts/users/userPreferences/user_preferences.dart';
import 'package:sacred_hearts/users/achievements/achievement.dart';


class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  List<dynamic> memberData = [];
  int currentPage = 1;
  int perPage = 8;
  int totalPages = 1;
  bool isLoading = false;
  bool isFetching = false;
  bool currentUserHasPermission = false;
  bool allowEditForAll = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchPermissions();
    fetchData();
  }

  Future<void> fetchPermissions() async {
    currentUserHasPermission = await RememberUserPrefs().checkUserPermissions();
    await fetchToggleStatus(); // Fetch toggle status
    setState(() {});
  }


  Future<void> fetchToggleStatus() async {
    try {
      final response = await http.get(Uri.parse('${API.toggle}'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        setState(() {
          allowEditForAll = jsonData['status'] == true;
        });
      } else {
        // Handle HTTP error
        print('Failed to fetch toggle status');
      }
    } catch (e) {
      print('Error fetching toggle status: $e');
    }
  }

  Future<void> updateToggleStatus(bool status) async {
    try {
      final response = await http.post(
        Uri.parse('${API.toggle}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          print('Toggle status updated successfully');
        } else {
          print('Failed to update toggle status: ${jsonData['message']}');
        }
      } else {
        print('Failed to update toggle status');
      }
    } catch (e) {
      print('Error updating toggle status: $e');
    }
  }


  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> addMemberAndNavigate() async {
    setState(() {
      isLoading = true;
    });

    // Call the API to insert a new record
    final response = await http.post(Uri.parse('${API.insert}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        int newUserId = jsonData['user_id'];

        // Navigate to EditMemberScreen with the new user_id
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditMemberScreen(userId: newUserId.toString()),
          ),
        );
      } else {
        // Handle API error response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(jsonData['message']),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle HTTP error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add member. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchData({String? query}) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        '${API.members}?page=$currentPage&perPage=$perPage${query != null ? '&query=$query' : ''}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      totalPages = jsonData['totalPages'];
      setState(() {
        memberData = jsonData['memberData'];
        isLoading = false;
      });
    }
  }

  Future<void> loadMoreData({String? query}) async {
    if (isLoading || isFetching) {
      return;
    }
    setState(() {
      isFetching = true;
      currentPage++;
    });
    final response = await http.get(Uri.parse(
        '${API.members}?page=$currentPage&perPage=$perPage${query != null ? '&query=$query' : ''}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      totalPages = jsonData['totalPages'];
      setState(() {
        memberData.addAll(jsonData['memberData']);
        isFetching = false;
      });
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      fetchData(query: _searchController.text.trim());
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchData(query: _searchController.text.trim());
    }
  }

  void search() {
    currentPage = 1;
    fetchData(query: _searchController.text.trim());
  }

  void clearSearch() {
    _searchController.clear();
    currentPage = 1;
    fetchData();
  }

  void deleteMember(BuildContext context, String userId) async {
    try {
      // Show alert dialog with the user ID
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete user with ID: $userId?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  // Proceed with deletion
                  final response = await http.delete(
                    Uri.parse('${API.delete}?user_id=$userId'),
                  );

                  if (response.statusCode == 200) {
                    // Close the dialog
                    Navigator.of(context).pop();

                    // Show SnackBar with delete status message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Member deleted successfully'),
                        duration: Duration(seconds: 2), // Adjust duration as needed
                      ),
                    );

                    // Fetch data after a short delay to allow the SnackBar to be displayed
                    Future.delayed(const Duration(seconds: 2), () {
                      fetchData();
                    });
                  } else {
                    // Handle deletion error
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle general error
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('${API.print}/?user_id=$userId'));
    if (response.statusCode == 200) {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir?.path}/user_details.pdf');
      await file.writeAsBytes(response.bodyBytes);
      openDownloadedPdf(file);
    } else {
      throw Exception('Failed to load user details');
    }
  }

  void openDownloadedPdf(File file) {
    OpenFile.open(file.path);
  }

  void _showProfileImagePreview(String base64Image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(base64Decode(base64Image)),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          titleSpacing: 10.0,
          title: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: const Text('Members'),
          ),
          actions: [
            if (currentUserHasPermission)
              Padding(
                padding: const EdgeInsets.only(right: 40.0, top: 15.0, bottom: 5.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                  onPressed: () {
                    addMemberAndNavigate();
                  },
                ),
              ),
            if (currentUserHasPermission)
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Edit Access:',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 8.0), // Add space between the text and the switch
                              Switch(
                                value: allowEditForAll,
                                onChanged: (bool value) async {
                                  setState(() {
                                    allowEditForAll = value;
                                  });
                                  await updateToggleStatus(value);
                                },
                                activeColor: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: search,
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: memberData.isEmpty && isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              itemCount: memberData.length + (isFetching ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == memberData.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final member = memberData[index];
                  final base64Image = member['img_url'];
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        _showProfileImagePreview(base64Image);
                      },
                      child: CircleAvatar(
                        backgroundImage: MemoryImage(base64Decode(base64Image)),
                      ),
                    ),
                    title: Text(member['official_name']),
                    subtitle: Text(member['baptism_name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf),
                          onPressed: () {
                            fetchUserDetails(member['user_id']).catchError(
                                  (error) => print('Error downloading PDF: $error'),
                            );
                          },
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            if (allowEditForAll || currentUserHasPermission)
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                            if (currentUserHasPermission)
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem<String>(
                                value: 'achievements',
                                child: Row(
                                  children: [
                                    Icon(Icons.star),
                                    SizedBox(width: 8),
                                    Text('Achievements'),
                                  ],
                                ),
                              ),
                          ],
                          onSelected: (String action) {
                            if (action == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMemberScreen(userId: member['user_id']),
                                ),
                              );
                            } else if (action == 'delete') {
                              deleteMember(context, member['user_id']);
                            } else if (action == 'achievements') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AchievementScreen(userId: member['user_id']),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: previousPage,
            ),
            Text('Page $currentPage / $totalPages'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: nextPage,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MemberScreen(),
  ));
}
