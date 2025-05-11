import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import 'article_details_screen.dart'; // IMPORTADO para a classe Article e navegação

class DashboardScreen extends StatelessWidget {
  final List<Plant> myPlants;
  final Function(int) onNavigateToTab;

  const DashboardScreen({
    super.key,
    required this.myPlants,
    required this.onNavigateToTab,
  });

  // Mock de dados para os artigos
  // CORRIGIDO: Caminhos dos assets para heroImagePath
  static final List<Article> _mockArticles = [
    Article(
      id: 'art1',
      title: 'Guia Completo: Como Replantar sua Suculenta Favorita',
      heroImagePath: 'assets/images/artigo_suculenta.png', // CAMINHO CORRETO
      author: 'Equipe VerdeVivo',
      publishedDate: DateTime(2023, 10, 20),
      content:
          'Replantar suculentas pode parecer intimidante, mas com os passos certos, é um processo simples que garante a saúde e o crescimento contínuo da sua planta.\n\n'
          '**1. Escolha o Vaso Certo:**\nEle deve ser apenas um pouco maior que o vaso atual e ter furos de drenagem adequados. Suculentas não gostam de ficar com as raízes encharcadas!\n\n'
          '**2. Prepare o Substrato:**\nUma mistura específica para cactos e suculentas é ideal, pois oferece a drenagem necessária. Você também pode fazer sua própria mistura com terra vegetal, areia grossa e perlita (proporção 1:1:1).\n\n'
          '**3. Remova a Planta com Cuidado:**\nRetire a suculenta do vaso antigo, sacudindo o excesso de terra das raízes. Inspecione as raízes em busca de sinais de apodrecimento ou pragas. Se encontrar raízes escuras e moles, corte-as com uma tesoura esterilizada.\n\n'
          '**4. Replantio:**\nColoque uma camada de substrato no novo vaso, posicione a suculenta no centro e preencha ao redor com mais substrato, firmando levemente. Deixe um pequeno espaço (cerca de 1-2cm) entre o substrato e a borda do vaso.\n\n'
          '**5. Pós-Replantio (Importante!):**\nNão regue a suculenta imediatamente após o replantio! Espere cerca de uma semana para permitir que quaisquer raízes danificadas cicatrizem. Isso ajuda a prevenir o apodrecimento. Após esse período, regue moderadamente, esperando o solo secar completamente entre as regas.\n\n'
          'Com esses cuidados, sua suculenta estará pronta para prosperar em seu novo lar. Lembre-se de observar sua planta e ajustar os cuidados conforme necessário. Feliz jardinagem!',
    ),
    Article(
      id: 'comPost1',
      title: 'Comunidade em Ação: Minha Samambaia Está com Folhas Amarelas!',
      heroImagePath: 'assets/images/post_roseiras.jpg', // CAMINHO CORRETO
      author: 'Beto Samambaia (Comunidade)',
      publishedDate: DateTime(2023, 10, 28),
      content: 'Pessoal da comunidade VerdeVivo, preciso de uma luz!\n\n'
               'Minha samambaia (Nephrolepis exaltata) está apresentando folhas amareladas, principalmente as mais antigas, na base. Algumas pontas também estão ficando secas e marrons.\n\n'
               '**Condições Atuais:**\n'
               '- **Local:** Fica na minha sala, perto de uma janela que recebe luz indireta brilhante pela manhã. Não pega sol direto.\n'
               '- **Rega:** Costumo regar quando sinto que o topo do substrato está começando a secar, geralmente umas 2 vezes por semana. Tento não encharcar.\n'
               '- **Umidade:** Moro em uma região com umidade do ar relativamente boa, mas não borrifo as folhas.\n'
               '- **Vaso:** Tem furos de drenagem.\n'
               '- **Adubação:** Usei um adubo líquido para plantas verdes há uns 2 meses.\n\n'
               'Será que estou errando na rega? Falta de umidade? Ou pode ser alguma deficiência nutricional? Qualquer ajuda é bem-vinda! Obrigado!\n\n'
               '*(Este é um exemplo de como um post da comunidade poderia ser apresentado como um "artigo" ou ponto de discussão principal no dashboard. Clicar aqui poderia levar à aba comunidade, filtrando por este post ou abrindo-o diretamente).*',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int plantsNeedingWater = myPlants.where((p) => p.name.contains("Samambaia")).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard VerdeVivo'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumo do Jardim', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.eco_outlined, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text('${myPlants.length} planta(s) em seu jardim.'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.water_drop_outlined, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text('$plantsNeedingWater planta(s) precisam de rega (simulado).'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Ver Meu Jardim'),
                      onPressed: () => onNavigateToTab(1),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Icon(Icons.search_sharp),
              ),
              title: const Text('Identificar Nova Planta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Descubra plantas com uma foto.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () => onNavigateToTab(2),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
            child: Text('Destaques & Dicas', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
          if (_mockArticles.isNotEmpty)
            _buildHighlightCard(
              context,
              article: _mockArticles[0],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/article_details',
                  arguments: _mockArticles[0],
                );
              },
            ),
          if (_mockArticles.length > 1)
             _buildHighlightCard(
              context,
              article: _mockArticles[1],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/article_details',
                  arguments: _mockArticles[1],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(BuildContext context, {required Article article, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: 'article_image_${article.id}',
                  child: Image.asset( // O Image.asset usa o heroImagePath
                    article.heroImagePath, // Este deve ser 'assets/images/nome_arquivo.ext'
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      article.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Por: ${article.author}',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                     Text(
                      MaterialLocalizations.of(context).formatShortDate(article.publishedDate),
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
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