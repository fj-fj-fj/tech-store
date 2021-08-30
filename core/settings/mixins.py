from typing import Any, Tuple


class UtilsDevMixin:

    """Mixin that provides useful features for development."""

    @staticmethod
    def type_watch(source: str, value: Any) -> Tuple[str, Any]:
        """
        Shows extra information about any value:
        local variables, watched expressions, and exploded items.

        see https://pypi.org/project/snoop/#watch_extras
        """
        return f'type({source})', type(value)

    @staticmethod
    def repr_value(source: str, value: Any) -> Tuple[str, str]:
        return f'repr({source})', repr(value)
