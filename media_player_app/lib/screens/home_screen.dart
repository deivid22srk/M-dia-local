import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/media_card.dart';
import '../screens/media_detail_screen.dart';
import '../services/media_provider.dart';
import '../services/file_picker_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _LibraryTab(),
          _SearchTab(),
          _SettingsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.grey[900],
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Biblioteca',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}

// Tab da Biblioteca
class _LibraryTab extends StatelessWidget {
  const _LibraryTab();
  
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaProvider>(context);
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Minha Biblioteca',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  // Botão de adicionar arquivo único
                  IconButton(
                    onPressed: () async {
                      final filePickerService = FilePickerService();
                      
                      // Solicitar permissão
                      final hasPermission = await filePickerService.requestStoragePermission();
                      if (!hasPermission) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Permissão de armazenamento necessária')),
                          );
                        }
                        return;
                      }
                      
                      // Selecionar arquivo
                      final filePath = await filePickerService.pickMediaFile();
                      if (filePath != null && context.mounted) {
                        final success = await mediaProvider.addLocalMedia(filePath);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mídia adicionada com sucesso!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erro ao adicionar mídia')),
                          );
                        }
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  // Botão de adicionar múltiplos arquivos
                  IconButton(
                    onPressed: () async {
                      final filePickerService = FilePickerService();
                      
                      final hasPermission = await filePickerService.requestStoragePermission();
                      if (!hasPermission) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Permissão de armazenamento necessária')),
                          );
                        }
                        return;
                      }
                      
                      final filePaths = await filePickerService.pickMultipleMediaFiles();
                      if (filePaths.isNotEmpty && context.mounted) {
                        await mediaProvider.addMultipleLocalMedia(filePaths);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${filePaths.length} mídias adicionadas!')),
                        );
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.folder_open, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Conteúdo
        Expanded(
          child: mediaProvider.mediaLibrary.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 80,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sua biblioteca está vazia',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adicione filmes e séries do seu dispositivo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final filePickerService = FilePickerService();
                          final hasPermission = await filePickerService.requestStoragePermission();
                          if (!hasPermission) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Permissão de armazenamento necessária')),
                              );
                            }
                            return;
                          }
                          final filePath = await filePickerService.pickMediaFile();
                          if (filePath != null && context.mounted) {
                            await mediaProvider.addLocalMedia(filePath);
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Mídia'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: mediaProvider.mediaLibrary.length,
                  itemBuilder: (context, index) {
                    final media = mediaProvider.mediaLibrary[index];
                    return MediaCard(
                      media: media,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MediaDetailScreen(media: media),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Tab de Busca
class _SearchTab extends StatefulWidget {
  const _SearchTab();
  
  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaProvider>(context);
    
    return Column(
      children: [
        // Barra de busca
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar filmes e séries...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        mediaProvider.clearSearch();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[850],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (value) {
              mediaProvider.searchMedia(value);
            },
          ),
        ),
        
        // Resultados
        Expanded(
          child: mediaProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : mediaProvider.searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Busque por filmes e séries',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 3.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: mediaProvider.searchResults.length,
                      itemBuilder: (context, index) {
                        final media = mediaProvider.searchResults[index];
                        return MediaCard(
                          media: media,
                          showTitle: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MediaDetailScreen(media: media),
                              ),
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

// Tab de Configurações
class _SettingsTab extends StatelessWidget {
  const _SettingsTab();
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          // Seção: Sobre
          _buildSectionTitle('Sobre'),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Versão do App',
            subtitle: '1.0.0',
          ),
          _buildSettingTile(
            icon: Icons.code,
            title: 'API TMDB',
            subtitle: 'Configure sua chave API',
          ),
          
          const SizedBox(height: 24),
          
          // Seção: Player
          _buildSectionTitle('Player'),
          _buildSettingTile(
            icon: Icons.hd,
            title: 'Qualidade Padrão',
            subtitle: 'Automático',
          ),
          _buildSettingTile(
            icon: Icons.subtitles,
            title: 'Legendas',
            subtitle: 'Português',
          ),
          
          const SizedBox(height: 24),
          
          // Seção: Armazenamento
          _buildSectionTitle('Armazenamento'),
          _buildSettingTile(
            icon: Icons.folder,
            title: 'Diretório Padrão',
            subtitle: '/storage/emulated/0/Movies',
          ),
          _buildSettingTile(
            icon: Icons.cleaning_services,
            title: 'Limpar Cache',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache limpo!')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
        ),
      ),
    );
  }
  
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[400]),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey[500])) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
