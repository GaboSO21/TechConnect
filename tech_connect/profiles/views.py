from django.db.models.base import connection
from django.shortcuts import render
from django.views.generic.detail import DetailView
from django.views.generic.list import ListView

from registration.models import Perfil

# Create your views here.
class ProfilesListView(ListView):

    model = Perfil
    template_name = 'profiles/perfil_list.html'

class ProfilesDetailView(DetailView):

    model = Perfil
    template_name= 'profiles/perfil_detail.html'

def ProfilesStatus(request):
    """
    Controlador, ejecuta funcion para mostrar datos requeridos en vista
    """
    blogs = user_most_blogs()
    comments = user_most_comments()
    rooms = user_most_rooms()

    context = {'blogs': blogs, 'comments': comments, 'rooms': rooms}

    return render(request, 'profiles/profile_status.html', context)

def user_most_blogs():
    """
    Se usa objecto cursor para ejecutar instrucciones personalizadas.
    En este caso la vista UsuarioConMasBlogs.
    """
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM UsuarioConMasBlogs')
        row = dictfetchall(cursor)
    return row

def user_most_comments():
    """
    Se usa objecto cursor para ejecutar instrucciones personalizadas.
    En este caso la vista UsuarioConMasComentarios.
    """
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM UsuarioConMasComentarios')
        row = dictfetchall(cursor)
    return row

def user_most_rooms():
    """
    Se usa objecto cursor para ejecutar instrucciones personalizadas.
    En este caso la vista UsuarioConMasSalas.
    """
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM UsuarioConMasSalas')
        row = dictfetchall(cursor)
    return row

def dictfetchall(cursor):
    """
    Devuelve todas las filas del cursor como un diccionario de python.
    """
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]






















