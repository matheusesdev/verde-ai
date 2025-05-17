// lib/screens/article_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Article {
  final String id;
  final String title;
  final String heroImageUrl; // Usando imageUrl para placeholders
  final String content;
  final String author;
  final DateTime publishedDate;

  const Article({
    required this.id,
    required this.title,
    required this.heroImageUrl,
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
    final textTheme = Theme.of(context).textTheme;
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
    // A cor do ícone da AppBar agora é controlada pelo AppBarTheme global
    // final Color appBarIconColor = isDarkMode ? CupertinoColors.white : CupertinoColors.black;


    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            stretch: true,
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Controlado pelo AppBarTheme
            // elevation: 0, // Controlado pelo AppBarTheme
            // iconTheme já definido no AppBarTheme
            // O botão de voltar automático do Flutter usará o iconTheme da AppBarTheme
            // Se quiser forçar um ícone Cupertino específico:
            // leading: CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   child: Icon(CupertinoIcons.back, color: Theme.of(context).appBarTheme.iconTheme?.color),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16, end: 56),
              title: Text(
                article.title,
                style: Theme.of(context).appBarTheme.titleTextStyle, // Usar estilo do tema
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: 'article_image_${article.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network( // Usando Image.network para imageUrl
                      article.heroImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[300], child: const Icon(CupertinoIcons.photo, size: 100, color: Colors.grey)),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.6),
                          end: Alignment.bottomCenter,
                          colors: <Color>[ Colors.transparent, Colors.black87 ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CupertinoButton( // Mantido CupertinoButton para consistência de estilo se desejado
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(CupertinoIcons.share, color: Theme.of(context).appBarTheme.actionsIconTheme?.color),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compartilhamento de artigo não implementado')),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    article.title,
                    style: textTheme.displayLarge?.copyWith(fontSize: 28, height: 1.3, letterSpacing: -0.2),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Icon(CupertinoIcons.person_alt_circle, size: 18.0, color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 6.0),
                      Text(
                        article.author,
                        style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(width: 16.0),
                      Icon(CupertinoIcons.calendar, size: 18.0, color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 6.0),
                      Text(
                        MaterialLocalizations.of(context).formatMediumDate(article.publishedDate),
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Divider(color: Theme.of(context).dividerTheme.color, height: 1, thickness: 0.5),
                  const SizedBox(height: 20.0),
                  SelectableText(
                    article.content.replaceAll('**', ''),
                    style: textTheme.bodyLarge?.copyWith(height: 1.75, fontSize: 17),
                    textAlign: TextAlign.left,
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