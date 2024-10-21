import 'package:flutter/material.dart';
import 'package:poll_system/providers/poll_provider.dart';
import 'package:provider/provider.dart';

class CreatePollScreen extends StatelessWidget {
  CreatePollScreen({super.key});

  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionsController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    final pollViewModel = Provider.of<PollProvider>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                  hintText: "Question",
                  hintStyle: Theme.of(context).textTheme.displayLarge,
                  labelText: "Question",
                  labelStyle: Theme.of(context).textTheme.displayLarge,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  fillColor: Colors.blue.withOpacity(0.4),
                  filled: true),
            ),
            const SizedBox(height: 8),
            ..._optionsController.map((controller) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Option",
                      hintStyle: Theme.of(context).textTheme.displayMedium,
                      labelText: "Option",
                      labelStyle: Theme.of(context).textTheme.displayMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      fillColor: Colors.blue.withOpacity(0.4),
                      filled: true),
                ),
              );
            }),
            const SizedBox(height: 8),
            pollViewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // shape: const CircleBorder(),
                      backgroundColor: Colors.blue
                      // padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () async {
                      String question = _questionController.text;
                      List<String> options = _optionsController
                          .map((controller) => controller.text)
                          .toList();
                      bool success =
                          await pollViewModel.createPoll(question, options);
                      if (success) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.white70,
                                  content: Text('Poll created sucessfully',)));
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Error : Failed to create poll')));
                        }
                      }
                    },
                    child: Text("Create Poll",
                        style: Theme.of(context).textTheme.displaySmall))
          ],
        ),
      ),
    ));
  }
}
