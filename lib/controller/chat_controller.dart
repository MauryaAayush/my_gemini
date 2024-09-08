import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<ChatMessage> messages = [];

  @override
  void onInit() {
    super.onInit();
    loadMessagesFromFirebase(); // Load messages on controller initialization
  }

  Future<void> loadMessagesFromFirebase() async {
    QuerySnapshot snapshot = await firestore.collection('chats').get();

    messages = snapshot.docs.map((doc) {
      return ChatMessage(
        user: ChatUser(
          id: doc['user_id'],
          firstName: doc['first_name'],
          lastName: doc['last_name'],
        ),
        text: doc['text'],
        createdAt: (doc['created_at'] as Timestamp).toDate(),
      );
    }).toList();

    update();
  }

  Future<void> sendMessage(ChatMessage message) async {
    // Add the message to the local list
    messages.insert(0, message);
    update();

    // Save the message to Firebase
    await firestore.collection('chats').add({
      'user_id': message.user.id,
      'first_name': message.user.firstName,
      'last_name': message.user.lastName,
      'text': message.text,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Get the AI response and store it
    await gemini.text(message.text).then((value) async {
      ChatMessage aiMessage = ChatMessage(
        user: receiver,
        text: value!.output!,
        createdAt: DateTime.now(),
      );

      // Add AI response to local list
      messages.insert(0, aiMessage);
      update();

      // Save AI response to Firebase
      await firestore.collection('chats').add({
        'user_id': aiMessage.user.id,
        'first_name': aiMessage.user.firstName,
        'last_name': aiMessage.user.lastName,
        'text': aiMessage.text,
        'created_at': FieldValue.serverTimestamp(),
      });
    });
  }
}

ChatUser sender = ChatUser(id: '1', firstName: 'Aayush', lastName: 'Maurya');
ChatUser receiver = ChatUser(id: '2', firstName: 'My', lastName: 'AI');
