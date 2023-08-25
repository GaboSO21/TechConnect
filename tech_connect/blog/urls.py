from django.urls import path
from .views import BlogDelete, BlogDetailView, BlogStatus, BlogUpdate, ComentDelete, PostDelete, PostUpdate, TopicCreate, MyBlogListView, BlogCreate, PostCreate, BlogListView, PostDetailView

urlpatterns = [
    path('blogs/', BlogListView.as_view(), name='blogs'),
    path('my-blogs/', MyBlogListView.as_view(), name='my-blogs'),
    path('create/', BlogCreate.as_view(), name='create-blog'),
    path('create-topic/', TopicCreate, name='create-topic'),
    path('create-post/<int:blog>', PostCreate, name='create-post'),
    path('delete-post/<int:pk>', PostDelete, name='delete-post'),
    path('edit-post/<int:pk>', PostUpdate, name='edit-post'),
    path('view-post/<int:pk>', PostDetailView, name='view-post'),
    path('view-blog/<int:pk>', BlogDetailView.as_view(), name='view-blog'),
    path('edit-blog/<int:pk>', BlogUpdate.as_view(), name='edit-blog'),
    path('delete-blog/<int:pk>', BlogDelete, name='delete-blog'),
    path('delete-coment/<int:pk>', ComentDelete, name='delete-coment'),
    path('status-blog/', BlogStatus, name='status-blog'),
]

