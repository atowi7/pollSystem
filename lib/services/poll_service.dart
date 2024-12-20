import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poll_system/models/poll_model.dart';

class PollService {
  final CollectionReference pollCollection =
      FirebaseFirestore.instance.collection("polls");

  Future<void> createPoll(PollModel poll) async {
    await pollCollection.doc(poll.id).set(poll.toJson());
  }

  Future<PollModel> getPollById(String id) async {
    var doc = await pollCollection.doc(id).get();
    return PollModel.fromDocument(doc);
  }

  Stream<List<PollModel>> getAllPollsStream() {
    return pollCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PollModel.fromDocument(doc)).toList());
    // QuerySnapshot snapshot = await pollCollection.get();
    // return snapshot.docs.map((doc) => PollModel.fromSnapshot(doc)).toList();
  }

  Future<void> submitResponse(String pollId, String option) async {
    var pollRef = pollCollection.doc(pollId);

    FirebaseFirestore.instance.runTransaction((trunsaction) async {
      var doc = await trunsaction.get(pollRef);
      PollModel poll = PollModel.fromDocument(doc);

      poll.responses[option] = (poll.responses[option] ?? 0) + 1;
      trunsaction.update(pollRef, {'responses': poll.responses});
    });
  }

  // Future<int> getTotalVotes(String pollId) async {
  //   var snapshot = await pollCollection.doc(pollId).get();
  //   PollModel poll = PollModel.fromSnapshot(snapshot);
  //   int totalVotes =
  //       poll.responses.values.fold(0, (total, votes) => total + votes);

  //   return totalVotes;
  // }
}
