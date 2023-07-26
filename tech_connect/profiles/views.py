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
