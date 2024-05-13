import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sacred_hearts/api_connection/api_connection.dart';
import 'package:open_file/open_file.dart';
import 'package:sacred_hearts/users/model/user.dart';
import 'package:sacred_hearts/users/userPreferences/user_preferences.dart';

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
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchData();
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
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete user with ID: $userId?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text('Delete'),
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
                      SnackBar(
                        content: Text('Member deleted successfully'),
                        duration: Duration(seconds: 2), // Adjust duration as needed
                      ),
                    );

                    // Fetch data after a short delay to allow the SnackBar to be displayed
                    Future.delayed(Duration(seconds: 2), () {
                      fetchData();
                    });
                  } else {
                    print('Failed to delete member: ${response.body}');
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error deleting member: $error');
    }
  }



  Future<void> fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('${API.print}/?user_id=$userId'));
    if (response.statusCode == 200) {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir?.path}/user_details.pdf');
      await file.writeAsBytes(response.bodyBytes);
      print('PDF downloaded successfully');
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
      appBar: AppBar(
        title: Text('Members'),
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
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: search,
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: memberData.isEmpty && isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              itemCount: memberData.length + (isFetching ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == memberData.length) {
                  return Center(child: CircularProgressIndicator());
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
                          icon: Icon(Icons.picture_as_pdf),
                          onPressed: () {
                            fetchUserDetails(member['user_id']).catchError(
                                  (error) => print('Error downloading PDF: $error'),
                            );
                          },
                        ),
                        FutureBuilder<bool>(
                          future: RememberUserPrefs().checkUserPermissions(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Icon(Icons.error);
                            }
                            final currentUserHasPermission = snapshot.data ?? false;
                            if (currentUserHasPermission) {
                              return PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (String action) {
                                  if (action == 'delete') {
                                    deleteMember(context, member['user_id']);
                                  }
                                },
                              );
                            }
                            else {
                              return SizedBox();
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
              icon: Icon(Icons.arrow_back),
              onPressed: previousPage,
            ),
            Text('Page $currentPage / $totalPages'),
            IconButton(
              icon: Icon(Icons.arrow_forward),
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