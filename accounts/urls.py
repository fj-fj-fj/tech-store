from typing import List

from django.urls import path
from django.urls.resolvers import URLPattern

from accounts.views import UserCreateView

app_name = 'accounts'
urlpatterns: List[URLPattern] = [
    path('signup/', UserCreateView.as_view(), name='signup'),
]
