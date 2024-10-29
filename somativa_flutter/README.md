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
