import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: const [
        StoreItem(title: "Python Kitobi", price: "30,000 so‘m"),
        StoreItem(title: "Flutter Kursi", price: "50,000 so‘m"),
        StoreItem(title: "Linux Darslari", price: "40,000 so‘m"),
        StoreItem(title: "Etik Xakerlik", price: "60,000 so‘m"),
      ],
    );
  }
}

class StoreItem extends StatelessWidget {
  final String title;
  final String price;

  const StoreItem({required this.title, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Xarid qilish uchun ochiladi
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag,
                  size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(price, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
