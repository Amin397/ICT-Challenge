
import 'package:itc_challenge/const/const1.dart';
import 'package:requests/requests.dart';

Future<Map> loginExpert() async {
  var res = await makePostRequestLogin(API_ROOT, {
    'authorization': "Basic VGVhbTY0NjcxNTgxOk5ONDk0NjU4ODU=",
    'apikey': 'ictchallenge',
    'Content-Type': 'application/json'
  }
  );
  return res.json(['success']);
}

Future<Map> signUp() async {
  var res = await makePostRequestLogin('http://94.182.190.122/authentication/signup', {
    'authorization': "Basic VGVhbTY0NjcxNTgxOk5ONDk0NjU4ODU=",
    'apikey': 'ictchallenge',
  }
  );
  return res.json();
}

Future<dynamic> makePostRequestLogin(String API,Map<String , String> params) async {
  return await Requests.post(API, headers: params);
}