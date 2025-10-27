import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin extends StatefulWidget{
 @override
 _AdminState createState () => new _AdminState();
}

class _AdminState extends State<Admin>{

  final TextEditingController _textController = TextEditingController();
  final TextEditingController to = TextEditingController();

  void _sendMessage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userIdentifier = user != null ? user.email ?? user.uid : null;

      if(userIdentifier != null){
        await FirebaseFirestore.instance.collection('Chat').add({
          'Text': _textController.text,
          'CreatedAt': Timestamp.now(),
          'From': 'Experts',
          'To': to.text,
        });
        _textController.clear();
        to.clear();
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
        title: Text('Admin Chat' , style:  TextStyle(color: Colors.black),),
        backgroundColor: Colors.green,
      ),
      body:Stack(
        children: [
          Positioned.fill(
              child: Image.asset('background.jpeg' , fit: BoxFit.cover,)
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Chat')
                      .orderBy('CreatedAt')
                      .snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (chatSnapshot.hasError) {
                      return Text('Error: ${chatSnapshot.error}');
                    }
                    if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
                      return Text('No Data');
                    }
                    final chatDocs = chatSnapshot.data!.docs;
                    return ListView.builder(
                      itemCount: chatDocs.length,
                      itemBuilder: (ctx, index) {
                        final isCurrentUser = chatDocs[index]['From'] == 'Experts';
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.white : Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                        ),
                        child:
                          ListTile(
                          title: Text(
                            chatDocs[index]['Text'],
                            textAlign: isCurrentUser ? TextAlign.right : TextAlign.left, // Align text based on the sender
                          ),
                          subtitle: Text(
                            chatDocs[index]['From'].toString(),
                            textAlign: isCurrentUser ? TextAlign.right : TextAlign.left, // Align sender's name based on the sender
                          ),
                          tileColor: isCurrentUser ? Colors.white : Colors.grey, // Example color
                          // Leading icon for messages from the current user
                        ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: to,
                            decoration: const InputDecoration(
                                labelText: 'To',
                                fillColor: Colors.white ,
                                filled: true),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                                labelText: 'Send a message...',
                                fillColor: Colors.white ,
                                filled: true
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(Icons.send ,color: Colors.black,),
                        ),
                      ],
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