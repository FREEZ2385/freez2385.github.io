# Django 기본 설치 방법

**해당 방법은 윈도우 10을 기준으로 작성하였습니다.**

Django는 Python의 프레임워크이기에, Python(pip) 혹은 Anaconda에서 직접 다운받을 수 있다. Python을 설치하는 방법은 생략하고 진행하겠다.

만약 Python을 설치하게 되면, Windows 환경설정 -> 환경 변수에서 PATH를 통해 cmd에 직접 pip를 입력해주어 명령 크롬프트에서도 직접 사용이 가능하도록 설정이 가능하다.

```
여기에 이미지 붙이면 좋을 것 같다.
```

## 가상환경 설정

그 후에 별도의 환경에서 Django를 다운받고 싶다면 가상환경을 생성해 진행시켜야 한다. 먼저 가상환경 프레임워크를 설치한다.

```
python -m pip install virtualenv
```

추후에 원하는 경로에 가상환경 폴더를 생성하여, 가상환경을 이용하도록 해보자.

```
virtualenv django_test
```

가상환경 폴더가 생성되었으면, 폴더 내부의 ```(가상환경 폴더)/Scripts/Activate.bat```를 진행시켜야 가상환경을 진행시킬 수 있게 된다.

```
django_test\Scripts\Activate
```

가상환경을 진행시키게 되면
```
(django_test) c:\django_test>_
```
명령 콘솔 왼쪽에 ```(가상환경 폴더명)```이 표시되면, 가상환경을 생성 및 접근까지 완료되었다.

## Django 설치

이제 본격적인 Django 설치를 진행하도록 하자. Django는 방금전 가상 환경을 설치한 것과 같이, ```pip install```을 이용하여 Django를 설치할 수 있다.

추가로 Django이외에 다른 라이브러리를 설치하기 위해서도 사용되기도 하며, 패키지 및 라이브러리 검색하여 설치 및 사용 방법을 확인하고 싶다면, 아래 URL을 이용하면 된다.

## **[PYPI [파이썬 패키지 인덱스] (https://pypi.org/)](https://pypi.org/)**

이제 ```pip install```를 입력해 Django를 설치해보자

```
python -m pip install django
```

입력까지 다 되었다면, Django는 설치까지 완료되었다.

## Django 프로젝트 생성

본격적으로 Django를 사용하기 위해서는 프로젝트 파일을 작성해야 한다. 프로젝트를 생성하게 되면 내부에 데이터베이스 옵션, Django기본 옵션, 인스턴스들을 자동으로 생성해주어 생성한 상태에서도 바로 구동 가능하도록 해주고 있다.

그렇다면, 프로젝트를 만드는 명령어를 작성해보자

```
django-admin startproject test_django(작성할 프로젝트명)
```

명령어를 사용하면 자동으로 구동에 필요한 모든 옵션들과 인스턴스가 생성된다. 데이터베이스 기본 구성은 MySQL이며, 추후에 Settings.py라는 곳에서  MongoDB 혹은 Postgres로 변경이 가능하다.

파일이 생성되면 파일 구성은 다음과 같다.

```Java
C:\test_django.
|   manage.py // 프로젝트 관련 명령어 처리 파일. 기본적으로 서버 구동 혹은 마이그레이션도 전부 여기서 처리한다.
|
\---test_django // 프로젝트에 대한 기본 설정, URL, 기본 인스턴스들을 모아놓은 폴더
        asgi.py
        settings.py // 프로젝트 관련 설정 관리 파일
        urls.py // 서버 URL 관리 및 각 어플리케이션 URL경로 연결
        wsgi.py // Python 표준 Gateway Interface
        __init__.py
```
파일 생성이 완료되었다면, manage.py로 명령어를 보낼 수 있다. 우선 간단한 서버 기동 명령어를 작성하여, 서버가 작동하는지 확인하자.
```
(manage.py가 있는 폴더 안에서) python manage.py runserver
```
를 입력하게 되면 하단의 메시지가 작성되면서 서버 기동이 시작된다.
```
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

February 17, 2020 - 18:14:55
Django version 3.0.2, using settings 'test_django.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CTRL-BREAK.
```
그리고 인터넷 브라우저로 넘어가 URL을 ```http://localhost:8000/```를 입력하고 접속 하면 아래 이미지와 같이 django의 성공 화면이 표시될 것이다.

이와같이 기본적인 django의 설치부터 시작해 서버 기동 및 URL접속까지 완료하셨습니다. 이제 기능별로 가동하는 페이지(앱) 작성 및 앱의 구성을 확인해보겠다.

---

## django(tutorial) 종료