from django.urls import path
from .views import ProfilesDetailView, ProfilesListView

urlpatterns = [
    path('view-profiles/', ProfilesListView.as_view(), name='view-profiles'),
    path('view-profile/<int:pk>', ProfilesDetailView.as_view(), name='view-profile'),
]

