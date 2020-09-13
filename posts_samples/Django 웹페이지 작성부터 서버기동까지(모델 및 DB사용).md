# Django 웹페이지 작성부터 서버기동까지(모델 및 DB사용)

**해당 방법은 윈도우 10을 기준으로 작성하였습니다.**

웹페이지에서 중요한 것은 템플릿으로 화면을 보여주는 것 뿐만이 아니라, 앞에서 보여주지 않는 뒤에서 데이터를 처리하는 데이터베이스와의 접촉과 받은 데이터의 처리를 템플릿에 정확하게 보여주는것도 더할나위 없이 중요하다. 데이터베이스에서 데이터라는 재료를 받아, 백엔드로 요리를 한다음, 템플릿으로 요리를 내놓는 과정으로 이번에는 이런 과정을 한번 간단하게 설명해보도록 하겠다.

이전 포스트의 웹페이지 작성과정에서 덧붙여, 데이터베이스를 추가하는 방식으로 다시한번 추가해보도록 하겠다.

혹시 이전 웹페이지만 출력하는 방법을 확인하고 싶으면, 하단 URL로 넘어가도록 하자.

```
URL
```

데이터베이스를 넘어가기 전에 Django의 데이터베이스 처리방식인 모델에 대해 알아보자

## Model

Django의 패턴은 MVT로 구성되어 있는데, 그중 M은 Model을 의미하게 된다. 데이터베이스에서 데이터를 정의하고, 구성하고, 받아오는 요소로 ORM 기법을 사용하여, SQL 문법을 사용하지 않아도, Python 기법으로 데이터를 받아오고, 정의할 수 있다.

시작하기에 앞서 기본 어플리케이션 생성부터 시작해보도록 하겠다.

```
python manage.py startapp (어플리케이션 이름)
```

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
│  │  models.py ★
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
- ```models.py``` 이번에 추가될 파일