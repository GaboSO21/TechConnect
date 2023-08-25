from django.urls import path
from .views import ProfilesDetailView, ProfilesListView, ProfilesStatus

urlpatterns = [
    path('view-profiles/', ProfilesListView.as_view(), name='view-profiles'),
    path('status-profiles/', ProfilesStatus, name='status-profiles'),
    path('view-profile/<int:pk>', ProfilesDetailView.as_view(), name='view-profile'),
]

