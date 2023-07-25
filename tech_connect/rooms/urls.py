from django.urls import path
from .views import MessageDelete, MyRoomsListView, RoomCreate, RoomDetailView, RoomListView

urlpatterns = [
    path('all-rooms/', RoomListView.as_view(), name='rooms'),
    path('my-rooms/', MyRoomsListView.as_view(), name='my-rooms'),
    path('view-room/<int:pk>', RoomDetailView, name='view-room'),
    path('create-room/', RoomCreate.as_view(), name='create-room'),
    path('delete-message/<int:pk>', MessageDelete, name='delete-message'),
]

