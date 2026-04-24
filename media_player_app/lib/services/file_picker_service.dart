import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/media_item.dart';

class FilePickerService {
  // Solicitar permissão de armazenamento
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Para Android 13+ (API 33+)
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      
      // Para Android 13+, também precisamos de permissão para fotos/vídeos
      if (!status.isGranted) {
        var photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted) {
          photosStatus = await Permission.photos.request();
        }
      }
      
      return status.isGranted || await Permission.photos.isGranted;
    }
    return true;
  }
  
  // Selecionar arquivo de mídia local
  Future<String?> pickMediaFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        return result.files.single.path!;
      }
    } catch (e) {
      print('Erro ao selecionar arquivo: $e');
    }
    return null;
  }
  
  // Selecionar múltiplos arquivos
  Future<List<String>> pickMultipleMediaFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );
      
      if (result != null) {
        return result.paths.whereType<String>().toList();
      }
    } catch (e) {
      print('Erro ao selecionar arquivos: $e');
    }
    return [];
  }
  
  // Extrair nome do arquivo sem extensão
  String extractFileName(String filePath) {
    final fileName = filePath.split('/').last;
    return fileName.replaceAll(RegExp(r'\.[^/.]+$'), '');
  }
  
  // Tentar extrair informações do nome do arquivo
  MediaItem parseFileName(String filePath) {
    final fileName = extractFileName(filePath);
    
    // Padrões comuns: Nome.Filme.2020.1080p.mp4 ou Nome.S01E01.mp4
    RegExp movieRegex = RegExp(r'(.+?)(?:\.\d{4})?(?:\.\d+p)?(?:\..+)?$', caseSensitive: false);
    RegExp seasonEpisodeRegex = RegExp(r'S(\d+)E(\d+)', caseSensitive: false);
    
    String title = fileName;
    int? season;
    int? episode;
    
    // Verificar se é episódio de série
    Match? seMatch = seasonEpisodeRegex.firstMatch(fileName);
    if (seMatch != null) {
      season = int.tryParse(seMatch.group(1) ?? '');
      episode = int.tryParse(seMatch.group(2) ?? '');
      
      // Remover S01E01 do título
      title = fileName.replaceAll(seasonEpisodeRegex, '').replaceAll(RegExp(r'[._-]+$'), '');
    } else {
      // Tentar extrair ano do título
      Match? movieMatch = movieRegex.firstMatch(fileName);
      if (movieMatch != null) {
        title = movieMatch.group(1)?.trim() ?? fileName;
      }
    }
    
    // Limpar título
    title = title.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    
    return MediaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      mediaType: (season != null && episode != null) ? 'tv' : 'movie',
      filePath: filePath,
      seasonNumber: season,
      episodeNumber: episode,
    );
  }
  
  // Obter tamanho do arquivo
  Future<String> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.length();
      
      if (bytes < 1024) {
        return '$bytes B';
      } else if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(2)} KB';
      } else if (bytes < 1024 * 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      } else {
        return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
      }
    } catch (e) {
      return 'Desconhecido';
    }
  }
}
