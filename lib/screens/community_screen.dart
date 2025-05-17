// lib/screens/community_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      'avatarUrl': 'https://via.placeholder.com/80x80/FFC0CB/333333?Text=Ana',
      'post': 'Minhas roseiras estão finalmente florindo! Alguma dica para mantê-las saudáveis durante o outono? Elas pegam sol pleno pela manhã e são regadas a cada 2 dias. Uso adubo NPK 10-10-10 mensalmente.',
      'imageUrl': 'https://via.placeholder.com/400x300/F5B7B1/FFFFFF?Text=Roseiras',
      'imagePath': null, 'imageBytes': null,
      'likes': 23, 'comments': 2, 'isLikedByCurrentUser': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
      'userComments': [
        {'id': 'comment1_1', 'user': 'Carlos Horta', 'text': 'Que lindas! Tente adicionar um pouco de farinha de ossos na primavera.', 'avatarUrl': 'https://via.placeholder.com/60x60/A9DFBF/333333?Text=CH'},
        {'id': 'comment1_2', 'user': 'Você (Matheus)', 'text': 'Incrível, Ana!', 'avatarUrl': 'https://via.placeholder.com/60x60/D2B4DE/333333?Text=M'},
      ],
    },
    {
      'id': 'post2',
      'user': 'Carlos Horta',
      'avatarUrl': 'https://via.placeholder.com/80x80/A9DFBF/333333?Text=Carlos',
      'post': 'Colheita de tomates cereja hoje! Alguém mais cultivando hortaliças em vasos? Qual o melhor substrato para vocês?',
      'imageUrl': 'https://via.placeholder.com/400x300/82E0AA/FFFFFF?Text=Tomates',
      'imagePath': null, 'imageBytes': null,
      'likes': 45, 'comments': 0, 'isLikedByCurrentUser': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      'userComments': [],
    },
     {
      'id': 'post3',
      'user': 'Beto Samambaia',
      'avatarUrl': 'https://via.placeholder.com/80x80/AED6F1/333333?Text=Beto',
      'post': 'Preciso de ajuda! Minha samambaia está com as pontas secas e algumas folhas amareladas na base. Fica em local com luz indireta e rego quando o topo do solo está seco. O que pode ser? Será que é falta de umidade?',
      'imageUrl': null,
      'imagePath': null, 'imageBytes': null,
      'likes': 10, 'comments': 0,
      'isLikedByCurrentUser': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 3, hours: 10)),
      'userComments': [],
    }
  ];

  String? _selectedFilterCategory;
  final List<String> _filterCategories = ['Todas', 'Dúvidas', 'Dicas', 'Conquistas', 'Identificação'];

  void _addPostToList(Map<String, dynamic> newPost) {
    setState(() {
      _communityPosts.insert(0, {...newPost, 'userComments': []});
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
     final String? result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Filtrar Posts Por Categoria'),
          actions: _filterCategories.map((String category) {
            bool isSelected = category == _selectedFilterCategory || (_selectedFilterCategory == null && category == 'Todas');
            return CupertinoActionSheetAction(
              child: Text(category, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).primaryColor : null)),
              onPressed: () {
                Navigator.pop(context, category);
              },
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancelar'),
            isDestructiveAction: true, // Para dar a cor vermelha no iOS (opcional)
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedFilterCategory = (result == 'Todas') ? null : result;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text( _selectedFilterCategory == null ? 'Filtro removido' : 'Filtro: $_selectedFilterCategory')),
        );
      }
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

  void _showAddCommentModal(String postId) {
    final TextEditingController commentController = TextEditingController();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Adicionar Comentário", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          message: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: CupertinoTextField(
                controller: commentController,
                autofocus: true,
                placeholder: "Escreva seu comentário...",
                maxLines: 4, minLines: 1,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5.resolveFrom(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                onSubmitted: (_) {
                   if (commentController.text.trim().isNotEmpty) {
                    _addCommentToPost(postId, commentController.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text("Comentar"),
              isDefaultAction: true,
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  _addCommentToPost(postId, commentController.text.trim());
                  Navigator.pop(context);
                }
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancelar"),
            onPressed: () { Navigator.pop(context); },
          ),
        )
    );
  }

  void _addCommentToPost(String postId, String commentText) {
    setState(() {
      final postIndex = _communityPosts.indexWhere((p) => p['id'] == postId);
      if (postIndex != -1) {
        final newComment = {
          'id': 'comment${DateTime.now().millisecondsSinceEpoch}',
          'user': 'Você (Matheus)',
          'text': commentText,
          'avatarUrl': 'https://via.placeholder.com/60x60/D2B4DE/333333?Text=M', // Seu avatar
        };
        // Garantir que 'userComments' seja uma lista mutável
        if (_communityPosts[postIndex]['userComments'] == null) {
          _communityPosts[postIndex]['userComments'] = <Map<String,dynamic>>[];
        }
        (_communityPosts[postIndex]['userComments'] as List).insert(0, newComment);
        _communityPosts[postIndex]['comments'] = (_communityPosts[postIndex]['comments'] as int) + 1;
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentário adicionado!')),
      );
    }
  }

  void _confirmDeleteComment(String postId, String commentId) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Excluir Comentário'),
        content: const Text('Você tem certeza que deseja excluir este comentário?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () { Navigator.pop(context); },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Excluir'),
            onPressed: () {
              _deleteCommentFromPost(postId, commentId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _deleteCommentFromPost(String postId, String commentId) {
    setState(() {
      final postIndex = _communityPosts.indexWhere((p) => p['id'] == postId);
      if (postIndex != -1) {
        final commentsList = _communityPosts[postIndex]['userComments'] as List;
        int initialLength = commentsList.length;
        commentsList.removeWhere((comment) => comment['id'] == commentId);
        if (commentsList.length < initialLength) { // Se um comentário foi removido
          _communityPosts[postIndex]['comments'] = (_communityPosts[postIndex]['comments'] as int) - 1;
        }
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentário excluído!')),
      );
    }
  }

  void _editPost(String postId, String currentText, String? currentImagePathOrUrl) async {
    final TextEditingController editController = TextEditingController(text: currentText);
    final String? newText = await showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Editar Post'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CupertinoTextField(
            controller: editController,
            autofocus: true,
            maxLines: null,
            placeholder: 'Edite seu post...',
            keyboardType: TextInputType.multiline,
          ),
        ),
        actions: [
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              if (editController.text.trim().isNotEmpty || currentImagePathOrUrl != null) {
                Navigator.pop(context, editController.text.trim());
              } else {
                 if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('O post não pode ficar totalmente vazio.')));
                 }
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
          _communityPosts[postIndex]['timestamp'] = DateTime.now();
        }
      });
    }
  }

  void _sharePost(Map<String, dynamic> postData) async {
    String postText = postData['post'] as String;
    String userName = postData['user'] as String;
    String shareText = "Do app VerdeVivo IA, por $userName:\n\n\"$postText\"";

    List<XFile> filesToShare = [];
    if (postData['imagePath'] != null && !kIsWeb) {
      final imagePath = postData['imagePath'] as String;
      if (!imagePath.startsWith('assets/')) {
        filesToShare.add(XFile(imagePath));
      }
    } else if (postData['imageBytes'] != null && kIsWeb) {
      // A implementação de compartilhar bytes como XFile na web é mais complexa
      // e pode exigir salvar temporariamente. Por simplicidade, vamos focar no texto aqui.
      print("Compartilhamento de imageBytes na web via XFile não diretamente implementado.");
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

    if (difference.inSeconds < 5) return 'Agora';
    if (difference.inMinutes < 1) return '${difference.inSeconds}s';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return DateFormat('dd MMM', 'pt_BR').format(timestamp);
  }


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedPosts = _communityPosts;
    if (_selectedFilterCategory != null && _selectedFilterCategory != 'Todas') {
      displayedPosts = _communityPosts.where((post) =>
        (post['post'] as String).toLowerCase().contains(_selectedFilterCategory!.toLowerCase()) ||
        (post['user'] as String).toLowerCase().contains(_selectedFilterCategory!.toLowerCase())
      ).toList();
    }
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedFilterCategory == null ? 'Comunidade' : 'Filtro: $_selectedFilterCategory'),
        actions: [
          if (_selectedFilterCategory != null)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(CupertinoIcons.clear_circled, size: 22, color: Theme.of(context).primaryColor),
              onPressed: () { setState(() { _selectedFilterCategory = null; }); },
            ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(CupertinoIcons.slider_horizontal_3, size: 24, color: Theme.of(context).primaryColor),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: displayedPosts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.news, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFilterCategory == null ? 'A comunidade está um pouco quieta...' : 'Nenhum post encontrado para "$_selectedFilterCategory".',
                    style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                   const SizedBox(height: 8),
                  Text(
                    _selectedFilterCategory == null ? 'Seja o primeiro a postar!' : 'Tente outro filtro ou limpe o atual.',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
                 if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feed atualizado!'), duration: Duration(seconds: 1)),
                  );
                 }
              },
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 80.0, top: 0),
                itemCount: displayedPosts.length,
                itemBuilder: (context, index) {
                  final post = displayedPosts[index];
                  bool isCurrentUserPostOwner = post['user'] == 'Você (Matheus)';
                  List userComments = post['userComments'] as List? ?? [];

                  Widget imageWidget;
                  if (post['imageBytes'] != null && kIsWeb) {
                    imageWidget = Image.memory(post['imageBytes'] as Uint8List, width: double.infinity, height: 250, fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(height: 250, color: Colors.grey[200], child: const Center(child: Icon(CupertinoIcons.photo))),
                    );
                  } else if (post['imagePath'] != null) {
                    final imagePathString = post['imagePath'] as String;
                    if (imagePathString.startsWith('assets/')) {
                      imageWidget = Image.asset(imagePathString, width: double.infinity, height: 250, fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(height: 250, color: Colors.grey[200], child: const Center(child: Icon(CupertinoIcons.photo))),
                      );
                    } else if (!kIsWeb) {
                      imageWidget = Image.file(File(imagePathString), width: double.infinity, height: 250, fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(height: 250, color: Colors.grey[200], child: const Center(child: Icon(CupertinoIcons.photo))),
                      );
                    } else { imageWidget = const SizedBox.shrink(); }
                  } else if (post['imageUrl'] != null) {
                      imageWidget = Image.network(post['imageUrl'] as String, width: double.infinity, height: 250, fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(height: 250, color: Colors.grey[200], child: const Center(child: Icon(CupertinoIcons.photo))),
                      );
                  }
                  else {
                    imageWidget = const SizedBox.shrink();
                  }

                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: post['avatarUrl'] != null ? NetworkImage(post['avatarUrl']!) : null,
                                onBackgroundImageError: post['avatarUrl'] != null ? (_, __) {} : null,
                                child: post['avatarUrl'] == null ? Text((post['user'] as String)[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)) : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['user']!, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    Text(_formatTimestamp(post['timestamp'] as DateTime), style: textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              if (isCurrentUserPostOwner)
                                CupertinoButton(
                                  padding: EdgeInsets.zero, minSize: 30,
                                  child: Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 22, color: Theme.of(context).iconTheme.color),
                                  onPressed: () => _editPost(post['id'] as String, post['post'] as String, post['imagePath'] as String? ?? post['imageUrl'] as String?),
                                )
                              else
                                CupertinoButton(
                                  padding: EdgeInsets.zero, minSize: 30,
                                  child: Icon(CupertinoIcons.ellipsis, size: 22, color: Theme.of(context).iconTheme.color),
                                  onPressed: () { /* Lógica para menu de opções (reportar, etc.) */ },
                                ),
                            ],
                          ),
                        ),
                        if ((post['post'] as String).isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              left:  16.0, right: 16.0,
                              top: 0,
                              bottom: (post['imagePath'] != null || post['imageBytes'] != null || post['imageUrl'] != null) ? 12.0 : 8.0
                            ),
                            child: SelectableText(post['post']!, style: textTheme.bodyLarge?.copyWith(color: const Color(0xFF3A3A3C))),
                          ),
                        if (post['imagePath'] != null || post['imageBytes'] != null || post['imageUrl'] != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: ClipRRect(
                              child: imageWidget,
                            ),
                          ),
                        // Mostrar Comentários
                        if (userComments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Comentários (${post['comments']})", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                ...userComments.take(2).map((comment) {
                                  bool isCurrentUserComment = comment['user'] == 'Você (Matheus)';
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.grey[200],
                                          backgroundImage: comment['avatarUrl'] != null ? NetworkImage(comment['avatarUrl']) : null,
                                          child: comment['avatarUrl'] == null ? Text((comment['user'] as String)[0]) : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(comment['user'], style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                                              SelectableText(comment['text'], style: textTheme.bodySmall),
                                            ],
                                          ),
                                        ),
                                        if (isCurrentUserComment)
                                          CupertinoButton(
                                            padding: const EdgeInsets.all(0),
                                            minSize: 20,
                                            child: Icon(CupertinoIcons.trash, size: 18, color: Colors.grey[600]),
                                            onPressed: () => _confirmDeleteComment(post['id'] as String, comment['id'] as String),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                if (userComments.length > 2)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextButton(
                                      onPressed: (){ /* Navegar para ver todos os comentários */ },
                                      child: Text("Ver todos os comentários", style: textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor)),
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft)
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Padding( // Ações do Post
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                          child: Row(
                            children: [
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      post['isLikedByCurrentUser'] ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                      color: post['isLikedByCurrentUser'] ? CupertinoColors.systemRed : Theme.of(context).iconTheme.color,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text('${post['likes']}', style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).iconTheme.color)),
                                  ],
                                ),
                                onPressed: () => _toggleLike(post['id'] as String),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.chat_bubble, color: Theme.of(context).iconTheme.color, size: 20),
                                    const SizedBox(width: 5),
                                    Text('${post['comments']}', style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).iconTheme.color)),
                                  ],
                                ),
                                onPressed: () => _showAddCommentModal(post['id'] as String),
                              ),
                              const Spacer(),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Icon(CupertinoIcons.share, color: Theme.of(context).iconTheme.color, size: 20),
                                onPressed: () => _sharePost(post),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(height: 8, thickness: 8, color: Theme.of(context).scaffoldBackgroundColor == Colors.white ? Theme.of(context).dividerTheme.color?.withOpacity(0.5) : Theme.of(context).dividerTheme.color ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        child: const Icon(CupertinoIcons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1.0,
      ),
    );
  }
}