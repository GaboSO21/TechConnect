from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django import forms

from .models import Perfil

class UserCreationFormWithEmail(UserCreationForm):

    email = forms.EmailField(required=True, help_text="Requerido, 254 caracteres como maximo y debe de ser valido")

    class Meta():
        model = User
        fields = ('username', 'email', 'password1', 'password2')


    # Metodo para validar email enviado en usuario 
    def clean_email(self):
        email = self.cleaned_data.get('email')
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError('El email ya esta registrado.')
        return email

class ProfileFrom(forms.ModelForm):

    class Meta:
        model = Perfil
        fields = ['image', 'bio']
        widgets = {
                'image': forms.ClearableFileInput(attrs={'class': 'form-control-file mt-3'}),
                'bio': forms.Textarea(attrs={'class': 'form-control mt-3', 'rows': 3, 'placeholder': 'Biografia'}),
        }

class EmailForm(forms.ModelForm):

    email = forms.EmailField(required=True, help_text="Requerido, 254 caracteres como maximo y debe de ser valido")

    class Meta:
        model = User
        fields = ['email']
        
    def clean_email(self):
        email = self.cleaned_data.get('email')
        if 'email' in self.changed_data:
            if User.objects.filter(email=email).exists():
                raise forms.ValidationError('El email ya esta registrado.')
        return email




















