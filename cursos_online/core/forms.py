from django import forms
from .models import Curso
from .models import Aula

class CursoForm(forms.ModelForm):
    class Meta:
        model = Curso
        fields = ['titulo', 'descricao', 'instrutor']

class AulaForm(forms.ModelForm):
    class Meta:
        model = Aula
        fields = ['curso', 'titulo', 'conteudo', 'video_url']