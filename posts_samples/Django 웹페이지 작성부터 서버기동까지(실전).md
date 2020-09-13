# Django 웹페이지 작성부터 서버기동까지(실전)

**해당 방법은 윈도우 10을 기준으로 작성하였습니다.**

Django 내부의 어플리케이션을 바로 이해하기는 힘들 수 있기에, 이번에 다루어볼 내용은 이전의 페이지를 참고하지 않고, 바로 실전으로 웹페이지를 작성하고 서버를 기동하는 과정까지 다루어볼 예정이다. 이전 페이지인 어플리케이션의 분석은 추후 Django에 익숙해져 있을때, 다시 확인한다면 이해하기 쉬울 것이다.

우선 Django의 서버기동부터 웹페이지의 전달까지의 흐름을 간략히 요약해보겠다.

```
서버기동 -> URL 이동 -> URL에 대응하는 View로 이동 -> View의 템플릿 처리 -> 템플릿 표시
```

등으로 표현할 수 있다. 처음 접하는 분들에겐 생소할 수 있으므로, 바로 실전에 돌입을 해보겠다.

## 어플리케이션 생성

우선 어플리케이션 생성 전까지의 프로젝트 생성 과정은 해당 URL을 통해 이용하기 바라며, 이번에는 어플리케이션 생성부터 시작하도록 하겠다.

// TODO URL 프로젝트 생성 관련

어플리케이션은 생성된 프로젝트 내부 폴더로 들어가, manage.py에 있는 명령어를 입력하여, 내부에 어플리케이션을 생성할 수 있다. 해당 명령어는 다음과 같다.

```
python manage.py startapp (어플리케이션 이름)
```

이렇게 되면 폴더안에 어플리케이션 이름으로 폴더가 하나 만들어진다. 그와 동시에 여러가지 구성파일이 생성되어지는데 프로젝트 구성은 다음과 같다.

```python
# Project명 : test_django
# App명 : test_app
C:.
│  db.sqlite3
│  manage.py
│
├─test_app
│  │  admin.py
│  │  apps.py
│  │  models.py
│  │  tests.py
│  │  views.py ★
│  │  __init__.py
│  │
│  └─migrations
│          __init__.py
│
└─test_django
    │  asgi.py
    │  settings.py ★
    │  urls.py ★
    │  wsgi.py
    │  __init__.py
    │
    └─__pycache__
```

구성된 파일안에서 우리가 사용할 것은 ★표시가 되어 있는 파일들이다.
- views.py
- settings.py
- urls.py

우선 어플리케이션이 생성되었다면, 우선 프로젝트 안에 어플리케이션을 등록해주어야 한다. 어플리케이션 등록은 settings.py안에 ```INSTALLED_APPS```변수 안에서 처리해주어야 한다. 실제로 코드를 확인해보자.

```python
# settings.py 내부
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

settings.py파일 내부에 INSTALLED_APPS변수를 볼 수 있다. 이 안에 어플리케이션을 등록해야 그 안의 어플리케이션을 진행할 수 있다.

```python
# settings.py 내부
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'test_app', # 어플리케이션 이름을 작성
]
```

어플리케이션을 등록했으면, 이제 URL로 해당 어플리케이션 View로 연동하여 전달할 수 있다. 이번 과정은 한 어플리케이션 안에서만 실행할 예정이기 때문에, 프로젝트 파일 내 urls.py안에서 처리하도록 하겠다.

urls.py를 열면 해당 코드가 쓰여져 있다.

```python
# urls.py 내부
"""
test_django URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
]
```
현재 코드에는 관리자 페이지로 이동하는 경로만 지정되어 있다. 원하는 경로를 생성하기 위해서는 path에 등록할 View가 필요하다. View를 먼저 생성 후 url path를 지정하면, 순조롭지 않을까 생각된다.

Views.py에서 View를 생성해보도록 하자.
```python
# views.py 내부
from django.shortcuts import render

# Create your views here.
```
views.py를 들어가게 되면 초반에는 아무것도 작성되지 않은 채 import만 적혀있을 것이다. 여기서, 간단히 문자를 출력하는 View를 생성해보도록 하겠다.

```python
from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def write_helloworld(request):
    return HttpResponse('Hello World!')
```

간단한 문자만 출력 후 템플릿으로 넘기는 HttpResponse로 작성해 보았다.

이로서 Views에 write_helloworld라는 view가 작성되었다. 이제 이걸 urls.py에 import후 write_helloworld을 출력할 url경로를 작성하도록 하겠다.

```python
# urls.py 내부
"""
test_django URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from test_app.views import write_helloworld

urlpatterns = [
    path('admin/', admin.site.urls),
    path('/', write_helloworld, name='write_helloworld'),
]
```

도메인을 열면 바로 Hello World!가 작성되게끔 path에 등록을 해보았다. 거기에 추가로 name을 넣은 것은, 추후 템플릿에서 해당 url로 불러오기 쉽게 처리하기 위해 추가하였다. 이 부분은 추후 설명하도록 하겠다.

이렇게 url을 추가하게 되면, 전체적인 모든 준비가 끝났고, 서버를 기동시키는 일만 남게 되었다.

서버를 기동시키는 방법은 저번 포스트에서도 개시한 적이 있다.

```
python manage.py runserver
```

이제 서버를 기동하게 되면, url를 임의설정하지 않은 이상 자동으로 http://localhost:8000/ 로 지정되어진다. url로 들어가면

// TODO image 화면 출력

이렇게 Hello World!만 작성되어 있는 템플릿을 볼 수 있게 된다. 이렇게 기본적인 view등록부터 url path 지정하고 서버 기동까지 전반적인 웹페이지를 간략하게 구성해보았다.

데이터베이스와 템플릿의 운용, 혹은 라이브러리의 이용 등을 통하여 원하는 웹페이지를 작성해 구성할 수 있게 된다.

기본적인 웹페이지를 구성해보았고, 다음 포스트에서는 지금의 기능들의 응용으로 데이터베이스의 사용법 혹은 Django내부의 기능들에 대해서 설명해보도록 하겠다.

---

## django(write custom template) 종료