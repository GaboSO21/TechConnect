from django.contrib.auth.forms import User
from ckeditor.fields import RichTextField
from django.db import models

# Create your models here.
class Topic(models.Model):
    
    name = models.CharField(max_length=200)

    class Meta():
        db_table = 'topic'

    def __str__(self):
        return self.name

class Blog(models.Model):

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    topic = models.ForeignKey(Topic, on_delete=models.CASCADE)
    name = models.CharField(max_length=200, default='My Blog')
    image = models.ImageField(upload_to='blog')

    class Meta():
        db_table = 'blog'

    def __str__(self):
        return self.name

class Post(models.Model):

    blog = models.ForeignKey(Blog, on_delete=models.CASCADE) 
    name = models.CharField(max_length=200, default='My Post')
    content = RichTextField()

    class Meta():
        db_table = 'post'

    def __str__(self):
        return self.name

class Tag(models.Model):

    post = models.ManyToManyField(Post)
    name = models.CharField(max_length=200)

    class Meta():
        db_table='tag'

    def __str__(self):
        return self.name

class Coment(models.Model):

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    content = models.TextField()

    class Meta():
        db_table = 'coment'

    def __str__(self):
        return self.content
