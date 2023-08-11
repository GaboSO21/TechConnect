from django import forms
from .models import Blog, Coment, Post, Topic

class BlogForm(forms.ModelForm):
    
    class Meta:
        model = Blog
        fields = ['user', 'topic', 'name', 'image']

class TopicForm(forms.ModelForm):

    class Meta:
        model = Topic
        fields = ['name']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'input-info', 'placeholder': 'Name'})
        }

class PostForm(forms.ModelForm):
    
    class Meta:
        model = Post
        fields = ['blog', 'name', 'content']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Titulo'}),
            'content': forms.Textarea(attrs={'class': 'form-control'}),
        }

class CommentForm(forms.ModelForm):

    class Meta:
        model = Coment 
        fields = ['user', 'post', 'content']
        widgets = {
            'content': forms.Textarea(attrs={'class': 'form-control', 'placeholder': 'Write your comment!'}),
        }
