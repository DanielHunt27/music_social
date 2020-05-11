import 'package:flutter/material.dart';
import 'package:musicsocial/pages/home_page.dart';
import 'package:musicsocial/pages/notifications_page.dart';
import 'package:musicsocial/pages/post_page.dart';
import 'package:musicsocial/pages/profile_page.dart';
import 'package:musicsocial/pages/search_page.dart';

class PageManager extends StatefulWidget {
  PageManager({Key key}) : super(key: key);
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  HomePage homePage;
  PostPage postPage;
  NotificationsPage notificationsPage;
  ProfilePage profilePage;
  SearchPage searchPage;
  final Key keyhomePage = PageStorageKey("homePage");
  final Key keyPostPage = PageStorageKey("postPage");
  final Key keyNotificationsPage = PageStorageKey("notificationsPage");
  final Key keyProfilePage = PageStorageKey("profilePage");
  final Key keySearchPage = PageStorageKey("searchPage");

  final PageStorageBucket pageBucket = PageStorageBucket();
  List<Widget> pages;
  Widget currentPage;

  int _selectedIndex = 0;

  @override
  void initState() {
    homePage = HomePage(key: keyhomePage);
    postPage = PostPage();
    notificationsPage = NotificationsPage(key: keyNotificationsPage);
    profilePage = ProfilePage(key: keyProfilePage, uid: '-_@_-');
    searchPage = SearchPage(key: keySearchPage);

    pages = [homePage, searchPage, postPage, notificationsPage, profilePage];

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
