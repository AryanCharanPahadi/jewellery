import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Api Helper/api_helper.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isReadOnly = false;
  List<String> _titles = [];
  int _currentTitleIndex = 0;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _startTitleAnimation();
  }

  void _startTitleAnimation() async {
    try {
      final List<Map<String, dynamic>> results =
          await ApiService.fetchJewellaryCategoryImages();
      _titles = results.map((item) => item['item_title'].toString()).toList();
      if (_titles.isNotEmpty) {
        _animationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
          if (mounted) {
            setState(() {
              _searchController.text = _titles[_currentTitleIndex];
              _currentTitleIndex = (_currentTitleIndex + 1) % _titles.length;
            });
          }
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
  }

  void _fetchSuggestions() async {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final List<Map<String, dynamic>> results =
          await ApiService.fetchJewellaryCategoryImages();
      _titles = results.map((item) => item['item_title'].toString()).toList();

      final match = _titles.firstWhere(
        (title) => title.toLowerCase() == query,
        orElse: () => "",
      );

      if (match.isNotEmpty) {
        context.go('/$match');
      } else {
        setState(() {
          _searchController.text = "Item not found";
          _isReadOnly = true;
        });
      }
    } catch (e) {
      setState(() {
        _searchController.text = "Item not found";
        _isReadOnly = true;
      });
    } finally {
      setState(() => _isLoading = false);
      _startTitleAnimation(); // Restart animation after search
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      readOnly: _isReadOnly,
      onTap: () {
        if (_isReadOnly) {
          setState(() {
            _searchController.clear();
            _isReadOnly = false;
          });
        }
        _stopAnimation();
      },
      onSubmitted: (_) => _fetchSuggestions(),
      decoration: InputDecoration(
        hintText: "Search...",
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        suffixIcon: _isLoading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
