# SCAV - Sistema de Controle de Abastecimento e Veículos

**Aluno:** João Gustavo Deboleto
**Atividade Prática:** Aplicativo de Controle de Abastecimento e Veículos em Flutter

## 🚀 Sobre o Projeto

Este projeto consiste em um aplicativo móvel desenvolvido em Flutter, projetado para oferecer aos usuários uma solução completa para o gerenciamento de seus veículos e controle de despesas com abastecimento.

O aplicativo se conecta ao **Firebase** para fornecer autenticação segura de usuários e armazenamento de dados em tempo real através do **Cloud Firestore**. Cada usuário possui um ambiente de dados isolado, garantindo a privacidade de suas informações.

### ✨ Funcionalidades Implementadas

O projeto cumpre todos os requisitos técnicos e bônus solicitados:

*   **Autenticação de Usuários:**
    *   Sistema completo de **Login e Cadastro** com e-mail e senha via Firebase Authentication.
    *   Validação de formulários e feedback visual para o usuário.
    *   Gerenciamento de sessão: o usuário permanece logado até que saia ativamente do aplicativo.

*   **Banco de Dados (Cloud Firestore):**
    *   **CRUD completo** (Criar, Ler, Atualizar e Excluir) para **Veículos**.
    *   **CRUD completo** para **Abastecimentos**, com cada registro associado a um veículo específico.
    *   Estrutura de dados segura, onde cada usuário só pode acessar e modificar seus próprios dados.

*   **Interface e Navegação:**
    *   Interface construída com **Material 3**.
    *   **Tema personalizado** (paleta de cores laranja) e suporte completo a **Modo Escuro (Dark Mode)**.
    *   Navegação intuitiva utilizando um `Drawer` (menu lateral) para acesso rápido às funcionalidades.

## 🛠️ Dependências Utilizadas

As seguintes dependências foram adicionadas ao `pubspec.yaml` para construir o projeto:

*   `firebase_core`: Pacote principal para inicializar a conexão com o Firebase.
*   `firebase_auth`: Para gerenciar a autenticação de usuários.
*   `cloud_firestore`: Para interagir com o banco de dados NoSQL Firestore.
*   `intl`: Utilizado para formatar datas nos gráficos e históricos.

## ⚙️ Como Executar o Projeto

Siga os passos abaixo para compilar e executar o aplicativo em um emulador Android ou dispositivo físico.

### Pré-requisitos

1.  **Flutter SDK** instalado e configurado no `PATH` do sistema.
2.  **Emulador Android** configurado no Android Studio ou um dispositivo físico com modo de desenvolvedor ativado.
3.  O arquivo de configuração do Firebase (`google-services.json`) já está incluído no projeto, na pasta `android/app`.

### Passos para Execução

1.  **Clone o repositório** para a sua máquina local.

2.  **Abra o terminal** na pasta raiz do projeto.

3.  **Instale as dependências** executando o comando:
    ```sh
    flutter pub get
    ```

4.  **Inicie o aplicativo**. Execute o comando abaixo para compilar e instalar o app no dispositivo/emulador conectado:
    ```sh
    flutter run
    ```

5.  **⚠️ IMPORTANTE: Hot Restart Inicial**
    Após a primeira inicialização, pode ser necessário forçar uma recarga completa do aplicativo para garantir que todos os serviços e a navegação funcionem corretamente.

    Assim que o aplicativo estiver rodando, volte ao terminal e pressione a tecla:

    ```
    R
    ```
    (R maiúsculo, para o **Hot Restart**).

Após o Hot Restart, o aplicativo estará 100% funcional e pronto para ser testado.

---
