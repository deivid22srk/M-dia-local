import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/media_item.dart';
import '../services/media_provider.dart';

class MediaCard extends StatelessWidget {
  final MediaItem media;
  final VoidCallback? onTap;
  final bool showTitle;
  
  const MediaCard({
    Key? key,
    required this.media,
    this.onTap,
    this.showTitle = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Imagem de fundo
              AspectRatio(
                aspectRatio: 2 / 3,
                child: media.posterPath != null && media.posterPath!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: mediaProvider.getImageUrl(media.posterPath),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.movie,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                        ),
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
              
              // Gradiente superior
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Rating
              if (media.rating != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          media.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Tipo de mídia
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    media.mediaType == 'movie' ? 'Filme' : 'Série',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Título (opcional, aparece abaixo do card)
              if (showTitle)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      media.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              // Ícone de arquivo local
              if (media.filePath != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
