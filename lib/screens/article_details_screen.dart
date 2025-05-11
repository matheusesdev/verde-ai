// lib/screens/article_details_screen.dart
import 'package:flutter/material.dart';
// Se você for usar DateFormat para mais formatações complexas, adicione intl e descomente
// import 'package:intl/intl.dart';

// Modelo simples para representar os dados do artigo
class Article {
  final String id;
  final String title;
  final String heroImagePath; // Imagem de destaque do artigo
  final String content;       // Conteúdo principal do artigo
  final String author;
  final DateTime publishedDate;

  const Article({ // Adicionado const ao construtor
    required this.id,
    required this.title,
    required this.heroImagePath,
    required this.content,
    required this.author,
    required this.publishedDate,
  });
}

class ArticleDetailsScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsetsDirectional.only(start: 48, bottom: 16, end: 48),
              title: Text(
                article.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: 'article_image_${article.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      article.heroImagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey, child: const Icon(Icons.broken_image, size: 100, color: Colors.white70)),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            Colors.black54,
                          ],
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              stretchModes: const [StretchMode.zoomBackground],
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Compartilhar Artigo',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compartilhamento de artigo não implementado')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16.0, color: Colors.grey[700]),
                      const SizedBox(width: 4.0),
                      Text(
                        article.author,
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[700], fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(width: 16.0),
                      Icon(Icons.calendar_today_outlined, size: 16.0, color: Colors.grey[700]),
                      const SizedBox(width: 4.0),
                      Text(
                        MaterialLocalizations.of(context).formatMediumDate(article.publishedDate),
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 16.0),
                  SelectableText(
                    article.content,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.7,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}