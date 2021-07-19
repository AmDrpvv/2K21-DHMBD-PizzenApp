import 'package:kabootr_app/Services/Storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'Models.dart';

const String fileAttachMsg = '(%fileAttached<Media>%)';
const String replyMessageFormat = 'reply=>';


RegExp mainMessageRE = new RegExp(r'(\d{2}\/\d{2}\/\d{4})[,] (\d{2}[:]\d{2}[:]\d{2}) [-] (.+)[:] (.+)');
RegExp defaultMessageRE = new RegExp(r'(\d{2}\/\d{2}\/\d{4})[,] (\d{2}[:]\d{2}[:]\d{2}) [-] (.+)');
RegExp fileAttachedRE = new RegExp(r'(\d{2}\/\d{2}\/\d{4})[,] (\d{2}[:]\d{2}[:]\d{2}) [-] (.+)[:] (.+)reply=>(.+)');
RegExp chatNameRE = new RegExp(r'.+WhatsApp Chat with (.+)\.txt');

final String defaultAppTitle = 'defaultAppTitle';
final String defaultImageUrl = 'defaultImageUrl';
final String defaultFontSize = 'defaultFontSize';
final String defaultPassKey = 'passKey';
final String sharedPrefDarkTheme = 'darkTheme';

List<String> monthName=['January','February','March','April','May','June','July',
  'August','September','October','November','December'];

String getFormattedDateTime(DateTime date)
{
  date.toUtc();
  String _date = getDate(date);
  String sec = date.second > 9 ? '${date.second}' :'0${date.second}';
  if(date.hour > 9 )
    {
      if(date.minute > 9)
        return '${date.hour}:${date.minute}:$sec$_date';
      else
        return '${date.hour}:0${date.minute}:$sec$_date';
    }
  else
    {
      if(date.minute > 9)
        return '0${date.hour}:${date.minute}:$sec$_date';
      else
        return '0${date.hour}:0${date.minute}:$sec$_date';
    }
}

String getDate(DateTime date)
{
  date.toUtc();
  if(date.day > 9)
    {
      if(date.month >9)
        return '${date.day}/${date.month}/${date.year}';
      else
        return '${date.day}/0${date.month}/${date.year}';
    }
  else
  {
    if(date.month >9)
      return '0${date.day}/${date.month}/${date.year}';
    else
      return '0${date.day}/0${date.month}/${date.year}';
  }
}


getSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    defaultAppTitle : prefs.getString(defaultAppTitle) ?? 'Pizzen',
    defaultImageUrl : prefs.getString(defaultImageUrl) ?? 'https://firebasestorage.googleapis.com/v0/b/shukr-2a76b.appspot.com/o/images%2Fdp%20to%20upload.png?alt=media&token=32f2829c-4bf7-4864-be6f-25049992b454',
    defaultPassKey : prefs.getString(defaultPassKey) ?? '',
    defaultFontSize : prefs.getInt(defaultFontSize) ?? 0,
    sharedPrefDarkTheme : prefs.getBool(sharedPrefDarkTheme) ?? false,
  };
}

List<Message> decodeChat(String data) {
    List<Message> _messagelist =[];
    if(data != ''){
    convert.LineSplitter.split(data).forEach((line) {
      Match match = mainMessageRE.firstMatch(line);
      if (match == null) {
        Match match2 = defaultMessageRE.firstMatch(line);
        if (_messagelist.isNotEmpty && match2 == null){
          _messagelist.last.message += '\n'+line;
        }

      } else {
        Match match3 = fileAttachedRE.firstMatch(line);
        _messagelist.add(
          Message(
            senderID: match.group(3),
            message: match3 != null ? match3.group(4) : match.group(4),
            time: match.group(2) + match.group(1),
            replyMessage: match3 != null ? match3.group(5) : '',
        ));

      }
    });}
    return _messagelist;
}

deleteImageFile(String name) async {
  await FireStorageService(fileName: name)
  .deleteFile();
}
String encodeChat(String data, String id, String msg , [String dateTime = '']){
  var splitedData = convert.LineSplitter.split(data);

  if(splitedData.length > 30)
  {
    String msgTodelete = splitedData.elementAt(0);
    Match match = mainMessageRE.firstMatch(msgTodelete);
    if(match != null) {
      if(match.group(4).startsWith(fileAttachMsg))
      {
        deleteImageFile('img_${match.group(2)}${match.group(1)}'.replaceAll('/',''));
      }
    }
    data = data.substring(msgTodelete.length +1);
  }
  if(dateTime == '') dateTime = getFormattedDateTime(DateTime.now());
  String message = "${dateTime.substring(8)}, ${dateTime.substring(0,8)} - $id: $msg";
  return data == '' ? message : data + '\n' + message;
}