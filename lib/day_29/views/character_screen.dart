import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../api/character_service.dart';
import '../models/character_model.dart';
import 'detail_screen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late Future<List<Result>> _charactersFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _charactersFuture = getCharacters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshCharacters() async {
    setState(() {
      _charactersFuture = getCharacters();
    });
    await _charactersFuture;
  }

  List<Result> _filterCharacters(List<Result> characters) {
    if (_searchQuery.isEmpty) {
      return characters;
    }

    final keyword = _searchQuery.toLowerCase();

    return characters.where((character) {
      final name = (character.name ?? '').toLowerCase();
      final species = (character.species ?? '').toLowerCase();
      final status = (character.status ?? '').toLowerCase();

      return name.contains(keyword) ||
          species.contains(keyword) ||
          status.contains(keyword);
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF03131D),
      appBar: AppBar(
        title:  Text('RICK & MORTY CHARACTERS'),
        centerTitle: true,
        backgroundColor:  Color(0xFF072634),
        foregroundColor:  Color(0xFFB8FF5C),
        elevation: 0,
      ),
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF03131D), Color(0xFF072634), Color(0xFF02070D)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                style:  TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari nama, status, atau species...',
                  hintStyle:  TextStyle(color: Colors.white54),
                  prefixIcon:  Icon(
                    Icons.search,
                    color: Color(0xFF7CF7C9),
                  ),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon:  Icon(Icons.clear, color: Colors.white70),
                        ),
                  filled: true,
                  fillColor:  Color(0xFF0C1D29),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Result>>(
                future: _charactersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding:  EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 220,
                              child: Lottie.asset(
                                'assets/animations/404 error page with cat.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                             SizedBox(height: 12),
                             Text(
                              'Gagal memuat data karakter.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                             SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _refreshCharacters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF7CF7C9),
                                foregroundColor:  Color(0xFF03131D),
                              ),
                              child:  Text('Coba lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final filteredCharacters = _filterCharacters(
                    snapshot.data ?? [],
                  );

                  if (filteredCharacters.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshCharacters,
                      child: ListView(
                        physics:  AlwaysScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 48,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: Lottie.asset(
                                    'assets/animations/empty box3.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                 SizedBox(height: 16),
                                 Text(
                                  'Karakter tidak ditemukan.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                 SizedBox(height: 8),
                                 Text(
                                  'Coba kata kunci lain atau tarik ke bawah untuk memuat ulang data.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshCharacters,
                    child: ListView.builder(
                      padding:  EdgeInsets.only(bottom: 12),
                      itemCount: filteredCharacters.length,
                      itemBuilder: (context, index) {
                        final character = filteredCharacters[index];
                        final status = character.status ?? 'Unknown';
                        final species = character.species ?? 'Unknown';

                        return Card(
                          color:  Color(0xFF0C1D29),
                          margin:  EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side:  BorderSide(color: Color(0x1F7CF7C9)),
                          ),
                          child: ListTile(
                            contentPadding:  EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                character.image ?? '',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade300,
                                    alignment: Alignment.center,
                                    child:  Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              character.name ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Padding(
                              padding:  EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor: _statusColor(status),
                                  ),
                                   SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '$status - $species',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:  TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing:  Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFF7CF7C9),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(character: character),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
