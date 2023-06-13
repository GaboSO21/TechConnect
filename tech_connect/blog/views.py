from django.views.generic.list import ListView
from django.views.generic.detail import DetailView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.urls import reverse_lazy
from django import forms

from .models import *
from .forms import BlogForm

# Create your views here
@method_decorator(login_required, name='dispatch')
class MyBlogListView(ListView):

    model = Blog
    template_name = 'blog/my_blog_list.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['blog'] = Blog.objects.filter(user=self.request.user).values()
        return context

@method_decorator(login_required, name='dispatch')
class BlogCreate(CreateView):

    model = Blog
    form_class = BlogForm
    success_url = reverse_lazy('my-blogs')

    def get_form(self, form_class=None):
        form = super(BlogCreate, self).get_form()

        # Modificar en tiempo real
        form.fields['user'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': self.request.user.id })
        form.fields['topic'] = forms.ModelChoiceField(queryset=Topic.objects.all())
        form.fields['name'].widget = forms.TextInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Blog name'})
        form.fields['image'] = forms.ImageField()

        return form


