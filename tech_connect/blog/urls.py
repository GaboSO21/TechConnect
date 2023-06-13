from django.urls import path
from .views import MyBlogListView

urlpatterns = [
    #path('signup/', SignUp.as_view(), name='signup'),
    #path('profile/', ProfileUpdate.as_view(), name='profile'),
    path('my-blogs/', MyBlogListView.as_view(), name='my-blogs'),
]

