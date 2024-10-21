import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_system/app_routes.dart';
import 'package:poll_system/main.dart';
import 'package:poll_system/models/poll_model.dart';
import 'package:poll_system/services/poll_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app_links/app_links.dart';

class PollProvider extends ChangeNotifier {
  final PollService _pollService = PollService();
  PollModel? _poll;
  bool _isLoading = false;
  String _selectedOption = "";

  PollModel? get poll => _poll;
  bool get isLoading => _isLoading;
  String? get selectedOption => _selectedOption;

  late StreamSubscription? _sub;

  PollProvider() {
    _initDeepLiniking();
  }
  Future<void> _initDeepLiniking() async {
    final appLinks = AppLinks();
    final initialUrl = await appLinks.getInitialLink();
    if (initialUrl != null) {
      _handleDeepLinking(initialUrl);
    }

    _sub = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLinking(uri);
      }
    }, onError: (error) {
      SnackBar(content: Text('Failed to reciece link : $error'));
    });
  }

  void _handleDeepLinking(Uri uri) async {
    final pollId = uri.queryParameters['pollId'];
    if (pollId != null) {
      Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
          AppRoutes.home, (Route<dynamic> route) => false);
    }
  }

  Future<bool> createPoll(String question, List<String> options) async {
    _isLoading = true;
    notifyListeners();

    String pollId = FirebaseFirestore.instance.collection('polls').doc().id;
    User? user = FirebaseAuth.instance.currentUser;

    try {
      PollModel newPoll = PollModel(
        id: pollId,
        question: question,
        options: options,
        responses: {},
        createdBy: user!.uid,
      );
      await _pollService.createPoll(newPoll);

      _isLoading = false;

      notifyListeners();

      return true;
    } on FirebaseFirestore catch (_) {
      return false;
    }
  }

  Future<void> getPoll(String pollId) async {
    _isLoading = true;
    notifyListeners();

    _poll = await _pollService.getPollById(pollId);

    _isLoading = false;
    notifyListeners();
  }

  void updateSelectedOption(String option) {
    _selectedOption = option;
    notifyListeners();
  }

  // int getTotalVotes(String pollId) {
  //   return pollList[pollId].values.fold(0, (total, votes) => total + votes);
  // }

  // double getPercentage(String option) {
  //   if (!responses.containsKey(option)) {
  //     return 0.0;
  //   }

  //   int totalVotes = getTotalVotes();

  //   return totalVotes > 0 ? (responses[option]! / totalVotes) * 100 : 0.0;
  // }

  Future<void> submitResponse(String pollId, String option) async {
    await _pollService.submitResponse(pollId, option);

    _selectedOption = "";

    notifyListeners();
  }

  Future<List<PollModel>> getAllPolls() async {
    return await _pollService.getAllPolls();
  }

  // Future<int> getTotalVotes(String pollId) async {
  //   return await _pollService.getTotalVotes(pollId);
  // }

  // Future<void> shareUrl(String pollId, String url) async {
  //   await Share.share("Poll on this link $url");
  // }

  void showQrCodeDialog(BuildContext context, String link) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white70,
            title: Text(
              'Share this poll',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: link,
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.width * 0.4,
                    gapless: false,
                  ),
                  const SizedBox(height: 8),
                  Text('Scan this QR code to vote',
                      style: Theme.of(context).textTheme.displayMedium)
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  void refresh() async {
    await getAllPolls();

    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
