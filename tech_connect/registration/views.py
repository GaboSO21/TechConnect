from django.db.models.base import connection
from django.shortcuts import redirect, render
from django.views.generic import CreateView
from django.views.generic.edit import UpdateView 
from django.urls import reverse_lazy
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required
from django import forms

from .models import Perfil
from .forms import EmailForm, UserCreationFormWithEmail

# Create your views here.
class SignUp(CreateView):

    form_class = UserCreationFormWithEmail
    template_name = 'registration/signup.html'

    def get_success_url(self):
        return reverse_lazy('login') + '?register'

    def get_form(self, form_class=None):
        form = super(SignUp, self).get_form()

        # Modificar en tiempo real
        form.fields['username'].widget = forms.TextInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Nombre de usuario'})
        form.fields['email'].widget = forms.EmailInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Direccion de correo'})
        form.fields['password1'].widget = forms.PasswordInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Password'})
        form.fields['password2'].widget = forms.PasswordInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Repita la password'})

        return form

@login_required
def Register(request):
    """
    Registro de usuario con procedimiento almacenado
    """
    form = UserCreationFormWithEmail()

    if request.method == 'POST':
        form = UserCreationFormWithEmail(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            email = form.cleaned_data['email']
            password = form.cleaned_data['password1']
            with connection.cursor() as cursor:
                cursor.callproc('user_package.insert_user', [name, email, password])
            return redirect('login') 

    context = {'form': form}
    return render(request, 'registration/signup.html', context)

@method_decorator(login_required, name='dispatch')
class ProfileUpdate(UpdateView):

    model = Perfil 
    fields = ['image', 'bio']
    success_url = reverse_lazy('profile')
    template_name = 'registration/profile_form.html'

    def get_object(self):
        # recuperar objeto que se va a editar
        profile, created = Perfil.objects.get_or_create(user=self.request.user)
        return profile

@method_decorator(login_required, name='dispatch')
class EmailUpdate(UpdateView):
    form_class = EmailForm 
    success_url = reverse_lazy('profile')
    template_name = 'registration/profile_email_form.html'

    def get_object(self):
        # recuperar objeto que se va a editar
        return self.request.user

    def get_form(self, form_class=None):
        form = super(EmailUpdate, self).get_form()

        form.fields['email'].widget = forms.EmailInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Email'})

        return form









