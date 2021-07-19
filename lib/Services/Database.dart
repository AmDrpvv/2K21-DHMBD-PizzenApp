import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabootr_app/AppEntity/Models.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference mainCollection =Firestore.instance.collection('DhimanAppsDataBase');
  final CollectionReference chatMessageCollection =Firestore.instance.collection('DhimanAppsChatMessages');
  final String senderCollection = 'sendersList';

  List<Sender> _changeQuerySnapshotsintoSender(QuerySnapshot snapshot)
  {
    return snapshot.documents.map((doc) {
      return Sender.fromMap(doc.data);
    }).toList();
  }

  User _changeDocumentSnapshotsintoUser(DocumentSnapshot snapshot)
  {
    return User.fromMap(snapshot.data);
  }

  List<User> _changeQuerySnapshotsintoUserList(QuerySnapshot snapshot)
  {
    return snapshot.documents.map((doc) {
      return User.fromMap(doc.data);
    }).toList();
  }

  ChatMessages _changeDocumentSnapshotsintoChatMessage(DocumentSnapshot snapshot)
  {
      return ChatMessages.fromMap(snapshot.data);
  }


  //get userdata stream
  Stream<List<User>> get userListStream
  {
    return mainCollection.snapshots()
        .map(_changeQuerySnapshotsintoUserList);
  }

  Future<User> getOnlyUser() async{
    var map = await mainCollection.document(uid).get();
    return User.fromMap(map.data);
  }


  Future<ChatMessages> getOnlyChatMessage(String chatID) async{
    var map = await chatMessageCollection.document(chatID).get();

    if(map.data == null) return null;
    return ChatMessages.fromMap(map.data);
  }

  Future<List<Sender>> getSenderList() async{
    var map = await mainCollection.document(uid)
    .collection(senderCollection).getDocuments();

    if(map == null) return [];

    return map.documents.map((doc){
      return Sender.fromMap(doc.data);
    }).toList();
  }

  Future<Sender> getOnlySender(String senderID) async{
    var map = await mainCollection.document(uid)
    .collection(senderCollection)
    .document(senderID).get();

    if(map.data == null) return null;
    return Sender.fromMap(map.data);
  }

  Stream<User> get onlyUserStream
  {
    return mainCollection.document(uid).snapshots()
        .map(_changeDocumentSnapshotsintoUser);
  }

  Stream<ChatMessages> get chatMessagesStream
  {
    return chatMessageCollection.document(uid).snapshots()
        .map(_changeDocumentSnapshotsintoChatMessage);
  }

  Stream<List<Sender>> get senderStream
  {
    return mainCollection.document(uid)
    .collection(senderCollection).snapshots()
    .map(_changeQuerySnapshotsintoSender);
  }

  Future createuser(User user) async{
    return await mainCollection.document(uid).setData(user.toMap());
  }
  Future updateuser(User user) async{
    return await mainCollection.document(uid).updateData(user.toMap());
  }

  Future getchatMessageID () async{
    return chatMessageCollection.document().documentID;
  }

  Future createchatMessage (ChatMessages chatMessage) async{
    return await chatMessageCollection.document(chatMessage.chatID).setData(chatMessage.toMap());
  }

  Future updatechatMessage (ChatMessages chatMessage) async{
    return await chatMessageCollection.document(chatMessage.chatID).updateData(chatMessage.toMap());
  }

  Future createsender (Sender sender) async{
    return await mainCollection.document(uid)
    .collection(senderCollection)
    .document(sender.id).setData(sender.toMap());
  }

  Future updatesender (Sender sender) async{
    return await mainCollection.document(uid)
    .collection(senderCollection)
    .document(sender.id).updateData(sender.toMap());
  }

  //delete Documents
  Future deleteuser() async{
    return await mainCollection.document(uid).delete();
  }

  Future deleteChatMessage (ChatMessages chatMessage) async{
    return await chatMessageCollection.document(chatMessage.chatID).delete();
  }

  Future deleteSender (String  senderID) async{
    return await mainCollection.document(uid)
    .collection(senderCollection)
    .document(senderID).delete();
  }
}