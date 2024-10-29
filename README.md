# Descrição do Projeto

Este projeto é um aplicativo de autenticação em Flutter utilizando Firebase Authentication. Ele inclui páginas para login, cadastro de usuários e uma página inicial que utiliza geolocalização para exibir ambientes próximos.

## Funcionalidades da Aplicação

### main.dart
- **Inicializa o Firebase**: Configura o Firebase para ser usado no aplicativo, garantindo que todas as funcionalidades do Firebase estejam disponíveis.
- **Configura o aplicativo principal**: Define o ponto de entrada do aplicativo Flutter.
- **Define as rotas para navegação**: Configura a navegação entre as páginas de login, cadastro e a página inicial.

### login_page.dart
- **Interface de login para usuários**: Fornece uma interface para os usuários inserirem suas credenciais e fazerem login.
- **Permite que os usuários façam login com suas credenciais**: Valida as credenciais do usuário usando Firebase Authentication.
- **Inclui a opção de navegação para a página de cadastro**: Fornece um link para os usuários que ainda não têm uma conta, permitindo que eles naveguem para a página de cadastro.

### signup_page.dart
- **Interface de cadastro para novos usuários**: Fornece uma interface para novos usuários criarem uma conta.
- **Permite que novos usuários criem uma conta**: Coleta informações do usuário e as registra no Firebase Authentication.
- **Navegação de volta para a página de login após o cadastro**: Redireciona o usuário para a página de login após o sucesso no cadastro.

### firebase_options.dart
- **Contém as configurações do Firebase para o aplicativo**: Define as configurações específicas do Firebase necessárias para inicializar o Firebase no aplicativo.
- **Inclui informações específicas de inicialização para Android e iOS**: Fornece as configurações adequadas para diferentes plataformas (Android e iOS).

### home.dart
- **Obtém a localização atual do usuário utilizando o pacote Geolocator**: Utiliza o Geolocator para obter a localização geográfica atual do usuário.
- **Exibe a localização atual do usuário e ambientes próximos armazenados no Firestore**: Mostra a localização atual e consulta o Firestore para exibir ambientes próximos.
- **Verifica se o dispositivo suporta e tem biometria disponível usando o pacote Local Authentication**: Verifica a disponibilidade de recursos biométricos no dispositivo.
- **Autentica o usuário utilizando biometria, se disponível**: Usa a biometria para autenticar o usuário, se suportado pelo dispositivo.
- **Verifica se o usuário tem permissão para acessar um ambiente específico**: Verifica as permissões de acesso do usuário para ambientes específicos.
- **Exibe mensagens de autorização ou erro em diálogos**: Mostra mensagens de sucesso ou erro baseadas no status da autenticação e permissão de acesso.

# Documentação do Design da Aplicação

## Introdução

Esta documentação apresenta as principais escolhas de design da página inicial da aplicação, focando em criar uma interface intuitiva, funcional e atraente para o usuário.

## Motivos das Escolhas de Design

### 1. Material Design

A aplicação adota o Material Design do Flutter, proporcionando uma interface visualmente coesa e familiar. Elementos como AppBar, Cards e ListTiles são utilizados para garantir uma hierarquia visual clara e uma experiência consistente.

### 2. Layout Responsivo

O layout é projetado para ser responsivo, utilizando Widgets como `Column`, `Expanded` e `ListView.builder`. Isso assegura que a interface se ajuste adequadamente a diferentes tamanhos de tela, oferecendo uma experiência agradável em dispositivos móveis.

### 3. Cores e Estilo

A paleta de cores inclui tons de vermelho e cinza claro. O vermelho é usado para elementos de destaque, como botões e ícones, enquanto o fundo cinza cria um contraste agradável. Essa escolha de cores ajuda a guiar a atenção do usuário para informações importantes.

### 4. Feedback Visual

A interface inclui diálogos de alerta e mensagens de feedback em tempo real, informando o usuário sobre ações como a localização e proximidade de ambientes. Isso melhora a interatividade e mantém o usuário engajado.

### 5. Elementos Interativos

Botões flutuantes e Cards interativos proporcionam uma experiência de usuário dinâmica. Ao tocar em um ambiente, o usuário pode acionar verificações de autorização, promovendo um fluxo de navegação intuitivo.

### 6. Tipografia

A tipografia foi escolhida para ser legível e atraente. Títulos em negrito e tamanhos de fonte diferenciados garantem que as informações sejam facilmente identificáveis e acessíveis.

## Conclusão

As escolhas de design foram cuidadosamente consideradas para criar uma aplicação que seja não apenas funcional, mas também visualmente atraente. O foco na usabilidade e na estética proporciona uma experiência envolvente para os usuários.

# Integração com Firebase

Esta documentação aborda a integração do Firebase na aplicação Android.

## Motivo de escolha do Firebase
Com o Firebase, é possível utilizar um banco de dados não relacional em núvem com facilidade, além do serviço de registro e login de usuários pronto para a integração.

## Configurações do Firebase
As configurações do Firebase para Android estão definidas na classe `DefaultFirebaseOptions`:

            static const FirebaseOptions android = FirebaseOptions(
            apiKey: 'AIzaSyChvV82q7KQBlyRW8la-SRnZbPtgbABgLo',
            appId: '1:883862595684:android:feed6ea3472c4665b51771',
            messagingSenderId: '883862595684',
            projectId: 'somativa-flutter',
            storageBucket: 'somativa-flutter.appspot.com',
            );

## Dependências
As seguintes dependências devem ser adicionadas ao arquivo `pubspec.yaml` para integrar o Firebase na aplicação Android:

            dependencies:
            firebase_core: ^latest_version
            firebase_auth: ^latest_version
            cloud_firestore: ^latest_version
            geolocator: ^latest_version
            local_auth: ^latest_version

## Inicialização do Firebase
Para inicializar o Firebase na aplicação, utilize o seguinte código no método main():

            await Firebase.initializeApp(
            options: DefaultFirebaseOptions.android,
            );

## Autenticação
A autenticação é gerenciada com a classe FirebaseAuth. Exemplo de uso para autenticação por email e senha:

            final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
            );

## Firestore
O Firestore é utilizado para armazenar e acessar dados. Para buscar documentos da coleção 'Ambientes', use:

            final QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('Ambientes')
                .get();

# Manual do Usuário da Aplicação
## Instalação
### Requisitos

Antes de instalar a aplicação, verifique se você possui os seguintes requisitos:

- **Flutter**: Certifique-se de ter o Flutter instalado. Você pode seguir as instruções [aqui](https://flutter.dev/docs/get-started/install).
- **Dart**: O Dart é instalado automaticamente com o Flutter.
- **Editor de Código**: Recomendamos usar o Visual Studio Code ou Android Studio.

### Passos para Instalação

1. **Clone o Repositório**:
   - Abra o terminal e clone o repositório da aplicação com o seguinte comando:
     ```bash
     git clone https://github.com/Paiva8859/somativa-flutter.git
     ```

2. **Navegue até o Diretório**:
   - Acesse o diretório da aplicação:
     ```bash
     cd somativa-flutter
     ```

3. **Instale as Dependências**:
   - Execute o comando abaixo para instalar todas as dependências necessárias:
     ```bash
     flutter pub get
     ```

4. **Configurar o Firebase** (se aplicável):
   - Siga as instruções de configuração do Firebase para adicionar o projeto ao console do Firebase e obter o arquivo de configuração (`google-services.json` para Android ou `GoogleService-Info.plist` para iOS).

5. **Executar a Aplicação**:
   - Conecte um dispositivo ou inicie um emulador.
   - Execute o seguinte comando para iniciar a aplicação:
     ```bash
     flutter run
     ```
---

## Página de Login

### Como Usar
1. **Acesso**:
   - Abra a aplicação e você será direcionado para a tela de login.

2. **Inserindo Credenciais**:
   - Digite seu **e-mail** e **senha** nos campos apropriados.
   - Pressione o botão **"Login"** para acessar a aplicação.

4. **Mensagens de Erro**:
   - Se as credenciais estiverem incorretas, uma mensagem de erro será exibida.

---

## Página de Cadastro

### Como Usar
1. **Acesso**:
   - Na tela de login, clique no link **"Cadastrar"** para ir para a página de cadastro.

2. **Preenchendo o Formulário**:
   - Insira seu **e-mail**, e **senha** nos campos designados.
   - Clique no botão **"Cadastrar"** para criar sua conta.

4. **Mensagens de Erro**:
   - Mensagens serão exibidas se algum campo estiver em branco ou se o e-mail já estiver cadastrado.

---

## Página Inicial (Home)

### Como Usar
1. **Visualização da Localização**:
   - Ao acessar a tela inicial, você verá a mensagem do ambiente mais próximo e as coordenadas do usuário na parte inferior.

2. **Ambientes Próximos**:
   - A lista de ambientes próximos é exibida, mostrando:
     - **ID do Ambiente**
     - **Localização**
     - **Distância**

3. **Interagindo com os Ambientes**:
   - Toque em um ambiente para verificar se você está autorizado a acessá-lo.
   - Caso não esteja autorizado, uma mensagem de erro será exibida.

4. **Atualizando a Localização**:
   - Pressione o botão flutuante com o ícone de localização para atualizar sua localização.

5. **Autenticação Biométrica**:
   - Se autorizado, a aplicação solicitará autenticação biométrica.
   - Mensagens de sucesso ou erro aparecerão conforme o resultado da autenticação.

### Mensagens de Erro
- Mensagens de erro podem ser exibidas para problemas com permissão de localização ou autorização de acesso a ambientes.

---

## Considerações Finais
Certifique-se de que seu dispositivo tenha os serviços de localização habilitados e que você tenha configurado a autenticação biométrica, se disponível.

# Uso de APIs (Geolocator) e Firebase
## Geolocator:
- Implementar funções que dependessem da localização do usuário, identificando sua posição para determinar os ambientes próximos a ele.

## Firebase:
- Gerenciamento de usuários através da biblioteca ```firebase_auth```
- Banco de dados NoSQL em núvem (Firestore Database)

# Desafios e Soluções:
## Implementação da autenticação por impressão digital:
Como nosso programa necessitava uma forma de autenticação mais segura para o acesso de ambientes restritos, optamos pela autenticação por biometria, utilizando a biblioteca ```local_auth```.

## Gerenciamento de usuários:
Escolhemos utilizar a ferramenta de autenticação do Firebase, a biblioteca ```firebase_auth``` para facilitar o registro e sessões de usuários.

## Geolocalização:
Para implementar a função de geolocalização utilizamos a API ```Geolocator```, que garantia uma conexão e implementação sem grandes complicações.

## Banco de dados:
Escolhemos utilizar o Firestore Database como nosso banco de dados NoSQL por se tratar de um banco de dados seguro e em núvem, com várias bibliotecas e ferramentas prontas para uso em nossa aplicação.
