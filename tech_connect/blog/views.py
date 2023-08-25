from django.db import connection
from django.shortcuts import redirect, render
from django.views.generic.list import ListView
from django.views.generic.detail import DetailView
from django.views.generic.edit import CreateView, UpdateView
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.urls import reverse_lazy
from django import forms

from .models import *
from .forms import BlogForm, CommentForm, PostForm, TopicForm

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
        # context['test'] = my_custom_sql(self)
        return context

@method_decorator(login_required, name='dispatch')
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

@login_required
def BlogDelete(request, pk):
    blog = Blog.objects.get(id=pk)
    if blog.user.id == request.user.id:
        with connection.cursor() as cursor:
            cursor.callproc('blog_package.delete_blog', [pk])
        return redirect(request.META['HTTP_REFERER'])
    else:
        return redirect('blogs')

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

@login_required
def PostCreate(request, blog):
    form = PostForm()
    blogs = Blog.objects.filter(user=request.user, id=blog)
    if blogs:
        form.fields['blog'].widget = forms.TextInput(attrs={'type': 'hidden', 'value': blog })
    else: 
        return redirect('blogs')

    if request.method == 'POST':
        form = PostForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            content = form.cleaned_data['content']
            with connection.cursor() as cursor:
                cursor.callproc('post_package.insert_post', [content, blog, name])
            return redirect('my-blogs')

    context = {'form': form}
    return render(request, 'blog/post_form.html', context)

@login_required
def PostUpdate(request, pk):
    post = Post.objects.get(id=pk)
    form = PostForm(instance=post)
    form.fields['blog'].widget = forms.TextInput(attrs={'type': 'hidden'})

    if request.method == 'POST':
        form = PostForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            post = pk
            content = form.cleaned_data['content']
            with connection.cursor() as cursor:
                cursor.callproc('post_package.update_post', [content, post, name])
            return redirect('my-blogs')

    context = {'form': form}
    return render(request, 'blog/post_form.html', context)

@login_required
def PostDelete(request, pk):
    post = pk
    with connection.cursor() as cursor:
        cursor.callproc('post_package.delete_post', [post])
    return redirect(request.META['HTTP_REFERER'])

@login_required
def ComentDelete(request, pk):
    coment = pk
    with connection.cursor() as cursor:
        cursor.callproc('coment_package.delete_coment', [coment])
    return redirect(request.META['HTTP_REFERER'])

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
            user = request.user.id
            post = pk
            content = form.cleaned_data['content']
            with connection.cursor() as cursor:
                cursor.callproc('coment_package.insert_coment', [content, post, user])
            return redirect(request.META['HTTP_REFERER'])

    context = {'form': form, 'post': post, 'comments': comments}
    return render(request, 'blog/post_detail.html', context)

@login_required
def TopicCreate(request):
    """
    Controlador de Topics, crea objetos mediante procedimiento 
    almacenado insert_topic del paquete topic_package
    """
    form = TopicForm()

    if request.method == 'POST':
        form = TopicForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            with connection.cursor() as cursor:
                cursor.callproc('topic_package.insert_topic', [name])
            return redirect('create-blog') 

    context = {'form': form}
    return render(request, 'blog/blog_form.html', context)

def BlogStatus(request):

    topics = popular_topics()
    post = most_commented_post()
    blog = blog_most_posts()

    context = {'topic': topics, 'post': post, 'blog': blog}

    return render(request,'blog/blog_status.html', context)

def popular_topics():
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM TopicsUsadosEnBlogs')
        row = dictfetchall(cursor)
    return row

def most_commented_post():
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM PostConMasComentarios')
        row = dictfetchall(cursor)
    return row

def blog_most_posts():
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM BlogConMasPosts')
        row = dictfetchall(cursor)
    return row

def dictfetchall(cursor):
    """
    Return all rows from a cursor as a dict.
    Assume the column names are unique.
    """
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]





