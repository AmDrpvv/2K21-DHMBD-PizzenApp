import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/Screens/ContactPage.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Database.dart';
import 'package:kabootr_app/Widget/Drawer.dart';
import 'RecentChatScreen.dart';

class Homepage extends StatefulWidget {
  final String title;
  final String userID;
  Homepage({@required this.userID, @required this.title});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PageController pageController;
  int pageCount;
  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController();
    pageCount = 0;
    super.initState();
  }

  void pageNavigation(page) {
    pageCount = page;
    pageController.jumpToPage(pageCount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: DatabaseService(uid: widget.userID).onlyUserStream,
      builder: (context, snapshot) {
        return !snapshot.hasData ? Loading() : Scaffold(
          endDrawer: CustomDrawer(user : snapshot.data),
          body: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: 20.0,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context).primaryColor,
                primaryColor: Theme.of(context).accentColor,
                textTheme: Theme.of(context).textTheme.copyWith(
                      caption: TextStyle(color: Colors.grey[500]),
                    ),
              ),
              child: BottomNavigationBar(
                elevation: 0.0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedIconTheme: IconThemeData(size: 30.0),
                unselectedIconTheme: IconThemeData(size: 20.0),
                currentIndex: pageCount,
                onTap: pageNavigation,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.chat,
                      ),
                      label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.camera,
                      ),
                      label: 'account'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.contacts,
                      ),
                      label: 'settings'),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5.0,),
                          Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/logoA.png'),
                                fit: BoxFit.fill
                              )
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          Text(
                            widget.title,
                            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700),
                          ),
                      ],
                    ),
                  ),
                  Builder(builder: (context) => IconButton(
                    icon: Icon(Icons.menu_rounded),
                    onPressed:() => Scaffold.of(context).openEndDrawer()
                  )
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      )),
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                )
            ),
            Container(
              color: Theme.of(context).primaryColor,
              height: 20.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: PageView(
                  onPageChanged: (page){
                    pageCount = page;
                    setState(() {});
                  },
                  controller: pageController,
                  children: [
                    RecentChatScreen(userID: widget.userID),
                    Container(
                      child: Center(child: Icon(Icons.camera, size: 35.0,)),
                    ),
                    ContactPage(userID: widget.userID),
                  ],
                ),
              ),
            )
          ],
        ));
      }
    );
  }
}
