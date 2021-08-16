from typing import List, Union

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from django.urls.resolvers import URLResolver

URL = Union[URLResolver, object]
URLList = List[URL]

urlpatterns: URLList = [
    path('admin/', admin.site.urls),
    path('tasks/', include('task_manager.urls')),
]

if settings.DEBUG:
    if 'debug_toolbar' in settings.INSTALLED_APPS:
        import debug_toolbar

        urlpatterns = [
            path('__debug__/', include(debug_toolbar.urls))
        ] + urlpatterns  # type: ignore

    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)  # type: ignore
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
