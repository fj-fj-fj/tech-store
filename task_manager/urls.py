from typing import List

from django.urls import path
from django.urls.resolvers import URLPattern

from .views import EntryView, HomePageView

URLList = List[URLPattern]

app_name = 'task_manager'
urlpatterns: URLList = [
    path('main/', HomePageView.as_view(), name='index'),
    path('entry/', EntryView.as_view(), name='entry'),
]
