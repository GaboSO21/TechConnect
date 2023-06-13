from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django import forms

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
