import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

const double common_xxs_gap = 8.0;
const double common_xs_gap = 10.0;
const double common_s_gap = 12.0;
const double common_gap = 14.0;
const double common_l_gap = 16.0;
const double profile_radius = 16.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FeedAction Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MainPage(),
    );
  }
}

Widget _iconButton(onPressed, imageUrl, color) {
  return IconButton(
    onPressed: onPressed,
    icon: ImageIcon(
      AssetImage(imageUrl),
      color: color,
    ),
  );
}

String getProfileImgPath(String userName) {
  final encoder = AsciiEncoder();
  List<int> codes = encoder.convert(userName);
  int sum = 0;

  codes.forEach((code) => sum += code);
  final imgNum = sum % 1000;
  return "https://picsum.photos/id/$imgNum/30/30";
}

class Comment extends StatelessWidget {
  final String userName;
  final bool showProfile;
  final String dateTime;
  final String caption;

  Comment({
    required this.userName,
    this.showProfile = false,
    this.dateTime = '',
    required this.caption
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: showProfile,
          child: CircleAvatar(
            backgroundImage: NetworkImage(getProfileImgPath(userName)),
            radius: profile_radius,
          ),
        ),
        Visibility(
          visible: showProfile,
          child: SizedBox(
            width: common_xs_gap,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '  '),
                      TextSpan(
                          text: '???????????? ?????????'),
                    ]),

              ),
              SizedBox(
                height: common_xxs_gap,
              ),
              Visibility(
                visible: dateTime != null,
                child: dateTime == null
                    ? SizedBox()
                    : Text(
                        new DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime)).toString(),
                        style: TextStyle(color: Colors.grey[700], fontSize: 11),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FeedPage extends StatelessWidget {
  CachedNetworkImage _feedImage(int index) {
    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/id/$index/200/200',
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            )),
          ),
        );
      },
    );
  }

  Widget _feedHeader(int index) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(getProfileImgPath('$index')),
            radius: 16,
          ),
        ),
        Expanded(child: Text('UserName$index')),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black,
          ),
          onPressed: null,
        )
      ],
    );
  }

  Row _feedAction(int index) {
    return Row(children: <Widget>[
      _iconButton(null, 'images/heart_selected.png', Colors.red),
      _iconButton(null, 'images/comment.png', Colors.black87),
      _iconButton(null, 'images/direct_message.png', Colors.black87),
      Spacer(),
      _iconButton(null, 'images/bookmark.png', Colors.black87),
    ]);
  }

  Padding _feedLikes(int index) {
    return Padding(
      padding: EdgeInsets.only(left: common_gap, bottom: common_gap),
      child: Text(
        '????????? 57???',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

/*
  Padding _feedCaption(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: 'username $index',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '  '),
              TextSpan(text: '????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????'),
            ]),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: Appbar ????????? ????????? ????????????
          leading:
              _iconButton(null, 'images/actionbar_camera.png', Colors.black),
// ??????????????? ????????? ????????? ?????? _iconButton ??????
/*
          leading: IconButton(
          onPressed: null,
          icon: ImageIcon(
            AssetImage('images/actionbar_camera.png'),
            color: Colors.black,
          ),
        ),
*/

          // title: Appbar?????? leading?????? ???????????? ????????? ???????????????
          title: Image.asset('images/insta_text_logo.png', height: 26),
          // Appbar?????? ?????????????????? ????????? ????????? ??????
          actions: <Widget>[
            _iconButton(null, 'images/actionbar_igtv.png', Colors.black),
            _iconButton(null, 'images/direct_message.png', Colors.black),
          ]),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _feedHeader(index),
                _feedImage(index),
                _feedAction(index),
                _feedLikes(index),
                Comment(userName: 'commentMan', caption: '', showProfile: true, dateTime: '20210827'),
                Divider()
              ],
            );
          }),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // _selectedIndex: IndexedStack ???????????? ????????? ?????? ????????? ????????? ????????? ?????? ?????? ??????
  int _selectedIndex = 0;

  // _widgetOptions: ?????? ????????? ???????????? ?????? body??? ???????????? ??????????????? ?????? ?????? ??????
  static List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    Container(color: Colors.primaries[1]),
    Container(color: Colors.primaries[2]),
    Container(color: Colors.primaries[3]),
    Container(color: Colors.primaries[4]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: ????????? ????????? ?????? ???????????? ????????? ?????? ??????
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey[900],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(
              activeIconPath: "images/home_selected.png",
              iconPath: 'images/home.png'),
          _buildBottomNavigationBarItem(
              activeIconPath: "images/search_selected.png",
              iconPath: 'images/search.png'),
          _buildBottomNavigationBarItem(iconPath: "images/add.png"),
          _buildBottomNavigationBarItem(
              activeIconPath: "images/heart_selected.png",
              iconPath: 'images/heart.png'),
          _buildBottomNavigationBarItem(
              activeIconPath: "images/profile_selected.png",
              iconPath: 'images/profile.png'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {String? activeIconPath, required String iconPath}) {
    return BottomNavigationBarItem(
      activeIcon:
          activeIconPath == null ? null : ImageIcon(AssetImage(activeIconPath)),
      icon: ImageIcon(AssetImage(iconPath)),
      label: '',
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

/*
45??? why not use ' List<Widget> ' ?
List<Widget> : bottomNavigationBar ?????? ???????????? ???????????? ?????? ????????? ????????? ????????? ????????? ???????????? ?????? ????????? ????????? ?????? ????????? ????????? ???????????? ????????? ?????????. 10?????? ?????? ????????? ????????? ?????? 10?????? ????????? ????????? ????????????.
IndexedStack : ??? ????????? 5?????? ????????? ????????? 5?????? ????????? ????????? ????????? ?????? Stack?????? ????????? ????????? ???????????? ????????? ?????? ????????? ????????? ???????????? ?????????. 10?????? ?????? ????????? ????????? ?????? ?????? ????????? ??????????????? 1????????? ????????? ????????????.
 */
