# Plataforma de Cursos Online - API RESTful & Cliente Mobile

Este projeto é uma plataforma educacional dividida em uma API desenvolvida com **Django Rest Framework (DRF)** e um cliente mobile construído em **Flutter**. O sistema possui autenticação segura via **Django OAuth Toolkit (DOT)**, controle de permissões e funcionalidades de gerenciamento (CRUD) de Usuários, Cursos e Aulas.

## Estrutura do Repositório

O projeto atende à separação de responsabilidades em dois diretórios principais:
* `/api`: Contém o back-end (Django, DRF e OAuth2).
* `/client`: Contém o front-end mobile consumidor (Flutter e Dart).

## Funcionalidades

* **API RESTful**: Endpoints estruturados com ViewSets e Serializers para listagem e gerenciamento de dados.
* **Segurança e Autenticação**: Proteção de rotas utilizando tokens de acesso OAuth2 (Fluxo *Resource Owner Password Credentials*).
* **Interface Web**: Dashboard administrativo nativo estilizado com Bootstrap 5.
* **Interface Mobile**: Aplicativo consumidor que realiza o login, captura o token e consome a rota protegida de cursos.
* **CRUD Completo**: Gerenciamento integrado de conteúdos educacionais e usuários (acesso restrito a administradores).

## Requisitos do Ambiente

* **Back-end**: Python 3.12.0, Django 5.2.4, Django Rest Framework, Django OAuth Toolkit.
* **Front-end**: Flutter SDK.
* **Web Design**: Bootstrap 5 (arquivo local e CDN).
* **Sistema Operacional**: Windows 10.
* **Navegador**: Opera GX (para testes do painel Web).

## Como Executar o Projeto

### Parte I: API (Back-end)

1. Clone o repositório:
   ```bash
   git clone [https://github.com/Thierre999/projeto-web.git](https://github.com/Thierre999/projeto-web.git)

2. Acesse a pasta da API:
    ```bash
    cd projeto-web/api
3. Crie e ative um ambiente virtual:
    ```bash
    python -m venv venv
    ```
    
   ```bash
   # No Linux/Mac
      source venv/bin/activate
   # No Windows:
      venv\Scripts\activate
   ```
4. Instale as bibliotecas necessárias:
   ```bash
   pip install django djangorestframework django-oauth-toolkit

5. Aplique as migrações do banco de dados:
   ```bash
   python manage.py migrate

6. Crie um Super Usuário (Admin) para acessar o sistema:
   ```bash
   python manage.py createsuperuser

7. Inicie o servidor de desenvolvimento:
   ```bash
   python manage.py runserver

8. Gerar Credenciais OAuth2:

Acesse http://127.0.0.1:8000/o/applications/ no navegador.

Adicione uma nova aplicação do tipo Confidential com Authorization Grant Type definido como Resource Owner Password Credentials.

Copie o Client ID e o Client Secret reais gerados nesta tela.

## Parte II: Cliente Mobile (Front-end)

1. Abra um novo terminal e acesse a pasta do cliente:
   ```bash
   cd projeto-web/client

2. Baixe as dependências do Flutter:
   ```bash
   flutter pub get

3. Configuração de Chaves:

Abra o arquivo lib/main.dart.

Insira o Client ID e o Client Secret obtidos na etapa 8 da API.

Atenção: Se for testar no emulador do Android Studio, configure a baseUrl como http://10.0.2.2:8000. Se for usar o dispositivo físico na rede, utilize o seu IP local (ex: http://192.168.X.X:8000) e ajuste o ALLOWED_HOSTS no arquivo settings do Django deixando ele assim ['*'].

4. Execute o aplicativo:
   ```bash
   flutter run


   

   
