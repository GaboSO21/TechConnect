from django.db import connection
from django import forms
from django.contrib.auth.views import login_required
from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.views.generic import CreateView, DetailView
from django.views.generic.list import ListView

from blog.models import Topic

from .models import Room, Message
from .forms import MessageForm, RoomForm

# Create your views here.
@login_required
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

@login_required
def RoomCreate(request):

    form = RoomForm()

    form.fields['host'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': request.user.id })
    form.fields['topic'] = forms.ModelChoiceField(queryset=Topic.objects.all())
    form.fields['name'].widget = forms.TextInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Room name'})
    form.fields['description'].widget = forms.Textarea(attrs={'class': 'form-control'})

    if request.method == 'POST':
        form = RoomForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            desc = form.cleaned_data['description']
            topic = form['topic'].value()
            host = request.user.id
            with connection.cursor() as cursor:
                cursor.callproc('room_package.insert_room', [name, desc, host, topic])
            return redirect('my-rooms')

    context = {'form': form}
    return render(request, 'rooms/room_form.html', context)

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
            content = form.cleaned_data['content']
            room = pk
            user = request.user.id
            with connection.cursor() as cursor:
                cursor.callproc('message_package.insert_message', [content, room, user])
            return redirect(request.META['HTTP_REFERER'])

    context = {'form': form, 'room': room, 'messages': messages, 'participants': participants}
    return render(request, 'rooms/room_detail.html', context)

def MessageDelete(request, pk):
    message = Message.objects.get(id=pk)
    if request.user == message.user:
        message = pk
        with connection.cursor() as cursor:
            cursor.callproc('message_package.delete_message', [message])
        return redirect(request.META['HTTP_REFERER'])
    return redirect('all-rooms')

def RoomStatus(request):

    topic = popular_topics()
    room = most_populated_room()
    mensajes = most_messaged_room()

    context = {'topic': topic, 'room': room, 'mensajes': mensajes}

    return render(request,'rooms/room_status.html', context)

def popular_topics():
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM TopicsUsadosEnRooms')
        row = dictfetchall(cursor)
    return row

def most_populated_room():
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM RoomConMasUsuarios')
        row = dictfetchall(cursor)
    return row

def most_messaged_room():
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM RoomConMasMensajes')
        row = dictfetchall(cursor)
    return row

def dictfetchall(cursor):
    """
    Return all rows from a cursor as a dict.
    Assume the column names are unique.
    """
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]






















