import 'package:cloud_firestore/cloud_firestore.dart';

class PollModel {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, int> responses;
  final String createdBy;

  PollModel(
      {required this.id,
      required this.question,
      required this.options,
      required this.responses,
      required this.createdBy});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'responses': responses,
      'createdby': createdBy,
    };
  }

  // factory PollModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   var data = snapshot.data() as Map<String, dynamic>;

  //   return PollModel(
  //     id: snapshot.id,
  //     question: data['question'],
  //     options: List<String>.from(data['options']),
  //     responses: Map<String, int>.from(data['responses']),
  //     createdBy: data['createdby'],
  //   );
  // }
  factory PollModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PollModel(
      id: doc.id,
      question: data['question'],
      options: List<String>.from(data['options']),
      responses: Map<String, int>.from(data['responses']),
      createdBy: data['createdby'],
    );
  }

  int getTotalVotes() {
    return responses.values.fold(0, (total, votes) => total + votes);
  }

  double getPercentage(String option) {
    if (!responses.containsKey(option)) {
      return 0.0;
    }

    int totalVotes = getTotalVotes();

    return totalVotes > 0 ? (responses[option]! / totalVotes) * 100 : 0.0;
  }
}
