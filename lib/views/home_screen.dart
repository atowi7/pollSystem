import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_system/app_routes.dart';
import 'package:poll_system/models/poll_model.dart';
import 'package:poll_system/providers/poll_provider.dart';
import 'package:poll_system/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final pollProvider = Provider.of<PollProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.poll_outlined, color: Colors.blue),
              IconButton(
                onPressed: () {
                  if (userProvider.checkUserAuth() == true) {
                    userProvider.logout();
                  }
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
                icon: userProvider.checkUserAuth() == true
                    ? const Icon(
                        Icons.logout_outlined,
                        color: Colors.blue,
                      )
                    : const Icon(Icons.login_outlined, color: Colors.blue),
              ),
            ],
          ),
        ),
        body: StreamBuilder<List<PollModel>>(
            stream: pollProvider.getAllPollsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No polls avaliable',
                      style: Theme.of(context).textTheme.displayLarge),
                );
              }

              var polls = snapshot.data as List<PollModel>;

              return ListView.builder(
                  itemCount: polls.length,
                  itemBuilder: (context, index) {
                    PollModel poll = polls[index];
                    return PollItem(
                      poll: poll,
                      selectedOption:
                          pollProvider.selectedOptions[poll.id] ?? "",
                      isLogin: userProvider.checkUserAuth(),
                      onChanged: (option) =>
                          pollProvider.updateSelectedOption(poll.id, option),
                      onVote: (option) =>
                          pollProvider.submitResponse(poll.id, option),
                      onShare: () async {
                        pollProvider.showQrCodeDialog(
                            context,
                            Platform.isIOS
                                ? 'app://polls/${poll.id}'
                                : 'https://poll-system-23e47.web.app?pollId=${poll.id}');
                      },
                    );
                  });
            }),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            if (userProvider.checkUserAuth() == true) {
              Navigator.of(context).pushNamed(AppRoutes.createpolls);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.white70,
                  duration: const Duration(seconds: 1),
                  content: Text('You should have an account to create poll',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ))));
              Navigator.of(context).pushNamed(AppRoutes.login);
            }
          },
          child: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}

class PollItem extends StatelessWidget {
  final PollModel poll;
  final String selectedOption;
  final bool isLogin;
  final Function(String) onVote;
  final Function(String) onChanged;
  final Function() onShare;
  // final Function() onRefresh;
  const PollItem({
    super.key,
    required this.poll,
    required this.selectedOption,
    required this.isLogin,
    required this.onChanged,
    required this.onVote,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(poll.question,
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(
              height: 8,
            ),
            ...poll.options.map((option) {
              double percentage = poll.getPercentage(option) / 100;
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  LinearProgressIndicator(
                    minHeight: 20,
                    value: percentage,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue[400]!,
                    ),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      activeColor: selectedOption == option
                          ? Colors.blue[800]
                          : Colors.blue[600],
                      // hoverColor: Colors.blueAccent,
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        if (value != null) {
                          onChanged(value);
                        }
                      },
                    ),
                    title: Text(
                      "$option  ${percentage.toStringAsFixed(2)}%",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                  leading: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // shape: const CircleBorder(),
                        backgroundColor: Colors.blue,
                        // padding:
                        //     const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () {
                        selectedOption != ""
                            ? onVote(selectedOption)
                            : ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.white70,
                                    duration: const Duration(seconds: 1),
                                    content: Text(
                                        "Please choose option to vote",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red))));
                      },
                      child: Text("Vote",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.w800))),
                  title: Text('Total Votes: ${poll.getTotalVotes()}',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w400)),
                  subtitle: isLogin == true
                      ? Text(
                          FirebaseAuth.instance.currentUser!.uid ==
                                  poll.createdBy
                              ? "Created by You"
                              : "Created by other user",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.w600))
                      : null,
                  trailing: isLogin &&
                          FirebaseAuth.instance.currentUser!.uid ==
                              poll.createdBy
                      ? IconButton(
                          onPressed: onShare,
                          icon: const Icon(
                            Icons.share_rounded,
                            color: Colors.blue,
                            size: 30,
                          ))
                      : null),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
