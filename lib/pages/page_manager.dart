import 'package:flutter/material.dart';
import 'package:musicsocial/pages/home_page.dart';
import 'package:musicsocial/pages/notifications_page.dart';
import 'package:musicsocial/pages/post_page.dart';

class PageManager extends StatefulWidget {
  PageManager({Key key}) : super(key: key);
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  // TODO add other pages below!
  HomePage homePage;
  PostPage postPage;
  NotificationsPage notificationsPage;
  final Key keyhomePage = PageStorageKey("homePage");
  final Key keyPostPage = PageStorageKey("postPage");
  final Key keyNotificationsPage = PageStorageKey("notificationsPage");

  final PageStorageBucket pageBucket = PageStorageBucket();
  List<Widget> pages;
  Widget currentPage;

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO add other pages below!
    homePage = HomePage(key: keyhomePage);
    postPage = PostPage();
    notificationsPage = NotificationsPage(key: keyNotificationsPage);

    pages = [homePage, null, postPage, notificationsPage, null];

    currentPage = homePage;

    super.initState();
  }

  void _onItemTapped(int index) {
    // Sets state of current page
    setState(() {
      _selectedIndex = index;
      currentPage = pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO If user is logged out then show log in screen instead
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: pageBucket,
        key: PageStorageKey(widget.key),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [BoxShadow(color: Colors.black)],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              title: Text('Upload'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
