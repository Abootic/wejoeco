import 'package:flutter/material.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  // List of shops and products
  final List<Map<String, dynamic>> _shops = [
    {
      'shopName': 'Shop 1',
      'supplier': 'Supplier A',
      'products': [
        {'name': 'Product 1', 'price': 10.0},
        {'name': 'Product 2', 'price': 15.0},
      ],
    },
    {
      'shopName': 'Shop 2',
      'supplier': 'Supplier B',
      'products': [
        {'name': 'Product 3', 'price': 20.0},
        {'name': 'Product 4', 'price': 25.0},
      ],
    },
  ];

  // Shopping cart items
  final List<Map<String, dynamic>> _cart = [];

  // Add product to cart
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
    });
  }

  // Remove product from cart
  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  // Add a new shop
  void _addShop(String shopName, String supplier, List<Map<String, dynamic>> products) {
    setState(() {
      _shops.add({
        'shopName': shopName,
        'supplier': supplier,
        'products': products,
      });
    });
  }

  // Delete a shop
  void _deleteShop(int index) {
    setState(() {
      _shops.removeAt(index);
    });
  }

  // Handle purchase
  void _makePurchase() {
    if (_cart.isNotEmpty) {
      double totalAmount = 0.0;
      _cart.forEach((item) {
        totalAmount += item['price'];
      });

      // Show a dialog for purchase confirmation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Purchase Confirmed'),
          content: Text('Your total is \$${totalAmount.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _cart.clear(); // Clear the cart after purchase
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your cart is empty!')),
      );
    }
  }

  // Show a dialog to add a new shop
  void _showAddShopDialog() {
    TextEditingController shopNameController = TextEditingController();
    TextEditingController supplierController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Shop'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: shopNameController,
              decoration: InputDecoration(labelText: 'Shop Name'),
            ),
            TextField(
              controller: supplierController,
              decoration: InputDecoration(labelText: 'Supplier'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addShop(
                shopNameController.text,
                supplierController.text,
                [], // Empty products list for now
              );
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Market',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddShopDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // List of Shops (with Scrollable List)
          Expanded(
            child: ListView.builder(
              itemCount: _shops.length,
              itemBuilder: (context, index) {
                var shop = _shops[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(shop['shopName']),
                    subtitle: Text('Supplier: ${shop['supplier']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteShop(index),
                    ),
                    children: [
                      ...shop['products'].map<Widget>((product) {
                        return ListTile(
                          title: Text(product['name']),
                          trailing: Text('\$${product['price']}'),
                          onTap: () => _addToCart(product),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),

          // Shopping Cart Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Shopping Cart (${_cart.length})',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._cart.map((item) {
                    return ListTile(
                      title: Text(item['name']),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          _removeFromCart(_cart.indexOf(item));
                        },
                      ),
                    );
                  }).toList(),
                  if (_cart.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _makePurchase,
                        child: Text('Make Purchase'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}