# App de Controle de Acesso com Autenticação por Impressão Digital

## Descrição do Projeto
O **App de Controle de Acesso com Autenticação por Impressão Digital** oferece uma solução eficiente e segura para controle de acessos utilizando biometria. O objetivo do aplicativo é permitir que os usuários autentiquem-se usando suas impressões digitais para obter acesso a áreas restritas ou informações sensíveis.

## Objetivos SMART
- **Específico:** Criar um aplicativo mobile que permite autenticação via impressão digital para controle de acesso.
- **Mensurável:** Obter uma taxa de sucesso de 95% na autenticação de 100 usuários durante os testes.
- **Atingível:** Implementar usando APIs nativas para autenticação biométrica no Android e iOS.
- **Relevante:** Responder à crescente demanda por sistemas mais seguros que eliminam a dependência de senhas.
- **Temporal:** Concluir e lançar a primeira versão do app em 6 meses.

## Funcionalidades Principais
1. **Cadastro de Usuários:** Registro e gerenciamento de perfis de usuários com diferentes níveis de permissão.
2. **Autenticação por Impressão Digital:** Autenticação biométrica integrada com fallback para PIN ou senha.
3. **Controle de Acesso:** Gerenciamento de permissões e verificação de autorização para liberar acesso.
4. **Logs de Acesso:** Histórico de tentativas de autenticação, incluindo falhas e sucessos.
5. **Configurações e Notificações:** Opções de personalização de alertas e notificações de segurança.

## Funcionalidades Futuras
- **Integração com Smart Locks:** Controle de fechaduras físicas.
- **Autenticação Multi-Fator:** Combinação de biometria com outras formas de autenticação, como OTP.

## Tecnologias Utilizadas
- **Frontend:** Flutter (compatível com Android e iOS).
- **Backend:** Node.js com Express.
- **Banco de Dados:** MongoDB ou Firebase.
- **Autenticação Biométrica:** BiometricPrompt (Android) e LocalAuthentication (iOS).

## Diagramas

1. Classe

``` mermaid
classDiagram
    class Usuario {
        +int id
        +string nome
        +string email
        +string impressaoDigitalHash
        +autenticar()
        +solicitarAcesso()
    }

    class Administrador {
        +int id
        +string nome
        +string email
        +gerenciarUsuarios()
        +verLogsAcesso()
        +configurarPermissoes()
    }

    class LogAcesso {
        +int id
        +string dataHora
        +boolean sucesso
        +registrarAcesso()
    }

    Usuario "1" -- "0..*" LogAcesso : registra >
    Administrador "1" -- "0..*" Usuario : gerencia >

```

2. Uso

``` mermaid
flowchart TD
    A[Início] --> B{Tipo de Ação}
    B -->|Usuário| C[Autenticar com Impressão Digital]
    B -->|Usuário| D[Solicitar Acesso]
    B -->|Administrador| E[Gerenciar Usuários]
    B -->|Administrador| F[Ver Logs de Acesso]
    B -->|Administrador| G[Configurar Permissões]

    C --> H[Fim]
    D --> H
    E --> H
    F --> H
    G --> H
```
3. Fluxo

``` mermaid
flowchart TD
    A[Início] --> B{Usuário autenticado?}
    B -- Sim --> C[Verificar Permissões]
    B -- Não --> D[Autenticar com Impressão Digital]
    D --> C
    C --> E{Permissão concedida?}
    E -- Sim --> F[Acesso Concedido]
    E -- Não --> G[Acesso Negado]

    F --> H[Registrar Log de Acesso]
    G --> H
    H --> I[Fim]
```

## Escopo Funcional
### Funcionalidades:
- **Cadastro de Usuários:** Permite adicionar e gerenciar usuários, além de atribuir permissões.
- **Autenticação Biometria:** Autenticação segura usando impressão digital, com fallback para métodos alternativos (PIN, senha).
- **Controle de Acesso:** Gerenciamento do acesso com base na autenticação biométrica, permitindo ou negando o acesso.
- **Logs de Acesso:** Monitoramento e auditoria de tentativas de login, com relatórios gerados automaticamente.
- **Notificações:** Configurações de alertas personalizáveis para usuários e administradores sobre eventos críticos.

## Escopo Não Funcional
- **Segurança:** Criptografia avançada para dados de autenticação, conformidade com LGPD e GDPR.
- **Performance:** Tempo de autenticação biométrica inferior a 1 segundo, escalabilidade para até 1000 usuários simultâneos.
- **Compatibilidade:** Suporte para Android API 28+ e iOS 10+.

## Cronograma
| Fase                     | Duração     | Início      | Fim         |
|--------------------------|-------------|-------------|-------------|
| Planejamento e Pesquisa   | 2 semanas   | 01/11/2024  | 14/11/2024  |
| Desenvolvimento do Backend| 6 semanas   | 15/11/2024  | 31/12/2024  |
| Desenvolvimento do Frontend| 8 semanas  | 01/01/2025  | 26/02/2025  |
| Integração Biometria      | 4 semanas   | 01/03/2025  | 29/03/2025  |
| Testes e Ajustes          | 6 semanas   | 01/04/2025  | 13/05/2025  |
| Lançamento MVP            | 1 semana    | 14/05/2025  | 21/05/2025  |

## Análise de Riscos
| Risco                         | Mitigação                                   |
|-------------------------------|---------------------------------------------|
| Falha de Integração Biométrica | Testes em diversos dispositivos e fallback. |
| Vazamento de Dados             | Implementar criptografia e monitoramento.   |
| Atualizações das APIs          | Manter versão compatível com as mais recentes APIs Android/iOS.|

## Equipe
- Desenvolvedor Backend: Node.js, Express.
- Desenvolvedor Frontend: Flutter.
- Engenheiro de Segurança: Focado na criptografia e segurança de dados.
- Testador (QA): Garantia de qualidade e testes de usabilidade e segurança.

## Conclusão
O **App de Controle de Acesso com Autenticação por Impressão Digital** visa transformar o controle de acesso, oferecendo uma experiência segura e rápida baseada em autenticação biométrica. O projeto foca em segurança, escalabilidade e facilidade de uso, com potencial para futuras expansões como integração com dispositivos de IoT e autenticação multi-fator.

---

