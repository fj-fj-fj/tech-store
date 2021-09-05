from typing import List

from django.urls import path
from django.urls.resolvers import URLPattern

from task_manager.views import EntryView, EmployeeCreateView, HomePageView

app_name = 'task_manager'
urlpatterns: List[URLPattern] = [
    path('main/', HomePageView.as_view(

    ), name='index'),
    path('entry/', EntryView.as_view(), name='entry'),
    path('signup/', EmployeeCreateView.as_view(), name='signup'),
]
