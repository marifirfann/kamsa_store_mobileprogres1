import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/katalog_admin_controller.dart';

class KatalogAdminView extends StatelessWidget {
  final KatalogAdminController katalogController = Get.put(KatalogAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // Reduced height for a smaller app bar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Image.asset(
              'assets/img/kamsa/LOGO.png',
              height: 40, // Smaller size for the logo
            ),
            // Search bar
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Slight shadow for subtle separation
      ),
      
      // Add background color to the entire body
      backgroundColor: Colors.white, 
      
      body: Obx(() {
        return DefaultTabController(
          length: 3, // Number of filters (Semua, Pelatihan, Magang)
          child: Column(
            children: [
              // Add margin to the TabBar
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const TabBar(
                  labelColor: Color(0xFF222222), // Color of the selected tab's text
                  unselectedLabelColor: Color(0xFF222222),
                  indicatorColor: Color(0xFF222222),
                  tabs: [
                    Tab(text: 'Admins'),
                    Tab(text: 'Pelatihan'),
                    Tab(text: 'Magang'),
                  ],
                ),
              ),
              // Add margin for TabBarView
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TabBarView(
                    children: [
                      _buildCourseList(),
                      _buildCourseList(filter: 'Pelatihan'),
                      _buildCourseList(filter: 'Magang'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Fungsi untuk menampilkan daftar produk berdasarkan filter
  Widget _buildCourseList({String? filter}) {
    var filteredProducts = filter == null
        ? katalogController.products
        : katalogController.products
            .where((product) => product['category'] == filter)
            .toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        var product = filteredProducts[index];
        return ProductCard(
          title: product['title'] ?? 'No Title',
          description: product['description'] ?? 'No Description',
          price: product['price'] ?? 'No Price',
          image: product['image'] ?? 'assets/img/product/placeholder.png',
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String image;

  const ProductCard({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar("Order", "You have ordered $title!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF222222),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Order"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
