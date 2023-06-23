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
        form.fields['topic'] = forms.ModelChoiceField(queryset=Topic.objects.all())
        form.fields['name'].widget = forms.TextInput(attrs={'class': 'form-control mb-2', 'placeholder': 'Blog name'})
        form.fields['image'] = forms.ImageField()

        return form

    def get_success_url(self):
        return reverse_lazy('my-blogs') + '?ok'

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
def postDetailView(request, pk):
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

