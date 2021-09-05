from django import forms
from django.core.exceptions import ValidationError
from django.db.models.query import QuerySet

from accounts.forms import UserCreationForm
from accounts.models import User as Employee


class EmployeeEntryForm(forms.Form):

    username = forms.CharField(
        max_length=100,
        widget=forms.TextInput(
            attrs={
                'placeholder': 'логин',
                'style': 'text-transform:capitalize;',
                'class': 'body-login',
            }
        )
    )
    password = forms.CharField(
        max_length=250,
        widget=forms.TextInput(
            attrs={
                'placeholder': 'пароль',
                'style': 'text-transform:none;',
                'class': 'body-login',
            }
        )
    )

    def clean(self) -> 'QuerySet[Employee]':
        employee = Employee.objects.filter(
            username=self.cleaned_data.get('username'),
            password=self.cleaned_data.get('password'),
        )
        if not employee:
            raise ValidationError('Логин или пароль не найден!')
        return employee


class EmployeeCreationForm(UserCreationForm):

    avatar = forms.CharField(max_length=250, help_text='Аватар')

    class Meta(UserCreationForm.Meta):
        model = Employee
        fields = ('username', 'email', 'avatar', 'password')
