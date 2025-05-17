# VerdeVivo IA 🌿✨

**Transforme seu dedo verde em um polegar de ouro com o assistente de jardinagem inteligente!**

VerdeVivo IA é um protótipo de aplicativo móvel, construído com Flutter, que visa simplificar e enriquecer a experiência de cuidar de plantas. Desde a identificação de espécies até o diagnóstico de problemas e conexão com uma comunidade vibrante, nosso objetivo é ser o seu companheiro digital no mundo da jardinagem.

---

## 🌟 Principais Funcionalidades (Protótipo Atual)

*   **📱 Interface Moderna e Intuitiva:** Design inspirado na clareza e elegância, com foco na experiência do usuário.
*   **👤 Autenticação Segura:** Telas de Login e Cadastro para gerenciamento de usuários (validações simuladas).
*   **🌱 Meu Jardim Virtual:** Catalogue suas plantas e acesse guias de cuidado detalhados.
    *   **Detalhes da Planta:** Informações completas, diário (simulado) e lembretes de cuidados.
*   **🤖 Identificação & Diagnóstico por IA (Simulado):**
    *   "Fotografe uma planta" para receber sugestões de identificação.
    *   "Envie uma foto do problema" para obter um diagnóstico e sugestões de tratamento.
*   **📰 Artigos & Dicas:** Acesse conteúdo informativo sobre jardinagem em uma interface de leitura agradável.
*   **💬 Comunidade Interativa:**
    *   Feed de posts para compartilhar e aprender com outros amantes de plantas.
    *   Crie posts com texto e **imagens de suas plantas** (via `image_picker`).
    *   Interaja: **Dê likes**, adicione **comentários** (simulados), **edite** seus próprios posts (simulado) e **compartilhe** o que achar interessante.
    *   Filtre posts por categoria para encontrar o que procura.

---

## 🚀 Tecnologias e Ferramentas

*   **Framework:** Flutter 💙
*   **Linguagem:** Dart
*   **Principais Pacotes Flutter:**
    *   `google_fonts`: Para uma tipografia moderna e legível.
    *   `image_picker`: Para seleção de imagens da galeria e câmera.
    *   `share_plus`: Para funcionalidades de compartilhamento nativo.
    *   `intl`: Para formatação (ex: datas e horas).
    *   `cupertino_icons`: Para ícones com estética iOS.
*   **Design:** Foco em UI/UX clean, minimalista e interativa.

---

## 🛠️ Como Executar o Projeto

1.  **Pré-requisitos:**
    *   Flutter SDK instalado (visite [flutter.dev](https://flutter.dev/docs/get-started/install)).
    *   Um editor de código (VS Code ou Android Studio).
    *   Um emulador/simulador Android/iOS ou um dispositivo físico.

2.  **Clone este repositório:**
    ```bash
    git clone https://github.com/SEU_NOME_DE_USUARIO/verdevivo_ia_prototype.git
    cd verdevivo_ia_prototype
    ```
    *(Substitua pela URL real do seu repositório)*

3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4.  **Configure as permissões para `image_picker`** (para dispositivos reais):
    *   Siga as instruções para `AndroidManifest.xml` (Android) e `Info.plist` (iOS) detalhadas na documentação do pacote `image_picker` ou em discussões anteriores.

5.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```
    *Selecione o dispositivo desejado quando solicitado.*

---

## 🔮 Visão de Futuro (Próximos Passos)

O VerdeVivo IA tem potencial para crescer! Algumas ideias para futuras versões:

*   **Integração Real com IA:** Utilizar modelos de Machine Learning para identificação e diagnóstico precisos.
*   **Backend Robusto (ex: Firebase):** Para persistência de dados de usuários, plantas, posts, comentários e armazenamento de imagens.
*   **Notificações Push:** Para lembretes de rega, adubação e interações na comunidade.
*   **Funcionalidade Completa de Comentários e Diário.**
*   **Busca Avançada e Filtros Inteligentes.**
*   **Gamificação:** Para incentivar o aprendizado e a interação.

---

## 👨‍💻 Desenvolvido por

**Matheus Santos**

✨ Sinta-se à vontade para explorar o código, testar o protótipo e imaginar as possibilidades! ✨