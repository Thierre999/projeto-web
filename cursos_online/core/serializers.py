from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Curso, Aula

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'is_staff', 'is_superuser']


class AulaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Aula
        fields = ['id', 'curso', 'titulo', 'conteudo', 'video_url', 'data_publicacao']


class CursoSerializer(serializers.ModelSerializer):
    aulas = AulaSerializer(many=True, read_only=True)
    
    instrutor_detalhes = UserSerializer(source='instrutor', read_only=True)

    class Meta:
        model = Curso
        fields = [
            'id', 'titulo', 'descricao', 'instrutor', 
            'instrutor_detalhes', 'data_criacao', 'aulas'
        ]