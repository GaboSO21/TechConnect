# Generated by Django 4.2.1 on 2023-07-20 19:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blog', '0004_post_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='Tag',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
                ('post', models.ManyToManyField(to='blog.post')),
            ],
            options={
                'db_table': 'tag',
            },
        ),
    ]
