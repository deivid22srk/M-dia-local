import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../services/tmdb_service.dart';
import '../services/file_picker_service.dart';

class MediaProvider with ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();
  final FilePickerService _filePickerService = FilePickerService();
  
  List<MediaItem> _mediaLibrary = [];
  List<MediaItem> _searchResults = [];
  MediaItem? _currentMedia;
  bool _isLoading = false;
  String? _errorMessage;
  
  List<MediaItem> get mediaLibrary => _mediaLibrary;
  List<MediaItem> get searchResults => _searchResults;
  MediaItem? get currentMedia => _currentMedia;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Adicionar mídia da biblioteca local
  Future<bool> addLocalMedia(String filePath) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Parse do nome do arquivo para extrair título
      MediaItem mediaItem = _filePickerService.parseFileName(filePath);
      
      // Tentar buscar informações na API TMDB
      List<MediaItem> searchResults = await _tmdbService.searchMulti(mediaItem.title);
      
      if (searchResults.isNotEmpty) {
        // Encontrar o resultado mais relevante
        MediaItem? bestMatch = searchResults.firstWhere(
          (item) => _isSimilarTitle(mediaItem.title, item.title),
          orElse: () => searchResults.first,
        );
        
        // Combinar dados da API com o caminho do arquivo local
        mediaItem = bestMatch.copyWith(filePath: filePath);
      } else {
        // Se não encontrar na API, usar apenas os dados do arquivo
        mediaItem = mediaItem.copyWith(
          posterPath: null,
          backdropPath: null,
          overview: null,
        );
      }
      
      _mediaLibrary.add(mediaItem);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Adicionar múltiplas mídias
  Future<void> addMultipleLocalMedia(List<String> filePaths) async {
    for (String filePath in filePaths) {
      await addLocalMedia(filePath);
    }
  }
  
  // Remover mídia da biblioteca
  void removeMedia(String mediaId) {
    _mediaLibrary.removeWhere((item) => item.id == mediaId);
    if (_currentMedia?.id == mediaId) {
      _currentMedia = null;
    }
    notifyListeners();
  }
  
  // Selecionar mídia atual
  void selectMedia(MediaItem media) {
    _currentMedia = media;
    notifyListeners();
  }
  
  // Buscar na API TMDB
  Future<void> searchMedia(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      notifyListeners();
      
      _searchResults = await _tmdbService.searchMulti(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // Limpar resultados de busca
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
  
  // Verificar similaridade de títulos
  bool _isSimilarTitle(String title1, String title2) {
    String clean1 = title1.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    String clean2 = title2.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    
    // Verificar se um contém o outro
    return clean1.contains(clean2) || clean2.contains(clean1);
  }
  
  // Obter URL da imagem
  String getImageUrl(String? path, {String size = 'w500'}) {
    return _tmdbService.getImageUrl(path, size: size);
  }
  
  // Carregar detalhes completos
  Future<void> loadMediaDetails(MediaItem media) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      MediaItem? details;
      if (media.mediaType == 'movie') {
        details = await _tmdbService.getMovieDetails(media.id);
      } else {
        details = await _tmdbService.getTvDetails(media.id);
      }
      
      if (details != null && media.filePath != null) {
        details = details.copyWith(filePath: media.filePath);
        selectMedia(details);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
