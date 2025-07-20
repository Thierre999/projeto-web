#  Plataforma de Cursos Online

Este projeto é uma plataforma de cursos online desenvolvida com Django, 
com autenticação de usuários, controle de permissões e funcionalidades 
de gerenciamento de usuários,cursos e aulas.

## Funcionalidades
- Autenticação e autorização de usuários
- CRUD de usuários (restrito a administradores)
- Interface com Bootstrap
- Gerenciamento de conteúdos educacionais

## Requisitos do Ambiente

- **Python**: 3.12.0
- **Django**: 5.2.4
- **Bootstrap**: 5 (arquivo local)
- Sistema operacional: Windows 10
- Navegador: Opera GX

## Link para Apresentação

https://app.screencastify.com/watch/lR7DxhHNzV78mnCQvK7H

## Instalação

1. Clone o Repositório**:

   git clone [https://github.com/seu-usuario/seu-projeto.git](https://github.com/Thierre999/projeto-web.git)  
   cd cursos_online
   
2. Crie e ative um ambiente virtual:
   
   python -m venv venv
   source venv/bin/activate

3. Aplique as migrações:

   python manage.py migrate
   
4. A plataforma usa o Super Usuario como Admin então você pode criar um novo
    
   python manage.py createsuperuser

5. Execute o servidor de desenvolvimento:

   python manage.py runserver
   
6. Acesse o sistema:

   http://127.0.0.1:8000/accounts/login/

