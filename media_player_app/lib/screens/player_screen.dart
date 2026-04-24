import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../models/media_item.dart';
import '../services/media_provider.dart';

class PlayerScreen extends StatefulWidget {
  final MediaItem media;

  const PlayerScreen({Key? key, required this.media}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final Player player;
  late final VideoController controller;
  bool _isControlsVisible = true;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();

    // Inicializar o media_kit
    MediaKit.ensureInitialized();

    player = Player(
      configuration: const PlayerConfiguration(
        bufferSize: 50 * 1024 * 1024, // 50MB buffer
      ),
    );

    controller = VideoController(
      player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
        androidAttachSurfaceAfterVideoParameters: false,
      ),
    );

    // Carregar o arquivo de mídia
    if (widget.media.filePath != null) {
      player.open(Media(widget.media.filePath!));
    }

    _showControls();
  }

  void _showControls() {
    setState(() {
      _isControlsVisible = true;
    });

    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Player de vídeo
          Center(
            child: Video(
              controller: controller,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // Overlay com controles
          Positioned.fill(
            child: GestureDetector(
              onTap: _showControls,
              child: AnimatedOpacity(
                opacity: _isControlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Barra superior
                        _buildTopBar(context),

                        // Espaço central
                        const Expanded(child: SizedBox()),

                        // Controles inferiores
                        _buildBottomControls(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading indicator
          StreamBuilder<bool>(
            stream: player.stream.loading,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () async {
              await player.stop();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.media.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.settings, color: Colors.white),
            ),
            onPressed: () {
              // Configurações do player
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Barra de progresso
        StreamBuilder<Duration>(
          stream: player.stream.duration,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;

            return StreamBuilder<Duration>(
              stream: player.stream.position,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: VideoProgressIndicator(
                          controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: theme.primaryColor,
                            bufferedColor: Colors.grey[700]!,
                            backgroundColor: Colors.grey[900]!,
                          ),
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 16),

        // Botões de controle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botão de retroceder
              _buildControlButton(
                icon: Icons.replay_10,
                onPressed: () {
                  final position = player.state.position;
                  player.seek(Duration(
                    seconds: (position.inSeconds - 10).clamp(0, double.infinity),
                  ));
                },
              ),

              // Botão play/pause
              StreamBuilder<bool>(
                stream: player.stream.playing,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;

                  return Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 36,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          player.pause();
                        } else {
                          player.play();
                        }
                        _showControls();
                      },
                    ),
                  );
                },
              ),

              // Botão de avançar
              _buildControlButton(
                icon: Icons.forward_10,
                onPressed: () {
                  final position = player.state.position;
                  final duration = player.state.duration;
                  player.seek(Duration(
                    seconds: (position.inSeconds + 10).clamp(0, duration.inSeconds),
                  ));
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onPressed,
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Configurações do Player', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.hd, color: Colors.white),
              title: const Text('Qualidade', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Automático'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.subtitles, color: Colors.white),
              title: const Text('Legendas', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Desativado'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.speed, color: Colors.white),
              title: const Text('Velocidade', style: TextStyle(color: Colors.white)),
              subtitle: const Text('1.0x'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
