from django.contrib.auth.forms import UserCreationForm as BaseUserCreationForm

from accounts.models import User


class UserCreationForm(BaseUserCreationForm):

    @snoop  # type: ignore
    def __init__(self, *args: tuple, **kwargs: dict) -> None:
        super().__init__(*args, **kwargs)

        for field_name in self.fields:
            field = self.fields[field_name]
            field.widget.attrs.update({
                'placeholder': field.label,
                'style': 'text-transform:none;',
            })

    class Meta(BaseUserCreationForm.Meta):
        model = User
        fields = ('username', 'email', 'password1', 'password2')
