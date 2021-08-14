from django.urls import path

from .views import EntryView, HomePageView

app_name = 'task_manager'
urlpatterns = [
    path('main/', HomePageView.as_view(), name='index'),
    path('entry/', EntryView.as_view(), name='entry'),
] 