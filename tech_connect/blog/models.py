from django.contrib.auth.forms import User
from ckeditor.fields import RichTextField
from django.db import models

# Create your models here.
class Topic(models.Model):
    
    name = models.CharField(max_length=200)

    class Meta():
        db_table = 'topic'

class Blog(models.Model):

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    topic = models.OneToOneField(Topic, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='blog')

    class Meta():
        db_table = 'blog'

class Post(models.Model):

    blog = models.ForeignKey(Blog, on_delete=models.CASCADE) 
    content = RichTextField()

    class Meta():
        db_table = 'post'

class Coment(models.Model):

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    content = models.TextField()

    class Meta():
        db_table = 'coment'
