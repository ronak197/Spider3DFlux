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
      Text('get token $selectedToken (Hot restart to update) \n+1 users_usage'),
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
  var copied_list = // REPLACE THIS LIST!
      '[b209a003195f3b1536f59bdc240082c0, c7dd2e414b58d35fdf48d8a803191c81, 51dd8282d5065729a0dfee236a25ba53, e1aa9693e7714500e58fd2c587173ba6, 6a99a5ee358c202f77b690dc8c7cb7b3, 9d662ed6eef2b9af1ac98f023bf45d81, f13ba55d64f6e3b815ba08a5d6201efa, 2e9d811e6c8b9d13b2467dc7f33a8ac3, b0c46faa9b58cfff8af99d50a933fc79, 9c47bd5f3bf290943303beb1bbf37599, 1fbae4fdd0f325798174e93a0863f626, 7341d9639cebad7a427957d837a5abae, 8757337db9d92ae685f2fa6ce1fdc914, 4340db1a01db1ee9fc0eb3540c253840, 39048d3475ce717f4bb7f124f8f7e312, e4c8c42e136ce8c5e67b599ceff3ca9b, 7555d79c8db46ec4c22a6f9448ab6865, 30333a1587cf5f256f937f8b68cf74e8, 3ccc78177ef65f3b4936bffa07dfce29, a7c5f706bb87a7f726bd36ccd863a81e, b78c21f1a1ac82e8ed5d8d9bdaf6057a, 55049045df50841088191eac1aebf64d, 60602764ab27c2253fbee0d28e801e85, 6167598a9be0a5fc97da70a7c7adda89, 04a9ed154a2f9f2dfa4b30ad289cc2c8, 154a5af2f04a5098e9dcc74484152899, cde5c252d8fa29e8f6a7e2325bb2a08c, eb88b92f2bfd643be748e4f19d6feddd, c5a62a13be4abce2df597705ce6c36b9, a81426569897eba906df03437b896e4e, 6182abcacdb77786955cd646e4bd907f, 20e36e605c35db65372e6c9c97e46537, 335585425210a6e4ecd4a7b943b504e9, 4fe1f747e4ad3c6acb15502245d6a145, a1bd127788d3dfae47c3ef59720538c8, 39ad5410eda241d5e2d128187cb4b40f, ca0a9c783139abf5e3ebfcdfc936aa2c, 4dc9bcefdedb80f3a9e874473c21c334, 951298b509342e3b8fb479b8167103b7, 91ce422f636d6ce7e95c940acd13dc1d, 95ae4172a597d6fa17a181e322e1cd7c, 23430797c49c8d0de026c1e588688982, 229dcb34dbb33701a6e03a8514e23d30, f28acd14544843753d86c7db303eca59, a59a4cd2437c6e3309409fadca0478e5, 8cf15eea15b390b9fe86dfb134b3e6cd, 77acda2461ba98510cf0c9a92aba7a05, 45fb0dfe347fb321cbcbd527c90763c9, 82d8277cb9c550916bc5869a54856dc0, e5df32f53d6324a46de9011c5a9b2351, aa516093db08753f689a517b3008da5e, 9e6dd7cc9bb740924d03d16cc3abf19c, 43c84d451f8df28192839212c20e8c17, bb6d75c95409be6dca98b1dc1cc01063, 20c5daf113d4a742cf62b8a9becb05d0, ae0640047ad8f74e6747733663334031, f7c5a5f0930b2abdb2434ea3621a7a7f, 3d5532c51795af0a507ae5e69b2e21be, ecec4c40282425467fda0817d229913d, 0b1a69e57b9251e71760ca5152f28414, 94c43c8ed7fd57cc0540233a9e812d90, d5256bedb27c9cf241c44abcf151dba9, f115adf697bc74082d406341f8d78d85, 4567b6615fd027d3cf5813e0b7bfc62d, 5635bead08f1457e18d261124ae800ee, aeef4551dbb7f628b4f9935d7d9be3fe, db230795236fdd1f2cc9b5913bc4f519, 54a3aa4aa96929dbf2008df5b5106822, d3df1ec3302d067d3dbb0ec053add17c, 93f08fda239105f5e9359e6da87bb8e2, d41a060dfc5708adea234dcb3827c1a3, 284b9cf2d7f7e76f9b164a8a3a449b3c, 020291f99b5d6994bead8afef8d2b52e, 96cdbc10e205367e2677789c1c8c34bb, 844bb3e610edf6c58f83df743aadf20f, ee8ab04196fd749101422aece3e2fccc, 6b8f649d9ab563e0fcefe8cfd558aee6, ac5bb58d464654a10c30ae1399a75a59, af865e3255e6f7abd20f29828cbccd25, 4df635d46bf9e3de8969d272cc3ae5bf, efc2119d9e9666f32cd8561020340bc0, dcd628cb60d97fba60d5dfe270e98b61, b00607f6ea3d4791dd39ee674f5de43d, e78211d230a685dcd15b442d10a8b4ec, 8a5c20d18847ff0ccf81688ea9bb6dd1, be8424ab0ca98dc4ea26ed7cb7c6961f, 31b5bc6317d3eed669313a55a5afeb21, 347628ea4b2b0cd585d9a37e038ed77d, e3fb19f1d5d1ae47ce45c339e95c0ff4, e9b9587e22d8134d1fe4926b0d966459, acd167c0fdf8dc1e36d1900e460d37d5, 142c2668ee0ffbaf42aa64a6eda7c7a5, 1e5f0e0be47f89c8d9c83ad11fb0ff24, cfda9b118f533fdccfc1ad49052de8ec, 0665cdf53913d0f4fc6ce0bd5dd959e4, c8ea08921fbfd4ccbb2f8359af8ad262, 6e47bb04f6c12fe472dd50d0e39fe34d, 162c7d835274706d8fe49bbf2dcfc988, 114f49586995eab1e5cdbc23fe6927b2, 2470512493ad41dff9434f0caa754a4f, 620879a2abfd118c4d672c67843c10f7, 08c0ba4eb018782cd4ec5e515d2841f2, cf01bf7b314221e9a9d194b3be05dbf4, d9bf93b81dfd350ff6a20f1c4592b5b0, 848dba3f876da5ecedbd98dc895156d1, dc4bf3a0b294c6013b2e0e4736763ff1, c226deaa52d3b9fde1d729694ca1d825, 04b99ecc69e3e91e3a7d9298215027f1, e21bbc17aa27648c2607c06ba04c49b5, 463befe3e684ff7a32345d3c94eeedd2, 823525ce6080f97d6f300e6765f59062, 6e1b7281cd0bf78185136afdefb5f866, 246f510b5d24c1c32106df3a9306691b, 84dfea0617fc92a9d0506fd677eb617f, 349dcb71920115cf5778554b288475a2, ac844d268eb684d6c3fa4919ea3defce, 51f28b216d2ebe177e860e6cbc7c7790, f7fd3c460de1c325acd07099d310bdf2, 3dbeda74f201c0f3c6588da57ffe6871, 3d8475d3b9a061257eac8bfa666dc07a, 6dad1a7940cca5c7493861e54ddb26d7, 6b5dd5616963854d2411ae0b189712eb, 46146fef5424826b5edf71b524a4b647, be71670467004c29d26ec4b87775bf72, a27f6d42370cf31bd122e318dc858834, 67356d761a70e0f8c66a9304db5cdb8c, 3d06a6eb46e85766eb16cee065c95834, ab5d5a6b8b9e8f3a11869683455701fa, d8d53215806665604592b4754d6c2870, d7bce1bdf323a7b8021c439b190a1ba8, 2aff2f09d5c9c3184a39892ffc356aa6, 1f04d77e640516a6deef3d7ac7438da1, 8e92f907f19fd3415742b3b9eaae4893, 592d8858ba72a988efcf187581b9eae9, b25bc1ddf4a216359affe7baf54ea651, b2f6e0294098847276c071ca6222b97b, 22e39f9f60a45af5a41ebaa0c8f618e4, 3bb83d28fa35b6ea74b2519a6464f4ad, c8a3a0261b4b167c4a82bce02359dfe0, d2b2aa133e28976cd7e8275fb27c4595, 72674f5155b540f4ba5a495e84f0f5ad, 1e65f37690ff9cce9f6b65286c01a538, 7df974f886b01f8f695532ad789394f1, 5716484c01e900aebe948e2c95dd1691, d281a452ae027917c420e7aeae143074, a82106960c34a2b01601680fe0c113a1, 9eedf179b27ece33d2942bb2bdc653d2, 4ff476d48360d63cdd8565e2b3326ba2, 8200f9f4df438085f587acba15d8540c, ed98d86ff9e01a28282d2283e141aee3, 2617ab295b30f7fb7dd6b1ba4685c4a4, 455211d00c94f5a3133d5d7df52db18d, 1a6fa831e160d412714998113d9eee50, 0eb8f81a5244603ad2a2227c76045b30, 05aa5f14096065c00b9539328d79b5b1, a9ab43a257c626b90dd1146cf31c5c40, 64dabc68766258c61e0f72e7961ad2b7, 2c45bb3444f8bf2c3ffbb9ba4338f747, 0d35fd0ed8f6635f03037d5665a3b21f, ba95503eaebffdd703b6a94a1b1b22bb, ea754f0baf441c60e31401e6eb7be181, 75df0bb5a7b221acd06745338f9aa231, bb873a7724afecc5355dbb5b82bdf429, cee3bee2ca5811354ac14661b43be720, be3df3d23ebda2a755a825e00be30f52, 0c812faca6959bcde410ea83f5f6250a, 6c8c1d3b7ca7797add5eba3819ce65e0, 58e9c50bac3f0370db9dea01d0b11a3f, 14265969f8e932ac2427d67591f9909d, f6227b0b4e87c30eb98e9def8d8019c1, 5ba650d7808640d719cb302f28268703, 285d331eb14fb3149d2cdd104451ab97, ce929f76a7ee0ab30ef4e3fc853cbd7e, dfe0983cc77179ce23d5e4ff79722c2e, deb74d191f134d62697e4a3fdbb078d3, 98af8715e1eca26162be7a67bded71ff, 4d5497bace292ae8fdcdfda100d3a026, 5ea9a9d8455ccd64471073ef77157c24, 1ce6dc1eef662a20dde727714f60ec1d, 7b83014acbea5a60f65457ac103fa4f2, e5b2c85772dfa4365d12f408aeedf48e, 55d25b10b15d2beb1e0c3a7a103b38b3, 6a492760a69245542a42852245d824b1, 0233269bbd306f594b856c7bb182eb06, 3e64c9f7d8d9e6e91f918f1019819746, 061f9cf60c4ea49fd2dd787cadb09dcc, 2f58887058dee05f9411ceba1d332ae4, 359dc9e41bf337acc16ffbd74d41748e, 32fc3c47b8ddf9e176ef9f8a20859ffb, ed62ecb86fc9ba4ebcc1347fe540e2fc, 25e94c5d6b1c8ff5f12f31e59915e1fa, d1d65cd22b23a26d32fe85ad7352ccd9, bea1f3ac4d521d6487c132ff89e841b0, 1654a88f588fa1bc32d212e18834a212, 4090fba796b14995b2d9975bc37bd23b, 605ff6bd6fdc9bcc7179576d0ad8e923, c7a7d3c865fd8ac245c7f36d4bb2c37b, 6dbffcc4566d130481bc16b411b2e1c6, f605dc910498eb72a98299bf30142704, 75946e770c6ef25c11c71172abb6ce1f, ae6b181d9dbac2f978ce6a408a4d3a98, 2cb7bf32d66abbe4f52746c9fb1dde47, b60962da8f86a607931dac8bb95b5ce8, 944004213d9c901f795068f6e7ba4483, f681f007e3048c69572044d13483aa82, 19b3f56ef8f3757879078a6beb83d290, 6be588ad5c285d86cc0923785f4306df, 5d000027733ac321f93f715e88d62cba, 5ed893dd25ea7ac33522ba81232333f1, 798c1bedd2ba3ca1da617daf7b007779, 317fc9f0a47b6e46a7f2223f7e3df189, a32a46c1caf091e01bb2cc70e8f3abb4, 4ebf2638ecb42b24464b345423d5b1f3, 76d3a4390a1fff0bbb50efae9c28cd76, 6685e7ee4df9d4823567b26fdbf9ea0a, d1031edd6bd690abf4ecc8ab89e1899d, 1eae050dd9e43b4e27cc8580d7035c58, cf54a439a2d28a2e49b189ebdacb6ecd, 30dcce029d2f047c60bd743f569c8587, f2140a03592b2a2ea4d7b4d2cfb01638, 0af84dbdbcc0f704754cb498b5d69997, b20c607e3cca133d57fab20e82a51f3c, bc74073ad31b2e537e1f1c052f6c20ae, 54be0bbe9aca090744fe0361282dc1fe, 4ae2b7cf4106eec28d835baaafefe13e, d47c11b5d64a1a7f4776d990da24e5f6, 23cc9f9321c3dd8b4e05414fc67c9ef5, a6432dd6d51ad178720c3d353ff22452, a038be86f94358bfc835df62dd5635d0, 4b67fb616b45856edf45c760782a16d7, 5e5622f9bdf30abe598d771f141e5289, b0e4678fbe1331fd1195f6d529a531b6, e588e21a73590a234c28909345dc7a17, 2ea9ea00d06a30bf395497595ba8afc4, 9e45aa139dc3dee2194537d8a1d5a06e, 3d80b26565c86c5b6f22d6b9cc1ebbdd, f8b1a52cbadf91b3b0c9a2e682665522, b8c0311f8f34d2bbd5cd235a72fa5037, 7f49e192368425333b5836577d9d68a6, af7aba6484464cf5d940e603c6145102, 4d287419f007be5fa0e5142bd1e7d53f, 6b9a1353f59415ace8fd647ecf55cd52, f768d6f360382c50606cd7f355eff140, 64b3dce5d75de53de95058d17e1f4f9b, af8597fe137d407edc1da08b05eee1c3, 6070aa6d2766d625cfc89842fddd89ae, 213a67cc37fb015f085b4f153c6b6bb6, fc5deb998c0e78baff8c11de4422f746, 501128f44d772ddefa7c1d7e04203a1d, 759b23d48f17ab2d4eebe7c493abf415, 895967d747420b8af87db51c15833bef, b771aae59b81d315b6f49061a71a105c, 9afd4c2b11e97bc0f1050058cbea983b, bc042424b81c8314177e7608e3c39208, 2253febe7e543ed60fecec72ce91f49f, 6e85683a220d40b9e47953d20b0245f2, 511adcf32ae5a8641a8bbdfc3b461e4a, 4d79c653a9f7ce688983ccbc910b063e, 8f16ea0453dd15d0ec053263b685ad4e, 00c3963a0c14ff1430750da9e95e2ec7, cbd904ed7bb02ebf1f416550b3754235, 20b0ddf1e3ef194e5d756121518295fc, 45160fde471198abd6051a3b89708f54, dd1b33796d32cba73f9b40406b8e4afe, 38db5b89a0015dd7f60a012de818afca, 4323d1798585d42a93b62df3d52e728c, f2cdd1154a2bc885bf1fe905a42a5499, 253bf5bbfc336a0969e2e8b435018154, 6750cb5d09d218ec9cf589f300eafb81, de192e2531b1528616210a14b8fe8bf8, 65a8ecb7b9a8a1baaff46966a5c30081, 9f056d22b556c8d8e45b1e2814e6c446, 3c2908a6d6b7645108e74b3b2ff067a8, 0a5ddfce7dd40972a98a3c9004bc9a79, 3f4a0915989c328d7b534ea80be8ed78, e8d7f8f8f7ef2873e36b608c00ccedc0, dd1e41c676cec06cdc7f293763eb7ecd, 7ef4fb84bd0be26adad52cdf2dfa5724, 4d1f70b7903e2eafdbe1a34ab38dfa98, 5f9169e710a2661da4d4dff948586a4a, a24b0a70184910ba412807340ff225b9, 06d5258379b56e96ebbbc49f644ed2f8, 092d049692612c8bf0682cef2d5a60f4, 19d0cd548c693cc857a2b6ba2384141b, 88762b62bcf5937f89c9a5e998c56f56, a24053697b6ee658789792dd1ab1db83, e4b4c5b9d9359d24f9b39e42279279e9, 1fe667b3646a2096cf8693f9d6aa4515, 926ac210c7081d0173161973c2187832, 532b4d1e5d006741a9186e3a529a7e25, 45b6480f701ba956c870a6652ee3b387, 0d7afd0c1f2ef8b1eef836ec6ee43f7a, ed02d1a03668a27f60df59c4e7411563, 6aad941894464f406aa5d89e3aacdfdb, 0dfe4ef884c56a6f5264c76bb2a9c78e, 95999a5a8fa7d5cffcd796bd82bb60dc, 11aad812fb33d7ef41f951396bd833da, 86d2b4359c0c2e0248c30a27ca73e319]';
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
  print('$forIndex tokens added');
}

Future<void> addCustom(token, index) {
  var token_id = 'Token $index ${UniqueKey()}';
  return thingi
      // existing document in 'users' collection: "ABC123"
      .doc(token_id)
      .set(
    {
      'Token': '$token',
      'users_usage': 1,
      'token_doc_id': token_id,
    },
    SetOptions(merge: true),
  ).then((value) {
    print('Token $index Added');
  }).catchError((error) => print("Failed to merge data: $error"));
}
