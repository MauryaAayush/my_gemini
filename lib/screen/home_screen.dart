import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('My Ai'),
        centerTitle: true,
      ),
      body: GetBuilder<ChatController>(
        builder: (controller) {
          return DashChat(
            currentUser: sender,
            onSend: (message) {
              controller.sendMessage(message);
            },
            messages: controller.messages,
          );
        },
      ),
    );
  }
}

ChatUser sender = ChatUser(id: '1', firstName: 'Aayush', lastName: 'Maurya');
ChatUser receiver = ChatUser(id: '2', firstName: 'My', lastName: 'AI');
