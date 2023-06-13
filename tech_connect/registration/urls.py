from django.urls import path
from .views import SignUp, ProfileUpdate

urlpatterns = [
    path('signup/', SignUp.as_view(), name='signup'),
    path('profile/', ProfileUpdate.as_view(), name='profile'),
]
