from django.contrib.auth.forms import User
from blog.models import Topic

from django.db import models

# Create your models here.
class Room(models.Model):

    topic = models.OneToOneField(Topic, on_delete=models.CASCADE)
    host = models.ForeignKey(User, on_delete=models.CASCADE, related_name='host')
    users = models.ManyToManyField(User, related_name='users')
    name = models.CharField(max_length=100)
    description = models.TextField()

    class Meta():
        db_table = 'room'

    def __str__(self):
        return self.name

class Message(models.Model):

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    content = models.TextField()

    class Meta():
        db_table = 'message'

    def __str__(self):
        return self.content







