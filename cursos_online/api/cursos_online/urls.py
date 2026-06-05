from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views
from django.conf import settings
from django.conf.urls.static import static
from core import views
from django.views.generic import TemplateView


from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('django.contrib.auth.urls')), 
    
    path('api/token/', obtain_auth_token, name='api_token_auth'),
    
    path('o/', include('oauth2_provider.urls', namespace='oauth2_provider')),

    path('', include('core.urls')),

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

