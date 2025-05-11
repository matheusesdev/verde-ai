// lib/screens/create_post_screen.dart
import 'dart:io'; // Para File
import 'package:flutter/material.dart';
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
  File? _pickedImageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedXFile = await picker.pickImage(source: source, imageQuality: 70, maxWidth: 1000); // Limitar tamanho/qualidade

      if (pickedXFile != null) {
        setState(() {
          _pickedImageFile = File(pickedXFile.path);
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      final newPost = {
        'id': 'post${DateTime.now().millisecondsSinceEpoch}',
        'user': 'Você (Matheus)',
        'avatarPath': 'assets/images/avatar_beto.png', // Seu avatar padrão
        'post': _postTextController.text.trim(), // Usar trim()
        'imagePath': _pickedImageFile?.path,
        'likes': 0,
        'comments': 0,
        'isLikedByCurrentUser': false,
        'timestamp': DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _postTextController,
                decoration: const InputDecoration(
                  hintText: 'O que você gostaria de compartilhar com a comunidade VerdeVivo?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Melhora a aparência com maxLines
                ),
                maxLines: 5,
                textInputAction: TextInputAction.newline, // Permite quebra de linha
                validator: (value) {
                  if ((value == null || value.trim().isEmpty) && _pickedImageFile == null) {
                     return 'O post precisa de conteúdo ou uma imagem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_pickedImageFile != null)
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9), // Um pouco menor para mostrar a borda
                        child: Image.file(
                          _pickedImageFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Alterar Imagem'),
                      onPressed: _showImageSourceActionSheet,
                    )
                  ],
                )
              else
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Adicionar Imagem da Planta'),
                  onPressed: _showImageSourceActionSheet,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Theme.of(context).primaryColor), // Cor da borda
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Publicar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}