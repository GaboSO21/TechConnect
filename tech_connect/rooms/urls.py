from django.urls import path
from .views import MessageDelete, MyRoomsListView, RoomCreate, RoomDetailView, RoomListView, RoomStatus

urlpatterns = [
    path('all-rooms/', RoomListView, name='rooms'),
    path('my-rooms/', MyRoomsListView.as_view(), name='my-rooms'),
    path('view-room/<int:pk>', RoomDetailView, name='view-room'),
    path('status-room/', RoomStatus, name='status-room'),
    path('create-room/', RoomCreate, name='create-room'),
    path('delete-message/<int:pk>', MessageDelete, name='delete-message'),
]

