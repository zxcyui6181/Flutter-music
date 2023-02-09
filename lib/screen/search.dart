import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project01/screen/playScreen.dart';
import 'package:project01/screen/youtube.dart';

import '../daomodel/dbControl.dart';
import '../vomodel/musicVO.dart';

void main(){
  runApp(SearchPage());
}

class SearchPage extends StatefulWidget {

  static bool isMelon = false;

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final dbcontroller = DBControll();



  late List<Music> main_music_list = [];
  //Ditto, 2002, 전체를 담는 그릇
  late List<Music> display_list = [];
  //검색된 것들 d, 2 등등
  void updateList(String value){
    setState(() {
      display_list = main_music_list.where((element) => element.title.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

        initialRoute: '/',
        getPages: [
          GetPage(name: '/playScreen', page: () => PlayScreen()),
          GetPage(name: '/youtube',page: () => Player())

        ],

        home: Container(
            child:Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body:
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search for a music",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:22.0,
                          fontWeight:FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FutureBuilder(  future: dbcontroller.getAllMusic(),
                        builder: (context3, snap) {

                          main_music_list = snap.data as List<Music>;

                          if (!snap.hasData) {
                            // !snap.hasData는 자료가 없는경우(입력한게 없는경우)
                            return Center(
                              child: Text('자료없음'),
                            );
                          }

                          return TextField(
                            onChanged: (value) => updateList(value),
                            style: TextStyle(color: Colors.pinkAccent),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0XFF69F0AE),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "검색어를 입력하세요",
                              hintStyle: TextStyle(color: Colors.pinkAccent),
                              prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),

                            ),
                            cursorColor: Colors.pinkAccent,
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                          child: ListView.builder(

                              itemCount: display_list.length,
                              itemBuilder: (context3, idx) {
                                return Card(

                                  elevation: 3,
                                  child: ListTile(
                                    leading:Image.asset('${display_list[idx].image}', width: 50, height: 50),
                                    title: Text('${display_list[idx].title}'),
                                    subtitle: Text('${display_list[idx].artist}'),
                                    trailing:Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(icon: Icon(Icons.arrow_right_sharp),
                                          color: Colors.greenAccent,
                                          iconSize: 45.0,
                                          onPressed: (){
                                            Get.toNamed('/playScreen', arguments: {'image': '${display_list[idx].image}', 'title': '${display_list[idx].title}',
                                              'artist': '${display_list[idx].artist}', 'root': '${display_list[idx].root}'});
                                          },
                                        ),
                                        IconButton(
                                          icon:
                                          Icon(Icons.video_collection),
                                          color: Colors.red,
                                          iconSize: 30.0,
                                          onPressed: (){
                                            Get.toNamed('/youtube', arguments: {'title': '${display_list[idx].title}', 'youtube':  '${display_list[idx].youtube}'});

                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          )

                      ),
                    ]),
              ),
            )
        )
    );
  }
}