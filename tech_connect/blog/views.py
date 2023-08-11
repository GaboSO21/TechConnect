from django.db import connection
from django.shortcuts import redirect, render
from django.views.generic.list import ListView
from django.views.generic.detail import DetailView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.urls import reverse_lazy
from django import forms

from .models import *
from .forms import BlogForm, CommentForm, PostForm, TopicForm

def my_custom_sql(self):
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM vw1');
        row = cursor.fetchone()
    return row

# Create your views here
class BlogListView(ListView):

    model = Blog
    

@method_decorator(login_required, name='dispatch')
class MyBlogListView(ListView):

    model = Blog
    template_name = 'blog/my_blog_list.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['blog_list'] = Blog.objects.filter(user=self.request.user)
        context['test'] = my_custom_sql(self)
        return context

class BlogDetailView(DetailView):

    model = Blog

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['posts'] = Post.objects.filter(blog=context['blog'])
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
        form.fields['topic'] = forms.ModelChoiceField(queryset=Topic.objects.all(), widget=forms.Select(attrs={'class': 'dropdpwnMenu'}))
        form.fields['name'].widget = forms.TextInput(attrs={'class': 'input-info', 'type': 'text', 'placeholder': 'Blog name'})
        form.fields['image'] = forms.ImageField(widget=forms.FileInput(attrs={'class': 'btn-img'}))

        return form

    def get_success_url(self):
        return reverse_lazy('my-blogs') + '?ok'

@method_decorator(login_required, name='dispatch')
class BlogDelete(DeleteView):

    model = Blog

    def get_success_url(self):
        return reverse_lazy('my-blogs') +'?deleted'


@method_decorator(login_required, name='dispatch')
class BlogUpdate(UpdateView):

    model = Blog
    form_class = BlogForm

    def get_form(self, form_class=None):
        form = super(BlogUpdate, self).get_form()

        # Modificar en tiempo real
        form.fields['user'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': self.request.user.id })
        form.fields['topic'] = forms.ModelChoiceField(queryset=Topic.objects.all(), widget=forms.Select(attrs={'class': 'dropdpwnMenu'}))
        form.fields['name'].widget = forms.TextInput(attrs={'class': 'input-info', 'type': 'text', 'placeholder': 'Blog name'})
        form.fields['image'] = forms.ImageField(widget=forms.FileInput(attrs={'class': 'btn-img'}))

        return form


    def get_success_url(self):
        return reverse_lazy('view-blog', args=[self.object.id]) + '?ok'

@method_decorator(login_required, name='dispatch')
class PostCreate(CreateView):

    model = Post
    form_class = PostForm
    success_url = reverse_lazy('view-blog')

    def get_success_url(self):
        return reverse_lazy('my-blogs')

    def get_form(self, form_class=None):
        form = super(PostCreate, self).get_form()
        blogs = Blog.objects.filter(user=self.request.user, id=self.kwargs.get('blog'))
        # Modificar en tiempo real
        if blogs:
            form.fields['blog'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': self.kwargs.get('blog') })
            return form
        else: 
            return redirect('blogs')

@login_required
def PostDetailView(request, pk):
    form = CommentForm()
    form.fields['user'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': request.user.id })
    form.fields['post'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': pk })
    post = Post.objects.get(id=pk)
    comments = Coment.objects.filter(post=pk)

    if request.method == 'POST':
        form = CommentForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect(request.META['HTTP_REFERER'])

    context = {'form': form, 'post': post, 'comments': comments}
    return render(request, 'blog/post_detail.html', context)

@method_decorator(login_required, name='dispatch')
class TopicCreate(CreateView):

    model = Topic
    form_class = TopicForm
    success_url = reverse_lazy('create-blog')

    def get_success_url(self):
        return reverse_lazy('create-blog') + '?ok'

