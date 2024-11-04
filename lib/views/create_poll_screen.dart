import 'package:flutter/material.dart';
import 'package:poll_system/providers/poll_provider.dart';
import 'package:provider/provider.dart';

class CreatePollScreen extends StatelessWidget {
  const CreatePollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pollProvider = Provider.of<PollProvider>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: pollProvider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: pollProvider.questionController,
                validator: (value) => pollProvider.validateQuestion(value),
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
              const SizedBox(height: 20),
              ...pollProvider.optionsController.map((controller) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: controller,
                    validator: (value) => pollProvider.validateOption(value),
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
              const SizedBox(height: 20),
              pollProvider.isLoading
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
                        await pollProvider.createPoll(context);
                      },
                      child: Text("Create Poll",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.w800))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300]),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w800))),
            ],
          ),
        ),
      ),
    ));
  }
}
