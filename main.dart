import 'package:flutter/material.dart';
import 'package:flutter/src/material/page.dart';
import 'dart:core';
// import 'MyHome.dart';
FocusNode fnode=new FocusNode();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swap Life',
      theme: ThemeData(primaryColor: Colors.blueGrey[200]),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHome(),
        '/myHome': (context) => MyHome(),
        TodoScreen.routeName: (context) => TodoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );//상태값 변하므로 Stateful위젯 사용
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if(_selectedIndex==0) {
      bodyWidget = tabContainer(context, Colors.white, "Search Tab");
    } else if(_selectedIndex == 1) {
      bodyWidget = TodoScreen();
    } else {
      bodyWidget= tabContainer(context, Colors.white, "Profile Tab");
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {},icon: Icon(Icons.cloud_outlined)),
        iconTheme: IconThemeData(color: Colors.green),
        title: Text("Swap Life"),
        centerTitle: true,
        backgroundColor:Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            icon: Icon(
              _selectedIndex == 0 ? Icons.saved_search : Icons.search,
            ),
            text: "Search",
          ),
            Tab(
              icon: Icon(
              _selectedIndex == 1 ? Icons.home : Icons.home_outlined,
              ),
          text: "Home",
            ),
          Tab(
            icon: Icon(
              _selectedIndex == 2 ? Icons.person : Icons.person_outline,
            ),
            text: "Profile",
          ),
        ],
      ),
      body : bodyWidget,
    );
  }

  Container tabContainer(BuildContext context, Color tabColor, String tabText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: tabColor,
      child: Center(
        child: Text(
          tabText,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class TodoItem {
  String title; // 할 일 항목의 제목
  bool isCompleted;// 할 일 항목의 완료 상태

  TodoItem({required this.title, this.isCompleted = false});
}

class TodoScreen extends StatefulWidget {
  static const routeName = '/todo';
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> todoList = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Checklist"),
        centerTitle: true,
        backgroundColor:Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: fnode,
                    controller: textEditingController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(labelText: "Add a new task",labelStyle:TextStyle(color:fnode.hasFocus? Colors.green : Colors.grey),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)))  ,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addTodoItem(textEditingController.text);
                    textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: todoList[index].isCompleted,
                    onChanged: (value) {
                      toggleTodoItem(index);
                    },
                  ),
                  title: Text(todoList[index].title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteTodoItem(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addTodoItem(String title) {
    setState(() {
      todoList.add(TodoItem(title: title, isCompleted: false));
    });
  }

  void deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }
}

