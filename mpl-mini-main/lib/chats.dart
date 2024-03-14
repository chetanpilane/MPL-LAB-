import 'package:flutter/material.dart';
import 'package:whatsapp/feature/welcome/widgets/info.dart';

import 'chattingScreen.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext contacts) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: info.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(info[index]['name'].toString(), info[index]['message'].toString()),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  info[index]['name'].toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 230, 227, 227)),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    info[index]['message'].toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    info[index]['profilePic'].toString(),
                  ),
                ),
                trailing: Text(
                  info[index]['time'].toString(),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ),
            );
          },
        ));
  }
}
