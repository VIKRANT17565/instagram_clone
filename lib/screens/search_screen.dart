import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: "Search for a user...",
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _isShowUsers = false;
              } else {
                _isShowUsers = true;
              }
            });
          },
          onFieldSubmitted: (value) {
            print(value);
            setState(() {
              _isShowUsers = true;
            });
          },
        ),
      ),
      body: _isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("username",
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (contex) => ProfileScreen(
                              uid: snapshot.data!.docs[index]["uid"],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]
                                    .data()
                                    .containsKey("photoUrl")
                                ? snapshot.data!.docs[index]["photoUrl"]
                                : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGcz4W8jbbyNtQH4hbT0NZqySOOE-ZbedsAg&usqp=CAU",
                          ),
                        ),
                        title: Text(snapshot.data!.docs[index]["username"]),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    return snapshot.data!.docs[index]
                            .data()
                            .containsKey("postUrl")
                        ? Image.network(
                            snapshot.data!.docs[index]["postUrl"],
                            fit: BoxFit.cover,
                          )
                        : Container();
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1);
                  },
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                );
              },
            ),
    );
  }
}
