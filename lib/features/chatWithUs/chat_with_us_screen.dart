import 'package:flutter/material.dart';

class ChatWithUsScreen extends StatefulWidget {
  const ChatWithUsScreen({super.key});

  @override
  State<ChatWithUsScreen> createState() => _ChatWithUsScreenState();
}

class _ChatWithUsScreenState extends State<ChatWithUsScreen> {
  final List<Map<String, String>> chatMessages = [];

  // Simulating API questions and answers
  final List<Map<String, String>> faqData = [
    {
      'question': 'What are your service hours?',
      'answer': 'Our service hours are from 9 AM to 6 PM, Monday to Saturday.',
    },
    {
      'question': 'How do I reset my password?',
      'answer': 'You can reset your password from the login screen by tapping "Forgot Password".',
    },
    {
      'question': 'Where can I find my invoices?',
      'answer': 'Invoices are available under your profile in the "Billing" section.',
    },
  ];

  void _handleQuestionTap(String question, String answer) {
    setState(() {
      chatMessages.add({'type': 'question', 'text': question});
      chatMessages.add({'type': 'answer', 'text': answer});
    });
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isUser ? Colors.yellow.shade100 : Colors.orange.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildFAQOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: faqData.map((faq) {
        return GestureDetector(
          onTap: () => _handleQuestionTap(faq['question']!, faq['answer']!),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              faq['question']!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Us'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                return _buildMessageBubble(
                  message['text']!,
                  message['type'] == 'question',
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tap a question below to ask:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          _buildFAQOptions(),
        ],
      ),
    );
  }
}
