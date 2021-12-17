import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firestore_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirestorePage(),
    );
  }
}

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      const SizedBox(
        height: 100,
      ),
      const TextButton(
        onPressed: addTokens,
        child: Text(
          'Add Tokens',
        ),
      ),
      ElevatedButton(
          onPressed: () async {
            await getThingiToken();
          },
          child: const Text('get Thingi Token')),
      Text('get token $selectedToken (Hot restart to update) \n+1 users_usage')
    ])));
  }
}

CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');
String? selectedToken;

Future<String?> getThingiToken() async {
// 1. Looking for token with users (usage) Less than 10
// 2. Found: Notify and add + 1 to users (usage), return  selectedToken
// 2. Not found: Notify, return  selectedToken as null

  String? id;
  String token;
  int users_usage = 0;
  var _users = await thingi.get();
  print(_users.docs.length);
  // print(_users.docs.first.data());
  for (var user in _users.docs) {
    // print(user.data());
    id = user.id;
    token = user.get('Token');
    users_usage = user.get('users_usage');
    print(
        '--------------\nusers_usage: $users_usage | Token: $token | doc id: $id');
    if (users_usage < 10) {
      selectedToken = token;
      await thingi
          .doc(id)
          .update({'users_usage': users_usage + 1})
          .then((value) => print('users_usage ++'))
          .catchError((error) => print('Failed to update user: $error'));

      print(
          '${users_usage + 1} / 10 selectedToken: $selectedToken (Success) \n--------------');
      return selectedToken;
    }
  }
  print('selectedToken = $selectedToken (Full)');
  return selectedToken;
}

void addTokens() {
  // List sample_tokens = ['x', 'y', 'z'];
// >> [x, y, z]  -> ['x', 'y', 'z'] (String Values)
  var copied_list =
      '[68366c6f6027bb1b3c9102013102b8ec, 4461d0e129417581891d1069f85a31bb, f831266acd5e0f9d50885afb9be28404, 3367ee333c93d308b407786938ee2107, a5ef2405a33dfda5d2e12bd45c5e5904, 4b6795ddb65bec5b650e5765276ad4f8, f4e200ec21eadc176ca134bf57908e1f, ef1291bcc9ffcdd1c9680c34c8632446, 013615f25b920b08e1c2e17451173ca8, 40269f7300f913fa44c891c896cc0e3b, 898d5ce37e4f5025fb69707a03047ae9, f852fdc7bd314ab681a634e59926f2df, b65c36e44b7a3692470fa5c2487f04a9, deb0f16df817ede75b180069e7a631cb, 6c66f8f9ed22c614bb1f9520e9c3cbeb, cb5b49264d2c5d3b88111abba7fa105f, 6380f43acc4df9e440de898ac4a7f2cc, 39bf0416e7afef93634d90019479c47c, cdd363841ac35668eee9e1f8c3d297d8, 28bcb46b156cca594c25d879ab62e81c, 7e3ad504b4fa31729a4987baf29bbe35, 40f9bb321f777f282bd8062213a2d62b, fc0383887e09927e4df59248d24b951e, 04a59a85c924ef1fd02f80f91cce63fa, 6ada335a45eb79f1a965779d77f5ce66, 1f250b4918a0d3d3b460257d35cf579e, 3e1a6d955258a3f1a040961c543fb9e5, 536ef6993a8553d029481741d60b7af7, 4ce0d9a619fb8583d88a261c90948510, 53dbc98150f6ee6c8f430d8df0d7bf5f, e784bf07bdfcfc9d08c7d34a1ca9166e, 8820a320cf7225b584ebf08666935233, 78db26d5a9dcf971cc4bc42d116113d3, 844af269312ce88a7f45108f0ac1f6c7, fe8719f107ffe0dfabd27f022b325b02, 89fb17cb04d5c84cbceb5ff86df873b8, 38a49d78e1bc1af07074126a6fae2639, 17bd4cc4ed24eb757e65b69ca37cdba7, aab5ae6aa59593f7259d19c810f12502, 44303516a79a926585d6227fb2f9ab5e, 1f42769899b865d6b4cdf3e0f044ec10, 5f1804db40267bc8dd9531a47712f590, 4fa264498ddadf270fdde9edc0b0d309, 4fa962f1a56a87874a6d740a9add098f, 0fce914da98efce113e21c9a66c12e5f, 80668657a6d5caac6b2e312a2939cbaf, 89300b9761cebec4068aea25b62f3994, 8ce5dc64b35ffb4f1eb1b364e00c7604, 32f4eaecce7ac5158d57a7a3b615deee, 5a12f7a70094bb58a5a3fff1da1acfe7, 72d5595b00eab52de43d2321ba8ebb39, cd77318c234917e10cbbfda8280ab863, b8a9157ca7d0dd8e7764e2df37c81cc3, b213abcf0fa6b52400ae2c7027d956b1, 8e5384544e52ff2ebca5910093b69d7a, 86b7acfb6ee15ea0dcf98731fd512d62, 1a48bc472e36fe014c58d925fcbccb2f, a2531ef8595a09967a9466a476c175d4, c1280e10f6fb76592a104f8a028d48bc, 5bcdfd4d8564dd3fb487971884cb2ac4, d1f7fc2c60e2b3f0814ad5e784af0025, 16746f542b20202b9bdee53ec99a2410, 0ca3e3e777dafcc563912a30b5094ba8, 5b49821625285e3aaa1629b828c421e3, ddb1f95d9ad40fd9745c86d1bad2d968, 496d70298dad68fac27949037cfc32f2, 1d1ec247fbf35896a597af842364b3de, d795dcb64f3adee80a891950a2bfae64, 44668111656c3ccf86295036354d3adc, 67f9e8c0ce97d73a6a5fa7a641d1b54d, 96c502c6441372c5e9e894e67009bdc3, 9350df89ac35bd9c5a33372b4e9a1822, 2bf70a6ace72e9f68c246943e4a63362, a8db9ca4e7fca81c5baf445ea3fc9b1c, d0edac735a637eeb35d18a6d1d71db92, a418cc5a263f44f90a94dfb2546ee37b, efb20fbf6d6dd2a09bbdb98392127077, cbb8150409dab3208bee2c99dea1fd43, c39d326d4ee0904f9330fb1d576e12c9, 13e7f9cfa4b6c148f2d1ecfad2d692c0, 0c7d4eb10ef2ce1d3be26723447ae8cf, 56243414f2154f6f45bb38655706aa77, 65e22412a1467d36a3ca6a2ffc21f5e8, 9faed59ac8df4c2a0ec2c19da4763a20, 9294b6819eb92e77fb5d0edc8165a6d8, 2088f00f70198472db612cf86f19fca0, 4bceb8a382e164647c72dbf748c2b11f, e25fd2920272dabd143d8c8e06b2de57, 0f91d7497f604b49eb8c329467c84af4, 13ec2ebd1d761d79658b6c5d68342243, e5fa9a7a727a527b0d1218bd24927c4d, f313c56df0fd0cf9a239a85700f2b641, 07c98d8d2b00394c31608ddf090a8fb3, 726958ed94a16fe159612e243356d1e8, d1632306be28b445843c7e2117f48258, d57e05007114fc46708f7491d20c31c1, 6575983eea96aa578cd5c72518c993a1, 3fd03d58f50e8e479fc5b545de7556c5, 9d5db37ee2af314ef9016f551ed05495, 50f037d1e86a605038865a0ac7fb4949, 3b698f03bbfaa9825d60ea495cc5f2e6, eacbadae47825ab058f690ae04163271, d3b9e7d41b57948a3b0a3866a73d9b6d, 8e6a6d64cd4cca28d7f668d9027b612b, ff1c0e8537717f8a5ed86f402863cb1e, 96cf4e8c631c98104d9aad100e56424c, 9aefa73c3964e57efa37e52ffd699e99, 6955bdb4b85c9b0e263c93a8cd489e4f, 40d2bf09b889773b4017986b80ebfc92, 82048d2e3fdbd6ca7f51d6e5bc7818b8, 2d0b185b4459f61a332bb7d2597b912e, baad471195c658aa904169cf503f2c93, 2db5149c99f44200439655eb3a2b3698, b4334bc892f41365497a1b0ae9f2ade6, cd0fc23c28fb4c2aa6aad641fd524369, 6db9fe79b5cdb90a2919727659b3a3b7, 5ded7385076dcd3b82c76df48da5ef2d, 7569e7205cf0266a267d58a41e4c4d65, 7faa167232bc261cb3e60dca8dd1fc3e, 005cc6945e8ba09e880d53fb756a2d96, b6a677fd6f321ac8171a6fd1dba3229b, c5551818c5f61a5104fd5a204cde192d, 7c811a602b1f78ab884089ff5ae982ed, b8714b0a9072593b612fc84117bdfe1b, 4c6211572045676f91af8830577b4807, b1b98234b9f447559a7462c216d5d435, 064b8053c96ebca93cf5340d9bba3f89, 85748e0a44cdc9830932879bdc084ddb, b5a1f3a2b5c90eac00780b78b92536b7, cca9dec8e5c53984bd9f07016641385a, 6b0ce4fed03fc22be3c40d0c50392666, 70c8a8c3397306db957aecccd12ac1ef, f435fcb2a01e9d2df031c3ab11b64277, 1ed938d7fd57466d5802d98b20dbbf8a, 1ad18ba313b5c6e0858646a1c525518b, 7667c53571e468b4ae406884a9323f89, 1db503d47aa1cbd4e2310a6473e51111, 583af4778e382fc68eaedec94a4808b1, d104320c7ee3563961e984761928a2d6, 46f304d2b59bb7243a762f26107bab38, 28b3241b1eaae102d815d6fb89487c6c, 99931aa2acb4258113599ae749b8ee85, 16e7d837a98e436a79814b2e41df5cf2, 920a250e9f9bff06ff4fad6a8d0f1612, 597301a0207895796a0260b80b3d96a5, bba02fce55e2dd2fc941691c0756cda1, 08b7ce64ff666ba1f350ce5f0041240c, ad1de41bf63333941e1aa0ae814cbfd1, 5a34901f8e184072aca9b7ef11ff0621, 7485213eb185e62d5747e1fbdbc7bbd3, 888d25d42a14ad4db55779d4360f845f, ef65bc17bd9c43d8e973e94fb6170423, 99c4c0585afe557ed0dd03da46f64d4f, 06766efe1d6f038481f36be3db5170c5, 5b53cef09c14bfa0fba63e45a1cdff5a, 2255c6a317e19b2e5630adf88dd977cf, e5565963841979f6c4aa3fbfd437b3b5, c1828e2fe6410cf82c83beef726e8815, f3611d050bb9c111594f1e9a6517495e, 48e90bb30382d75e65dd65bbd2661733, 4444b34e9bfc61ae260154f693737613, 11971a6e5608b0f2ad53458acf10cde8, 2fd5ed0126c1911755510943285e22f1, 71a5ba38a7850e8a67ef938606eaf552, 41b468865e694d18eddf51e19017b687, 2c399798186a581b5f2fb88e3e5249d4, 59312966ef0519552395386caa562612, 8412ce7b3e51d82d88ec97670aba9d9f, b113883c0548afdfaeb84204ec937e65, 01e9295b13fe2e8102a4808fe0159e40, 982f4bfa410fb152656690894b7d104e, 123079459bf792ed5b0de0ed6eed254e, 53d50b68e620cfcbd9af17090d8ef69e, eee80968114b62952f9722a56b64dd1c, cf736ca55b7df181bb5c70957f12c812, d0deafd94fde59b68667871538a2b0cb, c6cbdcb331d9aa67b708617df69b3f86, 29173c8d9246992f4f80ef0e760694be, 2226a40d6817d6767bef09539851fe43, 69679950215cf3e6fcd30212fbf4cef8, 39ed4c805e971943a6662f1f45445f8c, d6654ddd73d4bc48a8d55881ba46d9a9, a707ce7f879933fb14fd94a6edfcea42, 63bf178e810bec41db075c9cbe542c85, eb0714fae29e369018da2c16d7b33035, bf4e03384892e507a758e1d1353f8cee, 8f94ffae2ad4f2616973d3e74bd0bb68, 7f2656192574529f655df6ab31f9841e, c05bb38931468117fbc3e0d753d10a52, 48da6bac9802b9939a1feaf861517a9b, 4e12169b242484afebaf3519b7bcc03e, ea20f091c0dc215f894b79d50c7d4d0d, d35775db6d4fe618b0009c7686a7762f, e49a9647b44a295e0d534833f3fa0ef0, a83a3766631072bd5dbb2ebc5e4e5135, dacd889e50a83be6023ea037f87a1c3c, 8a5ba7a83c6f79d3f442f323c740dfdf, 2181f280573e826bdc09485b353c2745, 1e6c454d8519bceaf3645abfa5921d07, 7a1a450a22be26b309b87c3c4ab0bf77]';
  copied_list = copied_list.replaceAll('[', '');
  copied_list = copied_list.replaceAll(']', '');
  var copied_list_str = copied_list.split(', ');
  print(copied_list_str.first.runtimeType);
  print(copied_list_str.length);
  // print(copied_list_str);

  var forIndex = 0;
  for (var _token in copied_list_str) {
    forIndex++;
    // print(_token);
    // print(forIndex);
    addCustom(_token, forIndex);
  }
}

Future<void> addCustom(token, index) {
  return thingi
      // existing document in 'users' collection: "ABC123"
      .doc('Token $index')
      .set(
    {'Token': '$token', 'users_usage': 1, },
    SetOptions(merge: true),
  ).then((value) {
    print('Token $index Added');
  }).catchError((error) => print("Failed to merge data: $error"));
}
