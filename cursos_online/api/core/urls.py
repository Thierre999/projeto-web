from django.db import router
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views
from . import api_views

router = DefaultRouter()
router.register(r'usuarios', api_views.UserViewSet, basename='api-usuario')
router.register(r'cursos', api_views.CursoViewSet, basename='api-curso')
router.register(r'aulas', api_views.AulaViewSet, basename='api-aula')

urlpatterns = [
    path('', views.dashboard, name='dashboard'),
    path('register/', views.register, name='register'),
    
    path('usuarios/', views.usuario_list, name='usuario_list'),
    path('usuarios/novo/', views.usuario_create, name='usuario_form'),
    path('usuarios/editar/<int:pk>/', views.usuario_update, name='usuario_update'),
    path('usuarios/excluir/<int:pk>/', views.usuario_delete, name='usuario_delete'),
    
    path('cursos/', views.curso_list, name='curso_list'),
    path('cursos/novo/', views.curso_create, name='curso_form'),
    path('cursos/editar/<int:pk>/', views.curso_edit, name='curso_edit'),
    path('cursos/excluir/<int:pk>/', views.curso_delete, name='curso_delete'),
    
    path('aulas/', views.aula_list, name='aula_list'),
    path('aulas/nova/', views.aula_create, name='aula_form'),
    path('aulas/editar/<int:pk>/', views.aula_edit, name='aula_edit'),
    path('aulas/excluir/<int:pk>/', views.aula_delete, name='aula_delete'),

    path('api/', include(router.urls)),
]