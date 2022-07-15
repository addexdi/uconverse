import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/sender_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../widgets/receiver_chat.dart';
import '../constants/color.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat-screen';

  final CollectionReference _chats =
      FirebaseFirestore.instance.collection('chats/i9IFa7EAlYRZvzQkdUVQ/messages');

  @override
  Widget build(BuildContext context) {
    var msgData = Provider.of<MessageData>(context);
    var userData = Provider.of<UserData>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(userData.findById(2).imageUrl),
            ),
            const SizedBox(width: 10),
            Text(
              userData.findById(2).name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5,
          ),
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white60,
                  blurStyle: BlurStyle.inner,
                  blurRadius: 20.0,
                  spreadRadius: 7,
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '3',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: double.infinity,
          height: double.infinity,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: StreamBuilder(
                    stream: _chats.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                      if (snapshot.hasData) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return ReceiverChat(
                                message: documentSnapshot['text'],
                                time: documentSnapshot['text'],
                              );
                            }                     
                            //     : SenderChat(message: msgData.messages[index]),
                            );
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type your message here...',
                              hintStyle: TextStyle(color: Colors.white),
                              icon: Icon(Icons.emoji_emotions_outlined,
                                  color: Colors.white),
                              suffixIcon:
                                  Icon(Icons.attach_file, color: Colors.white),
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
