from django.urls import path
from .views import BlogDelete, BlogDetailView, BlogUpdate, MyBlogListView, BlogCreate, PostCreate, TopicCreate, BlogListView, PostDetailView

urlpatterns = [
    path('blogs/', BlogListView.as_view(), name='blogs'),
    path('my-blogs/', MyBlogListView.as_view(), name='my-blogs'),
    path('create/', BlogCreate.as_view(), name='create-blog'),
    path('create-topic/', TopicCreate.as_view(), name='create-topic'),
    path('create-post/<int:blog>', PostCreate.as_view(), name='create-post'),
    path('view-post/<int:pk>', PostDetailView, name='view-post'),
    path('view-blog/<int:pk>', BlogDetailView.as_view(), name='view-blog'),
    path('edit-blog/<int:pk>', BlogUpdate.as_view(), name='edit-blog'),
    path('delete-blog/<int:pk>', BlogDelete.as_view(), name='delete-blog'),
]

