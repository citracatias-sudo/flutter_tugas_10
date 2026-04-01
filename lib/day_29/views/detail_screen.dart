import 'package:flutter/material.dart';

import '../models/character_model.dart';

class DetailScreen extends StatelessWidget {
  final Result character;

  const DetailScreen({super.key, required this.character});

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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1D29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1F7CF7C9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7CF7C9)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = character.status ?? 'Unknown';
    final species = character.species ?? '-';
    final gender = character.gender ?? '-';
    final origin = character.origin?.name ?? '-';
    final location = character.location?.name ?? '-';
    final type = (character.type == null || character.type!.isEmpty)
        ? '-'
        : character.type!;

    return Scaffold(
      backgroundColor: const Color(0xFF03131D),
      appBar: AppBar(
        title: Text(character.name ?? 'Detail'),
        backgroundColor: const Color(0xFF072634),
        foregroundColor: const Color(0xFFB8FF5C),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF03131D),
              Color(0xFF072634),
              Color(0xFF02070D),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  character.image ?? '',
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 320,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 48),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name ?? '',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: _statusColor(status),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$status - $species',
                            style: TextStyle(
                              color: _statusColor(status),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoTile(
                      icon: Icons.face_retouching_natural,
                      title: 'Species',
                      value: species,
                    ),
                    _buildInfoTile(
                      icon: Icons.info_outline,
                      title: 'Status',
                      value: status,
                    ),
                    _buildInfoTile(
                      icon: Icons.transgender,
                      title: 'Gender',
                      value: gender,
                    ),
                    _buildInfoTile(
                      icon: Icons.public,
                      title: 'Origin',
                      value: origin,
                    ),
                    _buildInfoTile(
                      icon: Icons.location_on_outlined,
                      title: 'Last Known Location',
                      value: location,
                    ),
                    _buildInfoTile(
                      icon: Icons.category_outlined,
                      title: 'Type',
                      value: type,
                    ),
                    _buildInfoTile(
                      icon: Icons.movie_creation_outlined,
                      title: 'Episode Count',
                      value: '${character.episode?.length ?? 0} episode',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
