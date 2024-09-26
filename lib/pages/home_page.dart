import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Manager'),
      ),
      drawer: SideMenu(),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Menambahkan latar belakang gambar
          Column(
            children: [
              _buildWelcomeBanner(), // Menambahkan banner selamat datang
              Expanded(
                child: _buildGridMenu(context), // Menambahkan grid menu untuk akses cepat
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Membuat latar belakang gambar
  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'), // Sesuaikan dengan path gambarmu
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Membuat welcome banner
  Widget _buildWelcomeBanner() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          'Welcome, $_username!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Membuat grid menu dengan akses cepat ke berbagai fungsi
  Widget _buildGridMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildGridItem(
            context,
            icon: Icons.book,
            label: 'Book List',
            route: '/book_list',
          ),


          _buildGridItem(
            context,
            icon: Icons.logout,
            label: 'Logout',
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  // Membuat item grid yang berisi ikon dan label
  Widget _buildGridItem(BuildContext context, {required IconData icon, required String label, String? route, Function? onTap}) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk logout
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
