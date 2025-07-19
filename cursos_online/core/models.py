from django.db import models
from django.contrib.auth.models import User

class Curso(models.Model):
    titulo = models.CharField(max_length=100)
    descricao = models.TextField()
    instrutor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='cursos')
    data_criacao = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.titulo


class Aula(models.Model):
    curso = models.ForeignKey(Curso, on_delete=models.CASCADE, related_name='aulas')
    titulo = models.CharField(max_length=100)
    conteudo = models.TextField()
    video_url = models.URLField(blank=True, null=True)
    data_publicacao = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.titulo} ({self.curso.titulo})'

