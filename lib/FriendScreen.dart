import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:swap_life/MBTI/report.dart';

//전체 class 예선 구현
class FriendPage extends StatefulWidget {
  final List<String>? friendChecklist;
  final String? friendName;
  final String friendid;

  FriendPage({
    required this.friendChecklist,
    required this.friendName,
    required this.friendid,
  });

  @override
  State<FriendPage> createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage>
    with AutomaticKeepAliveClientMixin<FriendPage> {
  List<TodoItem> todoList = [];
  late Future<List<String>> mbti;
  Map<int, String> emojiMap = {};
  String mbtivalue = '';
  List<int> emojiValue = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if(todoList.length != 0) //get한 친구의 리스트가 있을 때
            Text("<${widget.friendName} checkList>",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          if(todoList.length != 0)
            Text("친구의 일상을 경험하고, 완료사항을 체크해보세요"),
          SizedBox(height: 25,),
          if(todoList.length != 0)
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.deepPurple,
                    value: todoList[index].isCompleted,
                    onChanged: (value) {
                      _toggleTodoItem(index);
                    },
                  ),
                  title: Text(
                    todoList[index].title,
                  ),
                  trailing: DropdownButton<String?>(
                    value: emojiMap[index],
                    items: [
                      '😍',
                      '😀',
                      '😊',
                      '😑',
                      '😩'
                    ].map((String emoji) {
                      return DropdownMenuItem<String>(
                        value: emoji,
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        emojiMap[index] = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          if(todoList.length != 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: ElevatedButton(
                onPressed: () {
                  emojiToint(emojiMap.values.toList());
                  print(emojiValue);
                  saveAll();
                  Navigator.push(context,
                      MaterialPageRoute(builder:
                          (context) => Mbti_report(friendid: widget.friendid, friendName: widget.friendName!)));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy_sharp),
                      SizedBox(
                        width: 40,
                      ),
                      Text('FINISH',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          if(todoList.length != 0)
            SizedBox(height: 50,),
          if(todoList.length == 0) //get한 친구의 리스트가 없을 때
            Center(
              child: Column(
                children: [
                  SizedBox(height: 145,),
                  Text("Friend's List", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,),),
                  SizedBox(height: 10,),
                  Text("친구의 CheckList를 가져와 일상을 경험해보세요",style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,))
                ],
              ),
            ),
        ],
      ),
    );
  }

  //Emoji state 김진영 구현
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.friendChecklist!.length; i++) {
      emojiMap[i] = '😊';
      emojiValue.add(0);
    }

    Future<List<String>> getFriendChecklist(String friendid) async {
      try {
        // Firestore 쿼리: friendid를 사용하여 해당 친구의 체크리스트 가져오기
        DocumentSnapshot checklistSnapshot = await FirebaseFirestore.instance
            .collection('checklist').doc(friendid).get();
        // 가져온 데이터를 friendChecklist에 추가
        Map<String, dynamic> datas = checklistSnapshot.data() as Map<String, dynamic>;
        List<String> mbti = [];
        for (int i = 0; i < datas['user_checklist'].length; i++) {
          mbti.add(datas['user_checklist'][i]['mbti']);
        }
        return mbti;
      } catch (e) {
        print('Error fetching friend checklist: $e');
        return [];
      }
    }
    mbti = getFriendChecklist(widget.friendid);
    // TodoList 초기화
    for (String item in widget.friendChecklist!) {
      todoList.add(TodoItem(title: item, isCompleted: false));
    }
  }

  void emojiToint(List<String?> emojis) {
    for (int i = 0; i < widget.friendChecklist!.length; i++) {
      String? emoji = emojis[i];
      switch (emoji) {
        case '😍':
          emojiValue[i] = 100;
          break;
        case '😀':
          emojiValue[i] = 80;
          break;
        case '😊':
          emojiValue[i] = 60;
          break;
        case '😑':
          emojiValue[i] = 40;
          break;
        case '😩':
          emojiValue[i] = 20;
          break;
        default:
          emojiValue[i] = 0; // 기본값 설정
          break;
      }
    }
  }

  void saveAll() async {
    kakao.User? user = await kakao.UserApi.instance.me();
    final db = FirebaseFirestore.instance;

    for (int i = 0; i < widget.friendChecklist!.length; i++) {
      // 문서의 경로 생성
      DocumentReference Ref = db
          .collection('checklist')
          .doc(user!.id.toString())
          .collection('friends')
          .doc(widget.friendid!);

      // 데이터를 저장할 맵
      Map<String, dynamic> data = {
        'item_$i': {
          'intMBTI': emojiValue[i],
          'checklist': widget.friendChecklist?[i],
          'MBTI' : (await mbti)[i],
          'isComplete': todoList[i].isCompleted,
          'index': i,
        }
      };

      try {
        DocumentSnapshot mine = await Ref.get();
        if (!mine.exists) {
          await Ref.set(data);
        } else {
          await Ref.update(data);
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  void _toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }
}

class TodoItem {
  final String title;
  bool isCompleted;

  TodoItem({required this.title, required this.isCompleted});
}