import 'package:agritech/pages/component/Meteo/meteo_screen.dart';
import 'package:agritech/pages/component/advices/advices_screen.dart';
import 'package:agritech/pages/component/annonces/screen_annonces.dart';

import 'package:agritech/pages/component/price_market/price_market_screen.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Acceuil"),
            IconButton(onPressed: () {}, icon: Icon(Icons.person)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: HomePageAll(),
    );
  }
}

class HomePageAll extends StatefulWidget {
  const HomePageAll({super.key});

  @override
  State<HomePageAll> createState() => _HomePageAllState();
}

class _HomePageAllState extends State<HomePageAll> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.show_chart, color: Colors.green),
              title: Text("Prix du Marché"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PriceMarketScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.chevron_right),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.volume_up, color: Colors.green),
              title: Text("Annonces"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenAnnonces()),
                  );
                },
                icon: Icon(Icons.chevron_right),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.pets, color: Colors.green),
              title: Text("Météo"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MeteoScreen()),
                  );
                },
                icon: Icon(Icons.chevron_right),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.local_florist, color: Colors.green),
              title: Text("Conseils"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdvicesScreen()),
                  );
                },
                icon: Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyButtomNavigation extends StatefulWidget {
  const MyButtomNavigation({super.key});

  @override
  State<MyButtomNavigation> createState() => _MyButtomNavigationState();
}

class _MyButtomNavigationState extends State<MyButtomNavigation> {
  var _currrentIndex = 0;
  setCurrentIndex(index) {
    setState(() {
      _currrentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currrentIndex,
      onTap: (index) => setCurrentIndex(index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.green)),
        BottomNavigationBarItem(
          icon: Icon(Icons.volume_up, color: Colors.green),
        ),
        BottomNavigationBarItem(icon: Icon(Icons.pets, color: Colors.green)),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist, color: Colors.green),
        ),
      ],
    );
  }
}
