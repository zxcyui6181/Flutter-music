import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project01/main.dart';
import 'package:project01/vomodel/userVO.dart';
import 'package:project01/screen/user_info.dart';

class authView extends StatefulWidget {
  _authView createState() => _authView();
}

class _authView extends State<authView> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();
  TextEditingController nick = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 40,
          margin: EdgeInsets.only(top: 50, right: 20, left: 20),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          child: Center(
            child: commonText('회원 가입'),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        commonText('아이디'),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 70,
          color: Colors.grey,
          child: Expanded(
              child: TextField(
            controller: id,
          )),
        ),
        commonText('비밀번호'),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 70,
          color: Colors.grey,
          child: Expanded(
              child: TextField(
            controller: pw,
          )),
        ),
        commonText('닉네임'),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 70,
          color: Colors.grey,
          child: Expanded(
              child: TextField(
            controller: nick,
          )),
        ),
        InkWell(
            onTap: () async {
              //회원가입 완료 했으니 해당 값 false로 바꾸기
              UserInfo.isAuth = false;
              //내부 저장소에 저장하기
              await _openDb();
              //Navigator.push 를 사용하여 다른 class로 화면이동

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            child: Container(
              width: 80,
              height: 60,
              color: Colors.yellow,
              child: Center(
                child: commonText('회원가입'),
              ),
            ))
      ]),
    );
  }

  commonText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.black, fontSize: 14),
    );
  }

  Future _openDb() async {
    //디비 Path가져오기
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');
    //디비 접속 하기
    final db = await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: (Database db, int version) => {
        db.execute(
            '''  CREATE TABLE users(
    No INTEGER PRIMARY KEY AUTOINCREMENT,
    id TEXT,
    pw TEXT,
    nick DATETIME)
  ''')
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
    //User model을 적은값으로 만들기
    var user = User(
      id: id.text,
      pw: pw.text,
      nick: nick.text,
    );
    //접속한 db에 User model 을 넣기
    await db.insert('users', user.toMap());
  }
}
