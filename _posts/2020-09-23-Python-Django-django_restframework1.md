---
title: Django restframework의 기본 및 시작하기
date: 2020-09-23 21:20:00 +0900
categories: [Development, Python, Django Restframework]
tags: [Django, DjangoRestframework]
seo:
  date_modified: 2020-09-23 21:43:04 +0900



---



**본 포스트는 MacOS 10.15.6 을 기준으로 작성하였습니다.**

Django는 웹 프레임워크로 이용하면서 동시에 RestfulAPI 전용의 어플리케이션으로도 활용할 수 있다. RestfulAPI 서버로 활용가능하며 때에 따라서는 백앤드 어플리케이션으로 활용할 수 있다. 필자도 React.Js를 작성하면서 DB에서 불러내는 데이터를 파싱하기 위해 백앤드 전용 어플리케이션으로 Django Rest Framework를 사용하고 있다. 그렇기에 React.Js는 프론트 전용으로만 사용할 수 있어 프론트엔드 백엔드의 정의를 확실히 구분지을 수 있게 되었다.

Django Rest Framework는 기본적으로 Django의 라이브러리의 일종이기 때문에 PyPI에서 다운받아서 사용할 수 있다. pip에서 다운로드 받아보도록 하자.

## 기본 설치 및 준비과정

```sh
python -m pip install djangorestframework
python -m pip install django-filter # Restful API에서 filter를 사용할 때 필요함
```

Django Rest Framework를 설치하고 나면 실제로 RestfulAPI 서버로 쓰일 Django 프로젝트를 만들어보고 그 이전에 필요한 설정을 해두도록 하겠다.

```
└── test_restframework # Project명
    ├── db.sqlite3
    ├── main # 모델을 넣을 App명
    │   ├── __init__.py
    │   ├── __pycache__
    │   ├── admin.py *
    │   ├── apps.py
    │   ├── migrations
    │   ├── models.py *
    │   ├── tests.py
    │   └── views.py
    ├── manage.py
    └── test_restframework
        ├── __init__.py
        ├── __pycache__
        ├── asgi.py
        ├── settings.py *
        ├── urls.py
        └── wsgi.py
```

위에 *기호는 기본 프로젝트 디렉토리에서 수정을 조금 한 파일이다. 실제로 모델을 등록하고 추가하기 위해 한 내용들이라고 할 수 있다. Django의 Model등록 방법은 해당 포스트에서 확인하기 바란다.

<u>추가 예정</u>

수정한 모델 내용은 다음과 같다.

```python
# models.py
class Author(models.Model):
    name = models.CharField('Author name', max_length=10, primary_key=True)

class Book(models.Model):
    title = models.CharField('title', max_length=50, primary_key=True)
    pages = models.IntegerField('Page Number')
    author = models.ForeignKey(Author, on_delete=models.CASCADE, null=True, blank=True)

```

그리고 이제 본격적인 RestFramework를 넣어보기로 하겠다. 우선 Django RestFramework의 기본적인 구상은 이렇다.

![rest_framework1](../../assets/img/2020_09_23_python_django_restframework1/rest_framework1.png)

기본적인 Django 의 DB에서 클라이언트의 흐름도에서 Serializer가 추가되었다. Serializer는 기존 HTML의 형태로 랜더링된 Queryset를 Restful에 대한 JSON으로 매핑하여 Response에 보내지는 역할을 하고 있다. 이제 실제로 넣어보도록 하겠다. 해당 내용은 공식 문서를 기반으로 재작성해보았습니다. 공식 문서는 밑의 URL를 참조해주시기 바란다.

[how to install and apply django rest framework](https://www.django-rest-framework.org/#installation)

## Settings.py

우선 settings.py에 Django Restframework를 지정해 주기로 하겠다.

```python
# settings.py
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'main', # 모델 등록용 App
    'rest_framework',
]

...

# 추가 기입
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.DjangoModelPermissionsOrAnonReadOnly'
    ]
}
```

## Serializers.py

그리고 main 폴더 안에 serializers.py 파일을 새로 만들어 serializer를 보관하는 파일로 지정하는게 편하다. 

```python
# add serializers.py
from main import models
from rest_framework import serializers

# Serializers define the API representation.
class AuthorSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Author
        fields = ['name']

# Serializers define the API representation.
class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Book
        fields = ['title', 'pages', 'author']
```

## Views.py

그리고 views.py에서 각 모델에 대한 viewset를 만들어보도록 하겠다.

```python
# views.py
from django.shortcuts import render
from main import models, serializers
from rest_framework import viewsets

# Author model viewset
class AuthorViewSet(viewsets.ModelViewSet):
    queryset = models.Author.objects.all()
    serializer_class = serializers.AuthorSerializer

# Book model viewset
class BookViewSet(viewsets.ModelViewSet):
    queryset = models.Book.objects.all()
    serializer_class = serializers.BookSerializer
```

## Urls.py

이제 View지정까지 했으니 URL에 viewset를 지정하도록 하겠다. 우선 편의성을 위해 main폴더 안에 urls.py를 추가했다.

```python
# add main/urls.py
from django.contrib import admin
from django.urls import path, include
from rest_framework import routers
from main import views

router = routers.DefaultRouter()
router.register(r'author', views.AuthorViewSet)
router.register(r'book', views.BookViewSet)

urlpatterns = [
  path('', include(router.urls)),
  # Django Restframework에 로그인 인증을 위한 URL.
  path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    
]

```

그리고 프로젝트에 해당 App의 URL을 집어넣으면 간단한 Viewset가 완성된다.

```python
# test_restframework/urls.py
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('main/', include('main.urls'))
]
```

## 결과

이제 완료되었다면 해당 마이그레이션 부터 실행까지 시키도록 하겠다.

```sh
python manage.py makemigrations

python manage.py migrate

python manage.py createsuperuser

python manage.py runserver
```

실행시킨 후 localhost:8000/main/으로 들어가게 된다면 restframework GUI로 들어갈 수 있다.

![rest_framework2](../../assets/img/2020_09_23_python_django_restframework1/rest_framework2.png)

![rest_framework3](../../assets/img/2020_09_23_python_django_restframework1/rest_framework3.png)

이렇게 GUI확인이 가능하며 Restful API 테스트가 가능한 Postman을 이용하여 직접 API테스트도 가능하다

![rest_framework4](../../assets/img/2020_09_23_python_django_restframework1/rest_framework4.png)

이렇게 Restful API로 백엔드 어플리케이션으로 활용이 가능하며 프론트엔드는 React.js로 사용하여 완벽하게 프론트엔드와 백엔드를 나누어 개발이 가능하다는 점과 응용을 하여 인증과 Get 혹은 Post만 사용 가능하게 권한 설정도 가능하다. 자세한 응용법은 다음 포스트에 작성하겠다.