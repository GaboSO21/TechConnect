from django import forms
from .models import Message, Room

class RoomForm(forms.ModelForm):
    
    class Meta:
        model = Room 
        fields = ['host', 'topic', 'name', 'description']

class MessageForm(forms.ModelForm):

    class Meta:
        model = Message
        fields = ['room', 'user', 'content']
        widgets = {
            'content': forms.TextInput(attrs={'class': 'input-info', 'placeholder': 'Message'})
        }


