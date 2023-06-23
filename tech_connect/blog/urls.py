from django.urls import path
from .views import BlogDetailView, MyBlogListView, BlogCreate, PostCreate, TopicCreate, BlogListView, postDetailView

urlpatterns = [
    #path('signup/', SignUp.as_view(), name='signup'),
    #path('profile/', ProfileUpdate.as_view(), name='profile'),
    path('blogs/', BlogListView.as_view(), name='blogs'),
    path('my-blogs/', MyBlogListView.as_view(), name='my-blogs'),
    path('create/', BlogCreate.as_view(), name='create-blog'),
    path('create-topic/', TopicCreate.as_view(), name='create-topic'),
    path('create-post/<int:blog>', PostCreate.as_view(), name='create-post'),
    path('view-post/<int:pk>', postDetailView, name='view-post'),
    path('view-blog/<int:pk>', BlogDetailView.as_view(), name='view-blog'),
]

