import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamsa_store/app/modules/auth/controllers/auth_controller.dart';
import '../controllers/katalog_controller.dart';

class KatalogView extends StatefulWidget {
  @override
  _KatalogViewState createState() => _KatalogViewState();
}

class _KatalogViewState extends State<KatalogView> {
  final KatalogController katalogController = Get.put(KatalogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/img/kamsa/LOGO.png', height: 40),
            Get.find<AuthController>().isAdmin.value
                ? IconButton(
                    icon: Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      _showAddProductModal(context);
                    },
                  )
                : SizedBox(),
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
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const TabBar(
                  labelColor: Color(0xFF222222),
                  unselectedLabelColor: Color(0xFF222222),
                  indicatorColor: Color(0xFF222222),
                  tabs: [
                    Tab(text: 'Semua'),
                    Tab(text: 'Pelatihan'),
                    Tab(text: 'Magang'),
                  ],
                ),
              ),
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
          stock: product['stock'] ?? 'No Stock',
          image: product['image'] ?? 'assets/img/product/placeholder.png',
          onEdit: () {
            _showEditProductModal(context, product);
          },
          onDelete: () {
            _showDeleteProductDialog(context, product);
          },
        );
      },
    );
  }

  void _showAddProductModal(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _priceController = TextEditingController();
    final _stockController = TextEditingController();
    final _imagePicker = ImagePicker();
    XFile? _imageFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tambah Produk',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 20),
                _buildTextField(_titleController, 'Nama Produk'),
                SizedBox(height: 10),
                _buildTextField(_descriptionController, 'Deskripsi Produk',
                    maxLines: 3),
                SizedBox(height: 10),
                _buildTextField(_priceController, 'Harga Produk',
                    keyboardType: TextInputType.number),
                SizedBox(height: 10),
                _buildTextField(_stockController, 'Stok Produk',
                    keyboardType: TextInputType.number),
                SizedBox(height: 10),
                Row(
                  children: [
                    _imageFile == null
                        ? Text('No image selected')
                        : Image.file(File(_imageFile!.path),
                            width: 50, height: 50),
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () async {
                        final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedFile != null) {
                          _imageFile = pickedFile;
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty ||
                          _descriptionController.text.isEmpty ||
                          _priceController.text.isEmpty ||
                          _stockController.text.isEmpty) {
                        Get.snackbar(
                            'Error', 'Harap lengkapi semua informasi produk');
                      } else {
                        // Logic to add product
                        Navigator.pop(context);
                        Get.snackbar('Success', 'Produk berhasil ditambahkan');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: Text('Tambah'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int? maxLines, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showEditProductModal(
      BuildContext context, Map<String, dynamic> product) {
    final _titleController = TextEditingController(text: product['title']);
    final _descriptionController =
        TextEditingController(text: product['description']);
    final _priceController = TextEditingController(text: product['price']);
    final _stockController = TextEditingController(text: product['stock']);
    XFile? _imageFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Produk',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 20),
                _buildTextField(_titleController, 'Nama Produk'),
                SizedBox(height: 10),
                _buildTextField(_descriptionController, 'Deskripsi Produk',
                    maxLines: 3),
                SizedBox(height: 10),
                _buildTextField(_priceController, 'Harga Produk',
                    keyboardType: TextInputType.number),
                SizedBox(height: 10),
                _buildTextField(_stockController, 'Stok Produk',
                    keyboardType: TextInputType.number),
                SizedBox(height: 10),
                Row(
                  children: [
                    _imageFile == null
                        ? Text('No image selected')
                        : Image.file(File(_imageFile!.path),
                            width: 50, height: 50),
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          _imageFile = pickedFile;
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty ||
                          _descriptionController.text.isEmpty ||
                          _priceController.text.isEmpty ||
                          _stockController.text.isEmpty) {
                        Get.snackbar(
                            'Error', 'Harap lengkapi semua informasi produk');
                      } else {
                        // Logic to update product
                        Navigator.pop(context);
                        Get.snackbar('Success', 'Produk berhasil diedit');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: Text('Simpan'),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteProductDialog(context, product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Hapus Produk'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteProductDialog(
      BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Produk'),
          content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Logic to delete product
                Navigator.pop(context);
                Get.snackbar('Success', 'Produk berhasil dihapus');
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String stock;
  final String image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ProductCard({
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = Get.find<AuthController>().isAdmin.value;

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
                SizedBox(height: 1),
                Text(
                  'Stock: $stock',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (isAdmin) {
                    onEdit(); // For admin, trigger edit functionality
                  } else {
                    Get.snackbar("Order",
                        "You have ordered $title!"); // For user, trigger order functionality
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF222222),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isAdmin ? "Edit" : "Order"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
