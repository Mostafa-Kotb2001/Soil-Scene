import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();

  void _sendMessage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userIdentifier = user != null ? user.email ?? user.uid : null;

      if(userIdentifier != null){
        await FirebaseFirestore.instance.collection('Chat').add({
          'Text': _textController.text,
          'CreatedAt': Timestamp.now(),
          'From': userIdentifier,
          'To': 'Experts',
        });
        _textController.clear();
      }else{
        print('Error sending message: User not authenticated');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat' ,style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed('/Admin');
          }, icon: const Icon(Icons.admin_panel_settings_outlined), color: Colors.black,)
        ],
      ),
      body:Stack (
        children: [
          Positioned.fill(
              child: Image.asset('background.jpeg' , fit: BoxFit.cover,),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<List<QuerySnapshot>>(
                  stream: Rx.combineLatest2(
                    FirebaseFirestore.instance
                        .collection('Chat')
                        .orderBy('CreatedAt')
                        .where('From', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                        .snapshots(),
                    FirebaseFirestore.instance
                        .collection('Chat')
                        .orderBy('CreatedAt')
                        .where('To', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                        .snapshots(),
                        (QuerySnapshot a, QuerySnapshot b) => [a, b],
                  ),
                  builder: (ctx, AsyncSnapshot<List<QuerySnapshot>> chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (chatSnapshot.hasError) {
                      return Text('Error: ${chatSnapshot.error}');
                    }

                    final chatDocs = <QueryDocumentSnapshot>[];
                    chatSnapshot.data?.forEach((snapshot) {
                      chatDocs.addAll(snapshot.docs);
                    });

                    if (chatDocs.isEmpty) {
                      return Text('No Data');
                    }

                    // Sort the chatDocs by 'CreatedAt'
                    chatDocs.sort((a, b) => a['CreatedAt'].compareTo(b['CreatedAt']));

                    return ListView.builder(
                      itemCount: chatDocs.length,
                      itemBuilder: (ctx, index) {
                        final isCurrentUser = chatDocs[index]['From'] == FirebaseAuth.instance.currentUser!.email;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.white : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              chatDocs[index]['Text'],
                              textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                              style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white),
                            ),
                            subtitle: Text(
                              chatDocs[index]['From'].toString(),
                              textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                              style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white),
                            ),
                            // Leading icon for messages from the current user
                            leading: isCurrentUser
                                ? null
                                : Icon(Icons.account_circle, color: Colors.white),
                            trailing: isCurrentUser
                                ? Icon(Icons.account_circle, color: Colors.black)
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Send a message...',
                          fillColor: Colors.white ,
                          filled: true
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send , color: Colors.black ,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
