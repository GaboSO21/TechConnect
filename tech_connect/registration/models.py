from django.contrib.auth.forms import User
from django.db import models

# Create your models here.
class Perfil(models.Model):

    user = models.OneToOneField(User, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='perfiles', null=True, blank=True)
    bio = models.TextField(null=True, blank=True)

    class Meta():
        db_table = 'usuario'
        verbose_name_plural = 'usuarios'
