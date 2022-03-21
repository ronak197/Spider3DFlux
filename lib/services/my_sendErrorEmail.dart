import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server

void sendErrorMail(
    {product_name, product_id, product_link, err_details, err_trace}) async {
  // Before use, Enable Less secure App Access for your sccount here: https://myaccount.google.com/lesssecureapps
  var username = 'justbiton80@gmail.com'; // Fake Email;
  var password = 'justbiton@31'; //Fake Email's password;

  final smtpServer = gmail(username, password);
  // final smtpServer = gmailRelaySaslXoauth2(username, password);
  // final smtpServer = gmailSaslXoauth2(username, password);
  // Creating the Gmail server

  var recipients = [
    'info@spider3d.co.il',
    'info@kivi.co.il',
    'eyal@kivi.co.il',
    'theblackhero2@gmail.com'
  ];
  var title =
      'אפליקציית ספיידר פרטי שגיאה מיישמון Spider3D 🕷📱️ + מדריך תיקון למוצר ווריאציה'; //subject of the email

  var content = '''
    היי , זוהי הודעה שהוגדרה להשלח אוטומטית במידה ולקוח נתקל בתקלה בעת בחירת ווריאצייה או הוספה לסל.

    * להלן פרטי המוצר *
    =================
    שם המוצר - $product_name
    ת.ז המוצר - $product_id
    קישור למוצר - $product_link
    
    שימו לב! מומלץ להשתמש במדריך "פתרון בעיות נפוצות" על מנת לתקן את המוצר, למדריך:
    https://docs.google.com/document/d/1SIgqW5HANA_8EZAWANB49MRgRf-DPrXJja_W46fYnsc/edit?usp=sharing
    
    * פרטי מלאים על התקלה *
    ======================
    זמן התקלה - ${DateTime.now()}
    תיאור התקלה שהתקבל - $err_details
    ----------------------------------
    רצף השגיאות שהתקבל - $err_trace
    
   =========== This mail bug fix ===============
   אם מייל זה לא נשלח לך יותר:
   Google - החל מ-30 במאי 2022 ההגדרה הזו לא תהיה זמינה יותר - https://prnt.sc/B9wB3V-MCWdi
   https://prnt.sc/KIzQksl6210z
   
    ''';

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    // ..recipients.add('dest@example.com') //recipent email
    ..ccRecipients.addAll(recipients) //cc Recipents emails
    // ..bccRecipients.add(
    //     Address('hiddenRecipients@example.com')) //bcc Recipents emails
    ..subject = title
    ..text = content; //body of the email

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
