from django.urls import path
from . import views

urlpatterns = [
    
    path('register/', views.register, name='register'),
    path('dashboard/', views.dashboard, name='dashboard'),
    
    path('usuarios/', views.usuario_list, name='usuario_list'),
    path('usuarios/novo/', views.usuario_create, name='usuario_form'),
    path('usuarios/<int:pk>/editar/', views.usuario_update, name='usuario_update'),
    path('usuarios/<int:pk>/excluir/', views.usuario_delete, name='usuario_delete'), 
    
    path('cursos/', views.curso_list, name='curso_list'),
    path('cursos/novo/', views.curso_create, name='curso_form'),
    path('cursos/<int:pk>/editar/', views.curso_edit, name='curso_edit'),
    path('cursos/<int:pk>/excluir/', views.curso_delete, name='curso_delete'),
    
    path('aulas/', views.aula_list, name='aula_list'),
    path('aulas/novo/', views.aula_create, name='aula_form'),
    path('aulas/<int:pk>/editar/', views.aula_edit, name='aula_edit'),
    path('aulas/<int:pk>/excluir/', views.aula_delete, name='aula_delete'),
    
]
