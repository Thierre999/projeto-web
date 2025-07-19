from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login
from django.contrib.auth.models import User
from django.contrib import messages
from .models import Curso
from .forms import CursoForm
from .models import Aula
from .forms import AulaForm

def is_admin(user):
    return user.is_superuser or user.is_staff

@login_required
@user_passes_test(is_admin)
def usuario_list(request):
    usuarios = User.objects.all()
    return render(request, 'usuarios/usuario_list.html', {'usuarios': usuarios})

@login_required
@user_passes_test(is_admin)
def usuario_create(request):
    if request.method == 'POST':
        username = request.POST['username']
        email = request.POST['email']
        senha = request.POST['senha']
        user = User.objects.create_user(username=username, email=email, password=senha)
        messages.success(request, 'Usuário criado com sucesso!')
        return redirect('usuario_list')
    return render(request, 'usuarios/usuario_form.html')

@login_required
@user_passes_test(lambda u: u.is_superuser)
def usuario_list(request):
    usuarios = User.objects.filter(is_superuser=False)  
    return render(request, 'usuarios/usuario_list.html', {'usuarios': usuarios})

@login_required
@user_passes_test(is_admin)
def usuario_update(request, pk):
    user = get_object_or_404(User, pk=pk)
    if request.method == 'POST':
        user.username = request.POST['username']
        user.email = request.POST['email']
        if request.POST['senha']:
            user.set_password(request.POST['senha'])
        user.save()
        messages.success(request, 'Usuário atualizado com sucesso!')
        return redirect('usuario_list')
    return render(request, 'usuarios/usuario_form.html', {'usuario': user})

@login_required
@user_passes_test(is_admin)
def usuario_delete(request, pk):
    user = get_object_or_404(User, pk=pk)
    if request.method == 'POST':
        user.delete()
        messages.success(request, 'Usuário excluído com sucesso!')
        return redirect('usuario_list')
    return render(request, 'usuarios/usuario_confirm_delete.html', {'usuario': user})

@login_required
def dashboard(request):
    return render(request, 'core/dashboard.html')

def register(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password1 = request.POST.get('password1')
        password2 = request.POST.get('password2')
        
        if password1 == password2:
            user = User.objects.create_user(username=username, email=email, password=password1)
            login(request, user)
            return redirect('dashboard')
        else:
            messages.error(request, 'As senhas não coincidem')
    
    return render(request, 'registration/register.html')

@login_required
def curso_list(request):
    cursos = Curso.objects.all()
    return render(request, 'core/curso_list.html', {'cursos': cursos})


@login_required
def curso_create(request):
    if request.method == 'POST':
        form = CursoForm(request.POST)
        if form.is_valid():
            curso = form.save(commit=False)
            curso.instrutor = request.user
            curso.save()
            return redirect('curso_list')
    else:
        form = CursoForm()
    return render(request, 'core/curso_form.html', {'form': form})


@login_required
def curso_edit(request, pk):
    curso = get_object_or_404(Curso, pk=pk)
    if request.user != curso.instrutor and not request.user.is_staff:
        return redirect('curso_list')
    
    if request.method == 'POST':
        form = CursoForm(request.POST, instance=curso)
        if form.is_valid():
            form.save()
            return redirect('curso_list')
    else:
        form = CursoForm(instance=curso)
    return render(request, 'core/curso_form.html', {'form': form})


@login_required
def curso_delete(request, pk):
    curso = get_object_or_404(Curso, pk=pk)
    if request.user != curso.instrutor and not request.user.is_staff:
        return redirect('curso_list')

    if request.method == 'POST':
        curso.delete()
        return redirect('curso_list')
    return render(request, 'core/curso_confirm_delete.html', {'curso': curso})

@login_required
def aula_list(request):
    aulas = Aula.objects.all()
    return render(request, 'core/aula_list.html', {'aulas': aulas})

@login_required
def aula_create(request):
    if request.method == 'POST':
        form = AulaForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('aula_list')
    else:
        form = AulaForm()
    return render(request, 'core/aula_form.html', {'form': form})

@login_required
def aula_edit(request, pk):
    aula = get_object_or_404(Aula, pk=pk)
    if request.method == 'POST':
        form = AulaForm(request.POST, instance=aula)
        if form.is_valid():
            form.save()
            return redirect('aula_list')
    else:
        form = AulaForm(instance=aula)
    return render(request, 'core/aula_form.html', {'form': form})

@login_required
def aula_delete(request, pk):
    aula = get_object_or_404(Aula, pk=pk)
    if request.method == 'POST':
        aula.delete()
        return redirect('aula_list')
    return render(request, 'core/aula_confirm_delete.html', {'aula': aula})

