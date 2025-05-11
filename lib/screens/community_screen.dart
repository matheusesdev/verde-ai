// lib/screens/community_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> _communityPosts = [
    {
      'id': 'post1',
      'user': 'Ana Jardinista',
      'avatarPath': 'assets/images/avatar_ana.png',
      'post': 'Minhas roseiras estão finalmente florindo! Alguma dica para mantê-las saudáveis durante o outono? Elas pegam sol pleno pela manhã e são regadas a cada 2 dias. Uso adubo NPK 10-10-10 mensalmente.',
      'imagePath': 'assets/images/post_roseiras.jpg',
      'likes': 23,
      'comments': 5,
      'isLikedByCurrentUser': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
    },
    {
      'id': 'post2',
      'user': 'Carlos Horta',
      'avatarPath': 'assets/images/avatar_carlos.png',
      'post': 'Colheita de tomates cereja hoje! Alguém mais cultivando hortaliças em vasos? Qual o melhor substrato para vocês?',
      'imagePath': 'assets/images/artigo_suculenta.png', // Exemplo, use uma imagem de tomates
      'likes': 45,
      'comments': 12,
      'isLikedByCurrentUser': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    },
     {
      'id': 'post3',
      'user': 'Beto Samambaia',
      'avatarPath': 'assets/images/avatar_beto.png',
      'post': 'Preciso de ajuda! Minha samambaia está com as pontas secas e algumas folhas amareladas na base. Fica em local com luz indireta e rego quando o topo do solo está seco. O que pode ser? Será que é falta de umidade?',
      'likes': 10,
      'comments': 8,
      'isLikedByCurrentUser': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 3, hours: 10)),
    }
  ];

  String? _selectedFilterCategory;
  final List<String> _filterCategories = ['Todas', 'Dúvidas', 'Dicas', 'Conquistas', 'Identificação'];

  void _addPostToList(Map<String, dynamic> newPost) {
    setState(() {
      _communityPosts.insert(0, newPost);
    });
  }

  void _navigateToCreatePost() {
    Navigator.pushNamed(
      context,
      '/create_post',
      arguments: {'onPostCreated': _addPostToList},
    );
  }

  Future<void> _showFilterDialog() async {
     final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar Posts Por Categoria'),
          contentPadding: const EdgeInsets.only(top: 12.0), // Ajuste para melhor visual
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filterCategories.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = _filterCategories[index] == _selectedFilterCategory;
                return ListTile(
                  title: Text(_filterCategories[index], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                  onTap: () {
                    Navigator.pop(context, _filterCategories[index]);
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Limpar'),
              onPressed: () {
                Navigator.pop(context, 'Todas'); // Ou null se preferir não ter "Todas" como opção selecionável
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedFilterCategory = (result == 'Todas') ? null : result; // Se "Todas", limpar o filtro
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text( _selectedFilterCategory == null ? 'Filtro removido' : 'Filtro aplicado: $_selectedFilterCategory (Simulado)')),
      );
    }
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = _communityPosts.indexWhere((p) => p['id'] == postId);
      if (postIndex != -1) {
        _communityPosts[postIndex]['isLikedByCurrentUser'] = !_communityPosts[postIndex]['isLikedByCurrentUser'];
        if (_communityPosts[postIndex]['isLikedByCurrentUser']) {
          _communityPosts[postIndex]['likes'] = (_communityPosts[postIndex]['likes'] as int) + 1;
        } else {
          _communityPosts[postIndex]['likes'] = (_communityPosts[postIndex]['likes'] as int) - 1;
        }
      }
    });
  }

  void _addComment(String postId) {
    // Em um app real, abriria uma nova tela ou um bottom sheet para digitar o comentário
    final TextEditingController commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Importante para o teclado não cobrir
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Adicionar Comentário", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Escreva seu comentário..."),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text("Comentar"),
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  setState(() {
                    final postIndex = _communityPosts.indexWhere((p) => p['id'] == postId);
                    if (postIndex != -1) {
                      _communityPosts[postIndex]['comments'] = (_communityPosts[postIndex]['comments'] as int) + 1;
                      // Aqui você adicionaria o comentário a uma lista de comentários do post
                    }
                  });
                  Navigator.pop(context); // Fecha o bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comentário adicionado (simulado)!')),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      )
    );
  }

  void _editPost(String postId, String currentText, String? currentImagePath) async {
    // Navegar para CreatePostScreen com dados existentes para edição
    // Isso requer que CreatePostScreen possa lidar com um post existente
    // Para simplificar este protótipo, vamos usar um diálogo como antes
    final TextEditingController editController = TextEditingController(text: currentText);
    final String? newText = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Post'),
        content: SingleChildScrollView( // Caso o texto seja longo
          child: TextField(
            controller: editController,
            autofocus: true,
            maxLines: null,
            decoration: const InputDecoration(hintText: 'Edite seu post...'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty || currentImagePath != null) { // Permite salvar se tiver imagem mesmo com texto vazio
                Navigator.pop(context, editController.text.trim());
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('O post não pode ficar totalmente vazio.')));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (newText != null) {
      setState(() {
        final postIndex = _communityPosts.indexWhere((p) => p['id'] == postId);
        if (postIndex != -1) {
          _communityPosts[postIndex]['post'] = newText;
          _communityPosts[postIndex]['timestamp'] = DateTime.now(); // Atualizar timestamp na edição
        }
      });
    }
  }

  void _sharePost(Map<String, dynamic> postData) async {
    String postText = postData['post'] as String;
    String userName = postData['user'] as String;
    String shareText = "Do app VerdeVivo IA, por $userName:\n\n\"$postText\"";

    List<XFile> filesToShare = [];
    if (postData['imagePath'] != null) {
      final imagePath = postData['imagePath'] as String;
      // Se for um asset, você precisaria copiá-lo para um local temporário para compartilhar
      // Se for um path de arquivo (do image_picker), você pode usá-lo diretamente
      if (!imagePath.startsWith('assets/')) {
        filesToShare.add(XFile(imagePath));
      } else {
        // Para assets, a abordagem mais simples é não compartilhar a imagem via share_plus diretamente
        // ou você precisaria implementar a cópia para um arquivo temporário.
        // Por simplicidade, vamos compartilhar apenas o texto se for asset.
        print("Compartilhamento de imagem de asset não implementado diretamente. Compartilhando apenas texto.");
      }
    }

    if (filesToShare.isNotEmpty) {
      await Share.shareXFiles(filesToShare, text: shareText);
    } else {
      await Share.share(shareText);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 5) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 1) {
      return '${difference.inSeconds}s atrás';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d atrás';
    } else {
      return DateFormat('dd/MM/yy \'às\' HH:mm').format(timestamp);
    }
  }


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedPosts = _communityPosts;
    if (_selectedFilterCategory != null && _selectedFilterCategory != 'Todas') {
      displayedPosts = _communityPosts.where((post) =>
        (post['post'] as String).toLowerCase().contains(_selectedFilterCategory!.toLowerCase()) ||
        (post['user'] as String).toLowerCase().contains(_selectedFilterCategory!.toLowerCase())
        // Em um app real, você teria uma tag de categoria no post.
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedFilterCategory == null ? 'Comunidade' : 'Comunidade: $_selectedFilterCategory'),
        automaticallyImplyLeading: false,
        actions: [
          if (_selectedFilterCategory != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined),
              tooltip: 'Limpar Filtro',
              onPressed: () {
                setState(() {
                  _selectedFilterCategory = null;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar',
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: displayedPosts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFilterCategory == null ? 'A comunidade está um pouco quieta...' : 'Nenhum post encontrado para "$_selectedFilterCategory".',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                   const SizedBox(height: 8),
                  Text(
                    _selectedFilterCategory == null ? 'Seja o primeiro a postar!' : 'Tente outro filtro ou limpe o atual.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator( // Adicionar RefreshIndicator
              onRefresh: () async {
                // Simular busca de novos posts
                await Future.delayed(const Duration(seconds: 1));
                // Em um app real, você faria uma chamada de API aqui
                // Para o protótipo, podemos reordenar ou não fazer nada
                setState(() {
                  // _communityPosts.shuffle(); // Exemplo de reordenação
                });
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feed atualizado (simulado)!')),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0), // Padding inferior para o FAB não cobrir o último item
                itemCount: displayedPosts.length,
                itemBuilder: (context, index) {
                  final post = displayedPosts[index];
                  bool isCurrentUserPost = post['user'] == 'Você (Matheus)';

                  Widget imageWidget;
                  if (post['imagePath'] != null) {
                    final imagePathString = post['imagePath'] as String;
                    if (imagePathString.startsWith('assets/')) {
                      imageWidget = Image.asset(
                        imagePathString, width: double.infinity, height: 250, fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(height: 250, color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image, color: Colors.grey))),
                      );
                    } else {
                      imageWidget = Image.file(
                        File(imagePathString), width: double.infinity, height: 250, fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(height: 250, color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image, color: Colors.grey))),
                      );
                    }
                  } else {
                    imageWidget = const SizedBox.shrink();
                  }


                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: post['avatarPath'] != null ? AssetImage(post['avatarPath']!) : null,
                                onBackgroundImageError: post['avatarPath'] != null ? (_, __) {} : null,
                                child: post['avatarPath'] == null ? Text((post['user'] as String)[0]) : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['user']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(_formatTimestamp(post['timestamp'] as DateTime), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              if (isCurrentUserPost)
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  tooltip: 'Editar Post',
                                  onPressed: () => _editPost(post['id'] as String, post['post'] as String, post['imagePath'] as String?),
                                  color: Colors.grey[700],
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(post['post']!, style: const TextStyle(fontSize: 15, height: 1.4)),
                          if (post['imagePath'] != null) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: imageWidget,
                            ),
                          ],
                          const SizedBox(height: 8),
                          Divider(height: 1, color: Colors.grey[300]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                icon: Icon(
                                  post['isLikedByCurrentUser'] ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                                  color: post['isLikedByCurrentUser'] ? Theme.of(context).primaryColor : Colors.grey[700],
                                  size: 20,
                                ),
                                label: Text('${post['likes']}', style: TextStyle(color: Colors.grey[700])),
                                onPressed: () => _toggleLike(post['id'] as String),
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.mode_comment_outlined, color: Colors.grey[700], size: 20), // Ícone diferente
                                label: Text('${post['comments']}', style: TextStyle(color: Colors.grey[700])),
                                onPressed: () => _addComment(post['id'] as String),
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.share_outlined, color: Colors.grey[700], size: 20),
                                label: Text('Compart.', style: TextStyle(color: Colors.grey[700])),
                                onPressed: () => _sharePost(post),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreatePost,
        label: const Text('Novo Post'),
        icon: const Icon(Icons.add_comment_outlined),
        tooltip: 'Criar um novo post na comunidade',
      ),
    );
  }
}