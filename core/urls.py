from typing import List, Union

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.http.response import HttpResponse
from django.urls import include, path
from django.urls.resolvers import URLResolver

URLList = List[Union[URLResolver, object]]

core_urlpatterns: URLList = [
    path('~', lambda request: HttpResponse('🙃'), name='root'),
    path('admin/', include('admin_honeypot.urls', namespace='admin_honeypot')),
    path(settings.ADMIN_BASE_URL, admin.site.urls),
]

apps_urlpatterns: URLList = [
    path('accounts/', include('accounts.urls')),
    path('tasks/', include('task_manager.urls')),
]

urlpatterns = core_urlpatterns + apps_urlpatterns

if settings.DEBUG:
    if 'debug_toolbar' in settings.INSTALLED_APPS:
        import debug_toolbar

        urlpatterns = [
            path('__debug__/', include(debug_toolbar.urls))
        ] + urlpatterns  # type: ignore

    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)  # type: ignore
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
