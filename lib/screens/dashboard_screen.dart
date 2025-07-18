// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/plant_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../models/plant_model.dart';
import 'article_details_screen.dart'; // Article class está aqui

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateToTab; // Função para mudar de aba

  const DashboardScreen({
    super.key,
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
    return Consumer2<AppProvider, PlantProvider>(
      builder: (context, appProvider, plantProvider, child) {
        final textTheme = Theme.of(context).textTheme;
        final stats = plantProvider.getStatistics();

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appProvider.getGreeting()}, ${appProvider.getDisplayName()}!',
                  style: textTheme.titleMedium,
                ),
                Text(
                  'Dashboard',
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await plantProvider.loadPlants();
            },
            child: ListView(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              children: <Widget>[
                // Resumo do Jardim
                _buildSectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.chart_bar_alt_fill, 
                               color: Theme.of(context).primaryColor, size: 24),
                          const SizedBox(width: 8),
                          Text('Resumo do Jardim', style: textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              '${stats['total']}',
                              'Plantas',
                              CupertinoIcons.tree,
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              '${stats['needingCare']}',
                              'Precisam de Cuidado',
                              CupertinoIcons.exclamationmark_triangle,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              '${stats['withReminders']}',
                              'Com Lembretes',
                              CupertinoIcons.bell,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              '0',
                              'Tarefas Hoje',
                              CupertinoIcons.calendar,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => onNavigateToTab(1),
                          icon: const Icon(CupertinoIcons.tree),
                          label: const Text('Ver Meu Jardim'),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Ações Rápidas
                _buildSectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.bolt_fill, 
                               color: Theme.of(context).primaryColor, size: 24),
                          const SizedBox(width: 8),
                          Text('Ações Rápidas', style: textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              context,
                              'Identificar Planta',
                              'Descubra plantas com uma foto',
                              CupertinoIcons.camera_viewfinder,
                              () => onNavigateToTab(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              context,
                              'Comunidade',
                              'Compartilhe e aprenda',
                              CupertinoIcons.group,
                              () => onNavigateToTab(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Destaques & Dicas
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.star_fill, 
                           color: Theme.of(context).primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text('Destaques & Dicas', style: textTheme.titleLarge),
                    ],
                  ),
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
                  separatorBuilder: (context, index) => Divider(
                    indent: 20, 
                    endIndent: 20, 
                    color: Theme.of(context).dividerTheme.color, 
                    height: 1
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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