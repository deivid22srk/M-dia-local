import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/media_item.dart';
import '../services/media_provider.dart';
import 'player_screen.dart';

class MediaDetailScreen extends StatelessWidget {
  final MediaItem media;
  
  const MediaDetailScreen({Key? key, required this.media}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar com backdrop
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (media.filePath != null)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerScreen(media: media),
                      ),
                    );
                  },
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop image
                  media.backdropPath != null && media.backdropPath!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: mediaProvider.getImageUrl(media.backdropPath, size: 'original'),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[900],
                        ),
                  // Gradiente
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 120,
                          height: 180,
                          child: media.posterPath != null && media.posterPath!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: mediaProvider.getImageUrl(media.posterPath),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[800],
                                  child: Icon(
                                    media.mediaType == 'movie' ? Icons.movie : Icons.tv,
                                    size: 48,
                                    color: Colors.grey[600],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Informações
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              media.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (media.rating != null)
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${media.rating!.toStringAsFixed(1)} / 10',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            if (media.releaseDate != null)
                              Text(
                                'Lançamento: ${media.releaseDate}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            const SizedBox(height: 8),
                            if (media.filePath != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Arquivo Local',
                                      style: TextStyle(color: Colors.green, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sinopse
                  if (media.overview != null && media.overview!.isNotEmpty) ...[
                    const Text(
                      'Sinopse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      media.overview!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Botão de reproduzir
                  if (media.filePath != null)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerScreen(media: media),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: const Text(
                          'ASSISTIR AGORA',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Botão de remover
                  if (media.filePath != null)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.grey[900],
                              title: const Text('Remover da biblioteca?'),
                              content: const Text('Esta ação não apagará o arquivo do dispositivo.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    mediaProvider.removeMedia(media.id);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Remover'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Remover da Biblioteca'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
