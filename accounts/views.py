from django.views.generic import CreateView
from django.urls import reverse_lazy

from accounts.forms import UserCreationForm
from accounts.models import User


class UserCreateView(CreateView):

    models = User
    form_class = UserCreationForm
    success_url = reverse_lazy('root')
    template_name = 'accounts/signup.html'
