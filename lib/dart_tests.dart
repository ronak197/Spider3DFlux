import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server

main() async {
  // Before use, Enable Less secure App Access for your sccount here: https://myaccount.google.com/lesssecureapps
  String username = 'idanbit80@gmail.com'; //Your Email;
  String password = 'Idan@325245'; //Your Email's password;

  final smtpServer = gmail(username, password);
  // final smtpServer = gmailRelaySaslXoauth2(username, password);
  // final smtpServer = gmailSaslXoauth2(username, password);
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    // ..recipients.add('dest@example.com') //recipent email
    ..ccRecipients.addAll(
        ['spider3d@info.co.il', 'theblackhero2@gmail.com']) //cc Recipents emails
    // ..bccRecipients.add(
    //     Address('hiddenRecipients@example.com')) //bcc Recipents emails
    ..subject = '${DateTime.now().day}עדכון מיישמון Spider3D 🕷📱️ - פרטי שגיאה (ותיקון) למוצר ווריאציות - ' //subject of the email
    ..text = '''
    היי , זוהי הודעה שהוגדרה להשלח אוטומטית במידה ולקוח נתקל בתקלה בעת בחירת ווריאצייה או הוספה לסל.

    * להלן פרטי המוצר *
    =================
    שם המוצר - pname
    ת.ז המוצר - pid
    קישור למוצר - link
    
    שימו לב! מומלץ להשתמש במדריך "פתרון בעיות נפוצות" על מנת לתקן את המוצר, למדריך:
    https://docs.google.com/document/d/1SIgqW5HANA_8EZAWANB49MRgRf-DPrXJja_W46fYnsc/edit?usp=sharing
    
    * פרטי מלאים על התקלה *
    ======================
    זמן התקלה - ${DateTime.now()}
    תיאור התקלה שהתקבל - errdetails
    ----------------------------------
    רצף השגיאות שהתקבל - errTrace
    '''; //body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print(
        'Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print(
        'Message not sent. \n' + e.toString()); //print if the email is not sent
    // e.toString() will show why the email is not sending
  }
} 