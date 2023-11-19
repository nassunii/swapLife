import 'package:flutter/material.dart';
import 'dart:convert';
import 'LayoutDrawer.dart';

class MyHome extends StatefulWidget {
  final List<dynamic> people;

  const MyHome(this.people);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin{
  TabController _tabController;
  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
            () => setState(() => _selectIndex = _tabController.index)
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget bulid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Check List"),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: TabBar(
          indicatorColor: Colors.black12,
          labelColor: Colors.indigoAccent,
          controller: _tabController,
          tabs: <Widget> [
            Tab(
              icon: Icon(
                _selectIndex == 0? Icons.person : Icons.person_2_outlined
              ),
              text: "Friends",
            ),
          ],
      ),
      ),
    )
  }
}