from django import forms
from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.views.generic import CreateView, DetailView
from django.views.generic.list import ListView

from blog.models import Topic

from .models import Room, Message
from .forms import MessageForm, RoomForm

# Create your views here.
def RoomListView(request):

    if request.method == 'POST':
        search_query = request.POST['search_query']
        room_list = Room.objects.filter(name__contains=search_query)
    else:
        room_list = Room.objects.all() 

    context = {'room_list': room_list}
    return render(request, 'rooms/room_list.html', context)

class MyRoomsListView(ListView):

    model = Room

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(MyRoomsListView, self).get_context_data()
        context['room_list'] = Room.objects.filter(host=self.request.user)
        return context



class RoomCreate(CreateView):

    model = Room 
    form_class = RoomForm 
    success_url = reverse_lazy('my-blogs')

    def get_form(self, form_class=None):
        form = super(RoomCreate, self).get_form()

        # Modificar en tiempo real
        form.fields['host'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': self.request.user.id })
        form.fields['topic'] = forms.ModelChoiceField(queryset=Topic.objects.all())
        form.fields['name'].widget = forms.TextInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Room name'})
        form.fields['description'].widget = forms.Textarea(attrs={'class': 'form-control'})

        return form

    def get_success_url(self):
        return reverse_lazy('rooms') + '?ok'

def RoomDetailView(request, pk):
    form = MessageForm()
    form.fields['user'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': request.user.id })
    form.fields['room'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': pk })
    room = Room.objects.get(id=pk)
    messages = Message.objects.filter(room=pk)
    participants = room.users.all()
    if request.method == 'POST':
        form = MessageForm(request.POST)
        if form.is_valid():
            room.users.add(request.user)
            form.save()
            return redirect(request.META['HTTP_REFERER'])

    context = {'form': form, 'room': room, 'messages': messages, 'participants': participants}
    return render(request, 'rooms/room_detail.html', context)

def MessageDelete(request, pk):
    message = Message.objects.get(id=pk)
    if request.user == message.user:
        message.delete()
        return redirect(request.META['HTTP_REFERER'])
    return redirect('all-rooms')






















