// lib/screens/create_post_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostCreated;
  const CreatePostScreen({super.key, required this.onPostCreated});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _postTextController = TextEditingController();
  XFile? _pickedXFile;
  Uint8List? _pickedImageBytes;
  File? _pickedImageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedXFile = await picker.pickImage(source: source, imageQuality: 70, maxWidth: 1000);

      if (pickedXFile != null) {
        setState(() {
          _pickedXFile = pickedXFile;
          if (kIsWeb) {
            pickedXFile.readAsBytes().then((bytes) {
              if (mounted) {
                setState(() { _pickedImageBytes = bytes; _pickedImageFile = null; });
              }
            });
          } else {
            _pickedImageFile = File(pickedXFile.path);
            _pickedImageBytes = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet() {
    showCupertinoModalPopup( // Usar CupertinoActionSheet
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text('Galeria'),
              onPressed: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Câmera'),
              onPressed: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancelar'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      String? imagePathForPost;
      if (!kIsWeb && _pickedImageFile != null) {
        imagePathForPost = _pickedImageFile!.path;
      }

      final newPost = {
        'id': 'post${DateTime.now().millisecondsSinceEpoch}',
        'user': 'Você (Matheus)',
        'avatarUrl': 'https://via.placeholder.com/80x80/D2B4DE/333333?Text=M', // Seu avatar placeholder
        'post': _postTextController.text.trim(),
        'imagePath': imagePathForPost,
        'imageBytes': kIsWeb ? _pickedImageBytes : null,
        'imageUrl': null, // Posts criados pelo usuário não usam imageUrl de placeholder
        'likes': 0,
        'comments': 0,
        'isLikedByCurrentUser': false,
        'timestamp': DateTime.now(),
        'userComments': [], // Novo post começa sem comentários
      };
      widget.onPostCreated(newPost);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  Widget _buildPickedImage() {
    if (kIsWeb) {
      if (_pickedImageBytes != null) {
        return Image.memory(_pickedImageBytes!, height: 200, width: double.infinity, fit: BoxFit.cover);
      }
    } else {
      if (_pickedImageFile != null) {
        return Image.file(_pickedImageFile!, height: 200, width: double.infinity, fit: BoxFit.cover);
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Post'),
        leading: CupertinoButton( // Botão de voltar explícito
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CupertinoTextField( // Usar CupertinoTextField para um look iOS
                controller: _postTextController,
                placeholder: 'O que você gostaria de compartilhar?',
                padding: const EdgeInsets.all(16.0),
                maxLines: 5,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6.resolveFrom(context),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // Validação manual, pois CupertinoTextField não tem 'validator'
              // Poderia ser feita no _submitPost
              const SizedBox(height: 20),
              if (_pickedXFile != null)
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: _buildPickedImage(),
                      ),
                    ),
                    CupertinoButton( // Usar CupertinoButton
                      child: const Text('Alterar Imagem'),
                      onPressed: _showImageSourceActionSheet,
                    )
                  ],
                )
              else
                CupertinoButton( // Usar CupertinoButton
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: _showImageSourceActionSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.photo_on_rectangle, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text('Adicionar Imagem da Planta', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton( // Mantido ElevatedButton pois já está estilizado globalmente
                onPressed: (){
                  // Adicionar validação manual aqui se necessário para CupertinoTextField
                  if ((_postTextController.text.trim().isEmpty) && _pickedXFile == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('O post precisa de conteúdo ou uma imagem.')));
                     return;
                  }
                  _submitPost();
                },
                child: const Text('Publicar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}