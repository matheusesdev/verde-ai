// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/plant_model.dart';
import 'article_details_screen.dart'; // Article class está aqui

class DashboardScreen extends StatelessWidget {
  final List<Plant> myPlants;
  final Function(int) onNavigateToTab; // Função para mudar de aba

  const DashboardScreen({
    super.key,
    required this.myPlants,
    required this.onNavigateToTab, // Certifique-se que este é passado de MainScreen
  });

  // Mock de dados para os artigos (como na versão anterior)
  static final List<Article> _mockArticles = [
    Article(
      id: 'art1',
      title: 'Guia Completo: Replantando sua Suculenta Favorita',
      heroImageUrl: 'https://via.placeholder.com/300x200/A9DFBF/FFFFFF?Text=Suculenta+Replantio',
      author: 'Equipe VerdeVivo',
      publishedDate: DateTime(2023, 10, 20),
      content: 'Replantar suculentas pode parecer intimidante...',
    ),
    Article(
      id: 'comPost1',
      title: 'Comunidade: Minhas Folhas de Samambaia Estão Amarelando!',
      heroImageUrl: 'https://via.placeholder.com/300x200/F5B7B1/FFFFFF?Text=Samambaia+Problema',
      author: 'Beto Samambaia',
      publishedDate: DateTime(2023, 10, 28),
      content: 'Pessoal da comunidade VerdeVivo, preciso de uma luz!...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int plantsNeedingWater = myPlants.where((p) => p.name.contains("Samambaia")).length;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        children: <Widget>[
          _buildSectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumo do Jardim', style: textTheme.titleLarge),
                const SizedBox(height: 12),
                _buildInfoRow(context, CupertinoIcons.tree, '${myPlants.length} planta(s) em seu jardim.'),
                const SizedBox(height: 8),
                _buildInfoRow(context, CupertinoIcons.drop, '$plantsNeedingWater planta(s) precisam de rega.'),
                const SizedBox(height: 16),
                Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                        // CORRIGIDO: Chamar onNavigateToTab para ir para a aba "Meu Jardim" (índice 1)
                        onPressed: () => onNavigateToTab(1),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Ver Jardim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
                            SizedBox(width: 6),
                            Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                )
              ],
            ),
          ),
          _buildSectionContainer(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(CupertinoIcons.camera_viewfinder, color: Theme.of(context).primaryColor, size: 28),
              ),
              title: Text('Identificar Nova Planta', style: textTheme.titleMedium),
              subtitle: Text('Descubra plantas com uma foto.', style: textTheme.bodySmall),
              trailing: Icon(CupertinoIcons.right_chevron, color: Colors.grey[400], size: 20),
              // CORRIGIDO: Chamar onNavigateToTab para ir para a aba "Identificar" (índice 2)
              onTap: () => onNavigateToTab(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
            child: Text('Destaques & Dicas', style: textTheme.titleLarge),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockArticles.length,
            itemBuilder: (context, index) {
              final article = _mockArticles[index];
              return _buildHighlightCard(
                context: context,
                article: article,
                onTap: () {
                  Navigator.pushNamed(context, '/article_details', arguments: article);
                },
              );
            },
            separatorBuilder: (context, index) => Divider(indent: 20, endIndent: 20, color: Theme.of(context).dividerTheme.color, height: 1),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).iconTheme.color, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[200]!, width: 0.8),
      ),
      child: child,
    );
  }

  Widget _buildHighlightCard({required BuildContext context, required Article article, required VoidCallback onTap}) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: 'article_image_${article.id}',
                  child: Image.network( // Usando Image.network para heroImageUrl
                    article.heroImageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                      child: Icon(CupertinoIcons.photo, size: 30, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      article.title,
                      style: textTheme.titleMedium?.copyWith(height: 1.35, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Por ${article.author}',
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                     Text(
                      MaterialLocalizations.of(context).formatShortDate(article.publishedDate),
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}