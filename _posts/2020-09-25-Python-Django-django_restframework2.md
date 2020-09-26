---
title: Django restframework의 filtering / ordering, APIview
date: 2020-09-25 21:00:00 +0900
categories: [Development, Python, Django Restframework]
tags: [Django, DjangoRestframework]
seo:
  date_modified: 2020-09-25 21:02:58 +0900




---

**본 포스트는 MacOS 10.15.7 을 기준으로 작성하였습니다.**

저번에 작성한 포스트에서 Django Restframework를 이용하여 Restful Api로 만들어 보는 포스트를 사용해보았다. 필자는 현재 개발하는 프로젝트에서 모델에서 직접 가져오는 View이외에도 다른 Request를 불러올 시 백엔드에서 처리하는 함수에도 사용하며 여러 부분에서 사용하는 url을 작성했다. 이번에 작성한 코드를 리팩토링겸 재정리를 위해 작성해보게 되었다. 

이전에 포스팅한 프로젝트에 이어서 여러 응용하는 법에 대해 추가로 작성해보았다. 이전 포스팅 작성에 대해서는 해당 URL을 올리도록 하겠다.
[Django restframework의 기본 및 시작하기](https://freez2385.github.io/posts/Python-Django-django_restframework1/)
이전에 작성한 파일 트리는 현재 다음과 같다.

```
└── test_restframework # 현재 프로젝트명
    ├── db.sqlite3
    ├── main # 모델과 Restframework를 구성하는 App명
    │   ├── __init__.py
    │   ├── __pycache__
    │   ├── admin.py
    │   ├── apps.py
    │   ├── migrations
    │   ├── models.py
    │   ├── serializers.py
    │   ├── tests.py
    │   ├── urls.py
    │   └── views.py
    ├── manage.py
    └── test_restframework
        ├── __init__.py
        ├── __pycache__
        ├── asgi.py
        ├── settings.py
        ├── urls.py
        └── wsgi.py
```

## Filtering, Ordering

데이터베이스에서 모델로 Queryset를 읽을때  Queryset안에서 `filter` 를 하게 되면 쉽게 필터링이 가능하지만 Django Restframework에서 직접 Get 리퀘스트를 받고 Queryset를 부르고 `filter` 를 하면 엄청 귀찮아질 뿐더러 나중에 response도 하나하나 다 출력해줘야한다. 그런 귀찮은 짓을 하지 않기 위한 기능이 `django-filter` 라이브러리를 이용한 기능이다. 해당 기능은 공식 문서에도 기능이 작성되어 있으며 해당 문서를 참고하여 작성하였다.
[Django Restframework How to Filtering](https://www.django-rest-framework.org/api-guide/filtering/#api-guide)

필터링을 하기 위해선 우선 라이브러리가 필요하다. 이전 포스팅에서 설치 방법때 같이 설치했다면 설치할 필요가 없지만 다시한번 작성하도록 하겠다.

```sh
python -m pip install django-filter
```

Django-filter를 설치했다면 우선 `settings.py` 에 설정이 필요하다. settings.py에 각 데이터를 집어넣도록 하자.

```python
# settings.py
INSTALLED_APPS = [
...
    'main',
    'rest_framework',
    'django_filters',
]
...

# RestFramework
REST_FRAMEWORK = {
...
    'DEFAULT_FILTER_BACKENDS': ['django_filters.rest_framework.DjangoFilterBackend']
}
```

`django-filter` 의 Backend와 App을 등록시켜서 적용하도록 세팅을 하고 다음은 `Views.py` 에서 이전에 작성한 `BookViewset`에 필터링 기능을 넣어보도록 하겠다.

```python
# views.py
from django.shortcuts import render
from main import models, serializers
from django_filters.rest_framework import DjangoFilterBackend

class BookViewSet(viewsets.ModelViewSet):
    queryset = models.Book.objects.all()
    serializer_class = serializers.BookSerializer
    filter_backends = [DjangoFilterBackend] # DjangoFilterBackend 로 필터링 백엔드 등록
    filterset_fields = ['title', 'author'] # 필터링할 필드 리스트 지정
```

이렇게 작성되었다면 필터링이 가능한 Viewset가 된다. 그 외에도 이후 작성하는 ApiView에도 적용이 가능하며 다른 모델이 사용되는 Viewset에도 지정가능하다. 이렇게 사용되었으면 API 테스트 어플리케이션은 Postman 혹은 직접 url에서 사용이 가능하다.

![rest_framework1](../../assets/img/2020_09_25_python_django_restframework2/rest_framework1.png)

모델의 author 필드를 직접 필터링 하여 lee라는 이름을 가진 저자의 책들을 필터링 해본 결과 데이터에는 lee 저자의 책들이 전부 필터링되었다. 이렇게 모델의 필터링을 손쉽게 Response하도록 하는 `django-filter` 기능이였다. 

다음은 필터링과 같은 소트 기능을 가진 `Ordering` 을 해보도록 하겠다. 역시 모델의 Queryset기능인 `order_by` 를 쓰면 편하지만, 역시 하나하나 쓰기 귀찮기에 위에 필터링과 똑같이 Backend등록과 필드 등록을 하도록 하겠다. 오더링은 Django RestFramework에 있는 ordering으로 가능하기에 특별히 라이브러리를 설치할 필요가 없다.

```python
# views.py
from django.shortcuts import render
from main import models, serializers
from rest_framework.filters import OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend

class BookViewSet(viewsets.ModelViewSet):
    queryset = models.Book.objects.all()
    serializer_class = serializers.BookSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['title', 'author']
    ordering_fields = ['title']
```

이렇게 필터링과 같이 오더링 백엔드와 필드를 집어넣고 Api 테스트를 시작해보았다.

![rest_framework2](../../assets/img/2020_09_25_python_django_restframework2/rest_framework2.png)

이렇게 URL에 ordering을 추가하고 필드명을 넣으면 `ordering_fields` 에 있는 필드명에 한하여 정렬이 가능하다. 반대로 역정렬은 필드명을 `-title` 집어넣으면 역정렬이 가능하다. 이렇게 필터링과 오더링을 집어넣어 데이터 정렬 혹은 필터가 되며, 그 이외에도 검색 기능도 있어 쉽게 데이터 정리 및 분산이 가능하다.

## ApiView

지금까지는 model의 데이터를 불러내거나 혹은 데이터의 필터 및 정렬만 시도했지만 이번에는 함수를 직접 ApiView에 넣어서 request을 넣어서 response하는 함수를 작성해보도록 하겠다. 간단한 함수로 리퀘스트값에 3을 더해서 리스폰하는 함수를 만들어 직접 URL에 넣어보도록 하겠다.

```python
# views.py
from rest_framework import viewsets, views

class AddThree(views.APIView):
    def get(self, request, format=None):
        num = request.GET.get('num')
        return Response(int(num) + 3)
```

```python
# urls.py

urlpatterns = [
	  ...
    path('add-three/',views.AddThree.as_view()),
]
```

이렇게 get메소드로 파라미터를 num으로 지정해 숫자를 집어넣었다. 이렇게 지정하고 난 후 num에 숫자를 집어넣으면 리스폰 값에 3을 더한 값으로 반환되어 돌아온다. API 테스트를 시도하였다.

![rest_framework3](../../assets/img/2020_09_25_python_django_restframework2/rest_framework3.png)

이번에는 직접 함수안에 쿼리셋을 응용해서 해당 저자의 책종류의 수를 반환하는 함수를 만들어보도록 하겠다.

```python
# views.py
class GetBookCategoryCount(views.APIView):
    def get(self, request, format=None):
        author = request.GET.get('author')
        try:
            count = len(models.Book.objects.filter(author=author))
        except:
            return Response('get error accured')
        return Response(count)
```

```python
# urls.py

urlpatterns = [
	  ...
    path('get-book-count/',views.GetBookCategoryCount.as_view()),
]
```

이번에는 직접 모델의 쿼리셋을 불러서 그에 대한 책 종류수를 반환하는 함수로 작성해보았다. URL을 지정하고 API 테스트를 시도해보면 데이터베이스 내 해당 저자의 책의 종류 수를 구할 수 있다.

![rest_framework4](../../assets/img/2020_09_25_python_django_restframework2/rest_framework4.png)

이렇게 Restful Api를 통해서 백엔드로 함수를 사용 가능한 ApiView를 작성해보았다. 필자도 실제로 데이터베이스에 필요한 파일 업로드 혹은 데이터 사이언스 등도 react.js에서 전달해서 백엔드로 넘기는 작업을 해보았다.