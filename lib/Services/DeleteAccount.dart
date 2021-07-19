import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Services/Auth.dart';
import 'package:kabootr_app/Services/Database.dart';
import 'package:kabootr_app/Services/Storage.dart';

class DeleteAccount{
  final String userID;
  DeleteAccount({this.userID});

  deleteUserAccount() async{

    List<Sender> senderList = await DatabaseService(uid: userID).getSenderList();
    for(int i=0;i<senderList.length; i++){
      await deleteSenderDatabase(sender: senderList[i]);
    }
    await deleteUserDatabase();
    await deleteUserAuth();
  }

  deleteUserDatabase() async{
    await DatabaseService(uid: userID).deleteuser();
    await FireStorageService(fileName: 'img_$userID').deleteFile();
  }

  deleteUserAuth() async{
    final AuthService authservice = AuthService();
    authservice.deleteAccount();
  }

  deleteSenderDatabase({Sender sender}) async{

    try {
      ChatMessages chatMsg = await DatabaseService(uid: userID)
      .getOnlyChatMessage(sender.chatMessageUID);

      await DatabaseService(uid: userID).deleteSender(sender.id);
      await DatabaseService(uid: sender.id).deleteSender(userID);
      await DatabaseService(uid: sender.id).deleteChatMessage(
        ChatMessages(chatID: sender.chatMessageUID, chatMessage: '')
      );

      List<Message> msgList = decodeChat(chatMsg.chatMessage);

      for(int i=0;i<msgList.length;i++){
        if(msgList[i].message.startsWith(fileAttachMsg)){
            await FireStorageService(
              fileName: 'img_'+ msgList[i].time.replaceAll('/','')
            ).deleteFile();
        }
      }
    } catch (e) {
      print('error in deleting User Database: $e');
    }

  }

}