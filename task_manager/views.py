from django.views.generic import FormView, ListView

from task_manager.forms import EmployeeForm
from task_manager.models import Employee


class HomePageView(ListView):
    model = Employee
    template_name = 'task_manager/main.html'


class EntryView(FormView):
    form_class = EmployeeForm
    template_name = 'task_manager/entry.html'
    success_url = '/main/'
