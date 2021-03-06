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
      title: 'Instagram Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SignIn(),
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
/*
45줄 why not use ' List<Widget> ' ?
List<Widget> : bottomNavigationBar 에서 하단탭을 클릭하면 화면 전환이 이루어 지는데 기존에 생성되어 있는 화면은 삭제가 되고 새로운 위젯이 생성되어 화면을 보여줌. 10번의 화면 전환이 이루어 지면 10번의 생성과 소멸이 이루어짐.
IndexedStack : 이 위젯은 5개의 자식이 있으면 5개의 자식이 한번만 생성이 되고 Stack처럼 겹쳐져 있다가 사용자가 보고자 하는 화면은 맨위로 올라와서 보여줌. 10번의 화면 전환이 이루어 져도 각각 화면의 갯수만큼만 1번씩의 생성만 이루어짐.
 */

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
                          text: '무플방지 위원회'),
                    ]),

              ),
              SizedBox(
                height: common_xxs_gap,
              ),
               Text(
                        new DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime)).toString(),
                        style: TextStyle(color: Colors.grey[700], fontSize: 11),
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
        '좋아요 57개',
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
              TextSpan(text: 'ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ'),
            ]),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: Appbar 왼쪽에 들어갈 위젯설정
          leading:
              _iconButton(null, 'images/actionbar_camera.png', Colors.black),
// 아래코드를 중복을 줄이기 위해 _iconButton 사용
/*
          leading: IconButton(
          onPressed: null,
          icon: ImageIcon(
            AssetImage('images/actionbar_camera.png'),
            color: Colors.black,
          ),
        ),
*/

          // title: Appbar에서 leading영역 오른쪽에 들어갈 타이틀영역
          title: Image.asset('images/insta_text_logo.png', height: 26),
          // Appbar에서 오른쪽영역에 들어갈 위젯들 설정
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
  // _selectedIndex: IndexedStack 위젯에서 사용할 현재 선택된 인덱스 정보를 담고 있는 변수
  int _selectedIndex = 0;

  // _widgetOptions: 현재 선택된 인덱스에 따른 body에 표현해줄 화면정보를 담고 있는 변수
  static List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    Search(),
    Container(),
    Follow(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: 인덱스 번호를 매긴 자식들을 가지고 있는 위젯
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
    if(index == 2){
      openCamera(context);
    }else{
       setState(() {
        _selectedIndex = index;
      });
    }
  }
  /* onItemTapped 수정 -> tabIndex 가 2일 떄, 하단의 bottomNavigation 에서 3번째에 있는 아이콘을 누를 때,
     openCamera 메소드 호출, 카메라는 별도의 화면전환이 필요하기 떄문에 Navigator를 사용
  */
  void openCamera(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Camera()),
    );
  }
  // Navigator: 화면 전환을 위해 사용하는 클래스이며, push는 다음 pop은 이전 등으로 사용
  // context: 현재 화면의 상태를 줘야하기 때문에 사용
  // MaterialPageRoute: Navigator.push는 MaterialPageRoute 위젯을 통해 화면간 이동
}

// Start the Camera Class

class Camera extends StatefulWidget{
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera>{
  int _selectedIndex = 1;
  var _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       title: Text(
         'Photo',
         style: TextStyle(fontWeight: FontWeight.bold),
       ),
       actions: <Widget>[
         IconButton(
           icon: Icon(Icons.close),
           onPressed: () {
             Navigator.pop(context);
           },
         )
       ],
    ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState((){
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          _galleryPage(),
          _photoPage(),
          _videoPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[50],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/grid.png')),
            label: 'GALLERY'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/grid.png')),
              label: 'PHOTO'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/grid.png')),
              label: 'VIDEO'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index){
    _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
    );
  }

  Widget _galleryPage() {
    return Container(
      color: Colors.red,
    );
  }
  
  Widget _photoPage(){
    return Container(
      color: Colors.green,
    );
  }
  
  Widget _videoPage(){
    return Container(
      color: Colors.yellow,
    );
  }
  // _selectedIndex: 현재 선택된 화면 index 변수
  // PageController: PageView에 표시되는 화면을 컨트롤하는 클래스
  // PageView: 여러 화면을 스와이프 할 수 있게 해주는 위젯
  // pageview에 controller 속성은 pageController를 넣어줘야 함
  // onPageChanged: 페이지 전환을 할 때 실행되는 속성
  // children에는 전환할 페이지 위젯들을 넣어줌
  // _pageController.animateToPage는 하단 탭을 눌렀을 때, 어떤 방식으로 움직일지 설정

}

// End the Camera Class

// Start the Profile Class

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  bool _menuOpenState = false; // 상단 햄버거 버튼 눌렀을 때, 사이드메뉴 오픈여부
  late Size size; // size 변수
  late double menuWidth; // 메뉴가로길이
  int duration = 200; // 사이드 메뉴가 열리고 닫힐 시간
  AlignmentGeometry tabAlign = Alignment.centerLeft;

  // SliverToBoxAdapter 변수 생성
  double _gridMargin = 0;
  late double _myImgGridMargin = size.width;

  @override
  Widget build(BuildContext context){
    size = MediaQuery.of(context).size;

    menuWidth = size.width / 1.5;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _rightSideMenu(),
          _profile(),
        ],
      ),
    );
  }

  // MediaQuery.of(context).size: 현재 디스플레이 화면 사이즈정보
  // size.width / 1.5: 현재 디스플레이 사이즈에 75%정도 크기로 설정
  // Stack: 여러 위젯을 겹쳐서 관리할 때, 사용하는 위젯
  // _rightSideMenu: 햄버거 버튼을 눌렀을 때, 오른쪽에서 튀어나오는 메뉴영역
  // _profile: 바닥페이지 profile 영역

  Widget _rightSideMenu(){
    return AnimatedContainer(
      width: menuWidth,
      curve: Curves.linear,
      color: Colors.grey[200],
      duration: Duration(milliseconds: duration),
      transform: Matrix4.translationValues(
          _menuOpenState ? size.width - menuWidth : size.width, 0, 0),
      child: SafeArea(
        child: SizedBox(
          width: menuWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileSideMenu(),
            ],
          ),
        ),
      ),
    );
  }

  // AnimatedContainer: 일정 시간동안 점차적으로 변화하는 애니메이션 위젯
  // width: 해당 애니메이션을 적용할 가로크기지정
  // curve: 애니메이션을 적용할 방식지정
  // color: 적용할 위젯 색깔지정
  // duration: 시간지정(얼마동안 애니메이션을 지속할지 Duration 위젯으로 지정)
  // transform: 애니메이션을 어느형식으로 재생할지(x,y,z 지정, 오른쪽에서 왼쪽으로, 아래서 위로 등등)
  // SafeArea: 보통 디스플레이에서 맨 위에 시간, 배터리 정보 등등 이랑 겹쳐서 보여지는데 SafeArea는 그런 정보 바로 아래서부터 보여주는 위젯


  Widget _profile(){
    return AnimatedContainer(
      curve: Curves.linear,
      color: Colors.transparent,
      duration: Duration(milliseconds: duration),
      transform: Matrix4.translationValues(_menuOpenState ? -menuWidth : 0, 0, 0),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _appBar(),
            _profileHeader(),
          ],
        ),
      ),
    );
  }

  Row _appBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: common_gap),
            child: Text(
              'MinHyeok',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _menuOpenState = !_menuOpenState;
              });
            },
            icon: Icon(Icons.menu))
      ],
    );
  }

  Expanded _profileHeader() {
    return Expanded(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
                _header(),
                _userName(),
                _profileComment(),
                _editProfile(),

                // _tabIcons: tab 역할을 하는 icon 표현 method
                // _animatedBar: _tabIcons 에서 표현한 아이콘을 선택 효과를 주기위한 method
                _tabIcons(),
                _animatedBar(),
              ])),
          _getImageGrid(context),
        ],
      ),
    );
  }
  // silvers: CustomScrollView의 자식들을 넣는 스크롤 가능영역의 설정속성
  // SliverList: ListView와 비슷하게 동작하며 sliver 하위 위젯으로 사용하고 하위로 delegate속성을 사용한다.
  // SliverChildListDelegate: delegate속성에 사용하는 위젯이며, List 적용 (List 이므로 [] 배열로 작성해준다.)

  Row _header() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(getProfileImgPath('userName')),
          ),
        ),
        Expanded(
          child: Table(
            children: [
              TableRow(children: [
                _getStatusValue('473'),
                _getStatusValue('8k'),
                _getStatusValue('45k'),
              ]),
              TableRow(children: [
                _getStatusLabel('Posts'),
                _getStatusLabel('Followers'),
                _getStatusLabel('Following'),
              ])
            ],
          ),
        )
      ],
    );
  }
  // CircleAvatar: 프로필 사진같은 아바타 적용 위젯
  // Table: 이름과 같이 테이블 형식의 데이터를 적용할 때, 사용
  // TableRow: Table 하위 자식으로 들어가며 위젯 하나당 한 줄씩 설정해줄 수 있음

  Center _getStatusValue(String value) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  Center _getStatusLabel(String value) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
    ),
  );
// Post, Followers, Following 영역을 만들어주는 자식들이며, FittedBox는 부모범위 안에서 자식위젯의 범위를 맞추는 위젯
// 자식이 데이터가 길어도 부모 영역을 벗어나지 않게 해준다.

  Padding _userName() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        'userName',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Padding _profileComment() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        'Making my Profile!',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  Padding _editProfile() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: SizedBox(
        height: 24,
        child: Container(
            color: Colors.white,
            child: OutlinedButton(
              onPressed: (){},
              child: Text(
                'Edit profile',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: BorderSide(color: Colors.black45),
              ),
            )
        ),
      ),
    );
  }
  // OutlineButton: border가 자동으로 잡혀있는 버튼입니다. 버튼을 흰색으로 만들기 위해 Container로 감싸고 white 색상을 줌
  // RoundedRectangleBorder: border 모양을 변경해주기 위한 위젯
  // BorderRadius.circular: border를 둥글게 만들어 주기위한 메소드 (안에 숫자가 커질수록 둥글어짐

  // Second
  // 변수 추가

  Row _tabIcons() {
    return Row(
      children: <Widget>[
        Expanded(
            child: IconButton(
              icon: ImageIcon(AssetImage('images/grid.png')),
              onPressed: () => _setTab(true),
              color: this.tabAlign == Alignment.centerRight
                  ? Colors.grey[400]
                  : Colors.black87,
            ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(AssetImage('images/saved.png')),
            onPressed: () => _setTab(false),
            color: this.tabAlign == Alignment.centerLeft
              ? Colors.grey[400]
              : Colors.black87,
          )
        ),
      ],
    );
  }

  _setTab(bool tableLeft){
    setState(() {
      if(tableLeft) {
        this.tabAlign = Alignment.centerLeft;
        _gridMargin = 0;
        _myImgGridMargin = size.width;
      }
      else {
        this.tabAlign = Alignment.centerRight;
        _gridMargin = size.width;
        _myImgGridMargin = 0;
      }
    });
  }

  Widget _animatedBar() {
    return AnimatedContainer(
      alignment: tabAlign,
      duration: Duration(microseconds: duration),
      curve: Curves.easeInOut,
      color: Colors.transparent,
      height: 1,
      width: size.width,
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
    );

  }
  // _tavIcons 에서 Expanded는 2개의 아이콘을 50%씩 영역을 주기 위해 사용
  // _setTab은 탭을 클릭했을 때, 어떤 탭을 클릭했는지 데이터 변경을 위한 method
  // AnimatedContainer는 appbar 만들때 사용했던 위젯


  SliverToBoxAdapter _getImageGrid(BuildContext context) {

    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            transform: Matrix4.translationValues(_gridMargin, 0, 0),
            duration: Duration(milliseconds: duration),
            height: size.height * 2,
            child: _imageGrid()

        /*  width: size.width,
            curve: Curves.linear,
            color: Colors.purple, */
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(_myImgGridMargin, 0, 0),
            duration: Duration(milliseconds: duration),
            height: size.height * 2,
            width: size.width,
            curve: Curves.linear,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }

  GridView _imageGrid() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(30, (index) => _gridImgItem(index)),
    );
  }

  CachedNetworkImage _gridImgItem(int index){
    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/id/$index/100/100',
      fit: BoxFit.cover,
    );
  }
  // GridView: 일반적으로 List는 한 row에 하나의 아이템만 등록 가능합니다. 하지만 여러개를 등록해야할 경우도 생기는데 그럴때 사용하는게 GridView 입니다.
  // Physics: 스크롤 사용여부를 정하는 속성. (NeverScrollableScrollPhysics 위젯은 사용하지 않겠다는 뜻) 해당 속성을 지정해주지않으면 스크롤이 안됩니다.
  // shrinkWrap: true를 해주면 사이즈를 컨텐츠 영역만큼만 높이를 잡아주겠다는 뜻
  // crossAxisCount: 가로로 몇개의 아이템을 넣어줄건지 정하는 속성
  // childAspectRatio: 가로세로비율을 정해주는 속성
  // List.generate: index를 사용해서 가변길이 리스트를 표현해줄때 사용

}

class ProfileSideMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 3,
          ),
          TextButton.icon(
            onPressed: null,
            icon: Icon(Icons.exit_to_app),
            label: Text(
              'Log out',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // BoxDecoration: 사이드메뉴가 열렸을 때, 바닥 프로필 페이지와 경계를 지어주기 위해 사이드 메뉴 왼쪽만 회색 실선을 그려주는 역할을 합니다.
  // FlatButton.icon: 이름에서 알 수 있듯이 버튼에 아이콘을 적용해서 보여줄 수 있는 역할을 합니다.
}

// End the Profile Class

// Start the Follow class

class Follow extends StatelessWidget {
  final List<String> users = List.generate(10, (i) => 'user $i');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView.separated(
          itemBuilder: (context, index){
            return _item(users[index]);
          },
          separatorBuilder: (context, index){
            return Divider(
              thickness: 1,
              color: Colors.grey[300],
            );
          },
          itemCount: 10,
        )
    );
  }
  /* List.generate: 임의로 데이터 생성
  ListView.separated: List를 만들어 주는 위젯이고, 뒤에 separated는 각각의 List에 구분자를 주기 위해 사용합니다.
  itemBuilder: 각각의 아이템들을 빌드할 때, 어떤식으로 빌드할건지 설정
  itemCount: 아이템의 갯수
  separatorBuilder: 구분자를 어떤식으로 줄건지 설정 위젯 리턴
  Divider: 구분자를 나타내주기 위한 위젯이고 List 사이에 실선을 넣어줄때 사용
  thickness: 두꼐를 얼마로 할지 설정 not null
*/
  ListTile _item(String user){
    return ListTile(
      leading: CircleAvatar(
        radius: profile_radius,
        backgroundImage: NetworkImage(getProfileImgPath(user)),
      ),
      title: Text(user),
      subtitle: Text('Follow & Unfollow Page Building..'),
      trailing: Container(
        height: 30,
        width: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.black87, width: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'following',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
        ),
      ),
    );
  }
// ListTile: 아이콘이나 특정 위젯과 일부 텍스트를 포함하는 고정 높이 행을 표현하는 List 위젯
// title, subtitle: 기본적으로 title을 주고 그 아래 subtitle 형식으로 자동적용
// trailing: title 뒤쪽에 표현해줄 위젯
}

// End the Follow class


// Start the Search class

class Search extends StatefulWidget{
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<Search>{
  var _searchData = '';
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Column(
        children: <Widget>[
          _searchInput(),
          _scrollImage(),
        ],
      ),
    );
  }
  // _searchData: inputbox에서 입력한 값을 저장하는 변수
  // _formKey: form에 적용할 식별가능한 유일키

  SizedBox _searchInput(){
    return SizedBox(
      height: 40,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: common_xs_gap),
          child: TextFormField(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 20,
            ),
             decoration: InputDecoration(
                labelText: _searchData.length > 0 ? '' : '검색',
              ),
            onChanged: (text){
              setState(() {
                _searchData = text;
              });
            },
            /*
            onFieldSubmitted: (data){
              setState(() {
                _searchData = data;
              });
            },
            */
          ),
        ),
      ),
    );
  }
  // SizedBox: textBox를 잡아주기 위해 사용
  // Form: TextFormField를 감싸주고 식별하기 위해 사용
  // TextFormField: html의 Input text와 동일한 기능
  // decoration: 해당 input에 여러가지 설정적용
  // onChanged: text에 변화가 생겼을 때, 실행되는 속성
  // onFieldSubmitted: 검색했을 때, 실행되는 속성

  Expanded _scrollImage(){
    return Expanded(
      child: CustomScrollView(
          slivers:<Widget>[
            SliverToBoxAdapter(
              child: GridView.count(
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 1,
                children: List.generate(30, (index) => _gridImgItem(index)),
              ),
            )
          ]
      ),
    );
  }
  CachedNetworkImage _gridImgItem(int index){
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: "https://picsum.photos/id/$index/100/100",
    );
  }
}

// End the Search class


// Start the SignIn class

class SignIn extends StatefulWidget{
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignIn>{
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Stack(
        children: <Widget>[
          SignInForm(),
          _goToSignUpPageBtn(context),
          //_scrollImage(),
        ],
      ),
    );
  }
}

Positioned _goToSignUpPageBtn(BuildContext context){
  return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        onPressed: null,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(style: TextStyle(), children: <TextSpan>[
            TextSpan(
              text: 'Don\'t have an account?',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black54,
              ),
            ),
            TextSpan(
                text: ' Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                )
            )
          ]),
        ),
      )
  );
  // Positioned: Stack의 위치를 조정하는 위젯
  // 'Dont\'t have an account?' 에서 \는 문자라는 것을 명시 ('표현)
}


class SignInForm extends StatefulWidget{
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body:Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(flex: 6),
                    Image.asset('images/insta_text_logo.png'),
                    Spacer(flex: 1),
                    _emailForm(),
                    Spacer(flex: 1),
                    _pwForm(),
                    Spacer(flex: 1),
                    _forgetPw(),
                    Spacer(flex: 1),
                    _confirmBtn(),
                    Spacer(flex: 1),
                    _orLine(),
                    Spacer(flex: 1),
                    _loginFaceBook(),
                    Spacer(flex: 2),
                    Spacer(flex: 6),
                  ],
              ),
           ),
        ),
    );
  }
// GlobalKey<FormState>: 유일 키를 가진 globalKey이고 해당 키로 Form 위젯 안에 있는 key값으로 부여해줍니다. 그럼 해당 Form 위젯 안에 있는 폼들의 상태를 부여한 globalKey가 가지고있는데, 이 값으로 유효성검사라든지 여러가지 일을 할 수 있습니다.
// TextEditingController: 이 클래스는 사용자가 해당 form의 값을 입력, 수정, 삭제할때마다 컨트롤러가 해당 리스너한테 값이 변경이 됐다고 알려줍니다. 그럼 해당 리스너는 그걸 전달받고 해당 필드가 어떻게 변경이 됐는지 현재 상태를 인식하고 기억할 수 있습니다.
// dispose(): 해당 메소드는 페이지가 소멸될 때, 실행되는 메소드로 그 안에 생성했던 controller를 소멸시켜줘야합니다. 그렇지 않으면 페이지가 끝나고 다른 페이지로 이동을 해도 메모리에 계속 남아있어서 불필요한 리소스 낭비가 발생합니다.
// resizeToAvoidBottomInset: 키보드를 열면 화면이 따라서 올라가게 됩니다. 그러면 화면이 망가지기 때문에 해당 현상을 방지해주는 속성입니다.
// key: _formKey: Form 위젯안에 key 속성을 통해 생성한 globalKey를 부여해줍니다.
// Spacer: 위젯간에 간격을 조정하는 역할을 합니다. flex 속성으로 비율을 정함 (ex. Spacer(flex: 2), Spacer(flex: 1) 이면 2:1 비율로 한다는 뜻)


  TextFormField _emailForm(){
    return TextFormField(
      controller: _emailController,
      decoration: getTextFieldDeco('Email'),
      validator: (value){
        if(value!.isEmpty || !value.contains('@')){
          return '이메일 형식이 옳바르지 않습니다.';
        }
        return null;
      },
    );
  }

  TextFormField _pwForm(){
    return TextFormField(
      controller: _pwController,
      decoration: getTextFieldDeco('Password'),
      validator: (value){
        if(value!.isEmpty){
          return '비밀번호 형식이 옳바르지 않습니다.';
        }
        return null;
      },
    );
  }

  Text _forgetPw(){
    return Text(
      'Forgotten password?',
      textAlign: TextAlign.end,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.blue[700],
      ),
    );
  }
// TextFormField: input text와 같은 역할
// controller: 어떤 컨트롤러로 리스너에 알려줄건지 설정해주는 속성
// validator: 이 속성을 통해 유효성 검사를 할 수 있음. 실행시점은 다 끝나고 나서 처음 생성했던 globalKey가 실행됐을 때.

  TextButton _confirmBtn(){
    return TextButton(
      onPressed: () {
        if(_formKey.currentState!.validate()){
          // 정상
          final route = MaterialPageRoute(builder: (context) => MainPage());
          Navigator.pushReplacement(context, route);
        }
      },
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          //disabledColor: Colors.blue[100],
        ),
      ),
      style: TextButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
    // _formKey.currentState.validate(): 이 메서드가 실행됐을 때, validator에 기재된 유효성 검사를 실행함.
    // RoundedRectangleBorder: border를 둥글게 하기위해 사용(모서리)
  }

  Stack _orLine() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          height: 1,
          child: Container(
            color: Colors.grey[300],
            height: 3,
          ),
        ),
        Container(
          height: 3,
          width: 50,
          color: Colors.grey[50],
        ),
        Text(
          'OR',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  TextButton _loginFaceBook(){
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: Colors.blue,
      ),
      onPressed:(){
        simpleSnackBar(context, 'facebook pressed');
      },
      icon: ImageIcon(
        AssetImage('images/icon/facebook.png'),
      ),
      label: Text('Login with Facebook'),
    );
  }

}

void simpleSnackBar(BuildContext context, String text){
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

InputDecoration getTextFieldDeco(String hint){
  return InputDecoration(
    hintText: hint,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    fillColor: Colors.grey[100],
    filled: true,
  );
  // SnackBar: 화면 하단에 알림창을 보여주는 위젯
}

// End the SignIn class
