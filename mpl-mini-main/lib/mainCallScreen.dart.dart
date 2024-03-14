import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp/chats.dart';
import 'package:whatsapp/userProfile.dart';

import 'chattingScreen.dart';
import 'feature/welcome/widgets/info.dart';

void main() {
  runApp(mainCallsScreen());
}

class mainCallsScreen extends StatefulWidget {
  @override
  State<mainCallsScreen> createState() => _mainCallsScreenState();
}

class _mainCallsScreenState extends State<mainCallsScreen> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'CHATS'),
    Tab(text: 'STATUS'),
    Tab(text: 'CALLS'),
  ];

  late List<Map<String, String>> filteredContacts;

  bool showSearchBox = false;

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(info);
  }

  void searchContacts(String query) {
    setState(() {
      filteredContacts = info
          .where((contact) =>
              contact['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    // if (pickedFile != null) {
    //   setState(() {
    //     _image = File(pickedFile.path);
    //   });
    // }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Whatsapp'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    showSearchBox = !showSearchBox;
                  });
                },
                icon: const Icon(Icons.search),
              ),
              GestureDetector(
                onTap: _openCamera,
                child: Icon(Icons.camera_alt_outlined),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
                child: Icon(Icons.more_vert),
              ),

              SizedBox(
                width: 20,
              ),
            ],
            toolbarHeight: 80,
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(children: [
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(children: [
                  Visibility(
                    visible: showSearchBox,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: searchContacts,
                        decoration: InputDecoration(
                          hintText: 'Search contacts',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                    filteredContacts[index]['name'].toString(),
                                    filteredContacts[index]['message']
                                        .toString()),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              filteredContacts[index]['name'].toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 230, 227, 227)),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                filteredContacts[index]['message'].toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            leading: filteredContacts[index]['isStatus'] ==
                                    "true"
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MoreStories(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors
                                            .green, // Change the color to your desired green color
                                      ),
                                      padding: EdgeInsets.all(
                                          3), // Add padding to control the size of the green circle
                                      child: CircleAvatar(
                                        radius:
                                            30, // Set the radius of the CircleAvatar
                                        backgroundImage: NetworkImage(
                                          filteredContacts[index]['profilePic']
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      filteredContacts[index]['profilePic']
                                          .toString(),
                                    ),
                                  ),
                            trailing: Text(
                              filteredContacts[index]['time'].toString(),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(children: [
                  Visibility(
                    visible: showSearchBox,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: searchContacts,
                        decoration: InputDecoration(
                          hintText: 'Search contacts',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                    filteredContacts[index]['name'].toString(),
                                    filteredContacts[index]['message']
                                        .toString()),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              filteredContacts[index]['name'].toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 230, 227, 227)),
                            ),
                            // subtitle: Padding(
                            //   padding: const EdgeInsets.only(top: 5),
                            //   child: Text(
                            //     filteredContacts[index]['message'].toString(),
                            //     style: const TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.normal),
                            //   ),
                            // ),
                            leading: filteredContacts[index]['isStatus'] ==
                                "true"
                                ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoreStories(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .green, // Change the color to your desired green color
                                ),
                                padding: EdgeInsets.all(
                                    3), // Add padding to control the size of the green circle
                                child: CircleAvatar(
                                  radius:
                                  30, // Set the radius of the CircleAvatar
                                  backgroundImage: NetworkImage(
                                    filteredContacts[index]['profilePic']
                                        .toString(),
                                  ),
                                ),
                              ),
                            )
                                : CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                filteredContacts[index]['profilePic']
                                    .toString(),
                              ),
                            ),
                            trailing: Text(
                              filteredContacts[index]['time'].toString(),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(children: [
                  Visibility(
                    visible: showSearchBox,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: searchContacts,
                        decoration: InputDecoration(
                          hintText: 'Search contacts',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                    filteredContacts[index]['name'].toString(),
                                    filteredContacts[index]['message']
                                        .toString()),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              filteredContacts[index]['name'].toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 230, 227, 227)),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                filteredContacts[index]['message'].toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            leading: filteredContacts[index]['isStatus'] ==
                                "true"
                                ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoreStories(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .green, // Change the color to your desired green color
                                ),
                                padding: EdgeInsets.all(
                                    3), // Add padding to control the size of the green circle
                                child: CircleAvatar(
                                  radius:
                                  30, // Set the radius of the CircleAvatar
                                  backgroundImage: NetworkImage(
                                    filteredContacts[index]['profilePic']
                                        .toString(),
                                  ),
                                ),
                              ),
                            )
                                : CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                filteredContacts[index]['profilePic']
                                    .toString(),
                              ),
                            ),
                            trailing: Text(
                              filteredContacts[index]['time'].toString(),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ])),
          ]),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results here
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions here
    return Center(
      child: Text('Search suggestions for: $query'),
    );
  }
}

class Story extends StatelessWidget {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(
          8,
        ),
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              child: StoryView(
                controller: controller,
                storyItems: [
                  StoryItem.text(
                    title:
                        "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                    backgroundColor: Colors.orange,
                    roundedTop: true,
                  ),
                  // StoryItem.inlineImage(
                  //   NetworkImage(
                  //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
                  //   caption: Text(
                  //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       backgroundColor: Colors.black54,
                  //       fontSize: 17,
                  //     ),
                  //   ),
                  // ),
                  StoryItem.inlineImage(
                    url:
                        "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                    controller: controller,
                    caption: Text(
                      "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  StoryItem.inlineImage(
                    url:
                        "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                    controller: controller,
                    caption: Text(
                      "Hektas, sektas and skatad",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
                onStoryShow: (storyItem, index) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                  Navigator.pop(context);
                },
                progressPosition: ProgressPosition.bottom,
                repeat: false,
                inline: true,
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MoreStories()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
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

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "I guess you'd love to see more of our food. That's great.",
            backgroundColor: Colors.blue,
          ),
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            url:
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: Text(
              "Still sampling",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: Text(
                "Working with gifs",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              controller: storyController),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: Text(
              "Hello, from the other side",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: Text(
              "Hello, from the other side2",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            controller: storyController,
          ),
        ],
        onStoryShow: (storyItem, index) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
          Navigator.pop(context);
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
