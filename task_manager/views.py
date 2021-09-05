from django.urls import reverse_lazy
from django.views.generic import CreateView, FormView, ListView

from task_manager.forms import EmployeeEntryForm, EmployeeCreationForm
from accounts.models import User as Employee


class HomePageView(ListView):

    model = Employee
    template_name = 'task_manager/main.html'


class EntryView(FormView):

    form_class = EmployeeEntryForm
    template_name = 'task_manager/entry.html'
    success_url = reverse_lazy('task_manager:main')


class EmployeeCreateView(CreateView):

    models = Employee
    form_class = EmployeeCreationForm
    template_name = 'task_manager/signup.html'
    success_url = reverse_lazy('task_manager:main')
