import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = ['Shoes', 'Jacket', 'Dress', 'Watch'];
  List<String> popularSearches = ['Summer Dress', 'Running Shoes', 'Leather Jacket', 'Smartwatch'];
  List<String> searchResults = [];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults.clear();
      } else {
        searchResults = popularSearches
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Search',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      searchResults.clear();
                    });
                  },
                )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Display Search Results or Recent/Popular Searches
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildRecentAndPopularSearches(),
            ),
          ],
        ),
      ),
    );
  }

  // Build Search Results
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            // Handle item tap (e.g., navigate to product page)
          },
        );
      },
    );
  }

  // Build Recent and Popular Searches
  Widget _buildRecentAndPopularSearches() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: recentSearches.map((search) {
              return Chip(
                label: Text(search),
                onDeleted: () {
                  setState(() {
                    recentSearches.remove(search);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Popular Searches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: popularSearches.map((search) {
              return Chip(
                label: Text(search),
                onDeleted: () {
                  setState(() {
                    popularSearches.remove(search);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}