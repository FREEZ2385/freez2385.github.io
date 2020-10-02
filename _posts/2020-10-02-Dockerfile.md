---
title: Dockerfile 작성 및 빌드를 해보자
date: 2020-10-02 20:40:00 +0900
categories: [Development, Docker]
tags: [Docker, Virtual, Container, Image]
seo:
  date_modified: 2020-09-28 22:25:47 +0900






---

**본 포스트는 MacOS 10.15.7 을 기준으로 작성하였습니다.**

필자는 프로젝트를 개발하면서 서버 인프라에 Docker를 사용하고 있다. 그러면서 Docker에 이미지를 생성해 직접 빌드하는 경우도 종종 볼 수 있었다. 이번에는 직접 Docker에 이미지 생성을 하는 `Dockerfile` 이라는 개념에 대해 설명하도록 하겠다. 이전 포스팅에서 이미지가 발주하는 물품들의 리스트라고 비유를 한 적이 있다. `Dockerfile` 은 이런 리스트들을 쌓는 순서도 같은 개념이라고 보면 된다. 실질적인 문서형태라고 생각하면 될 듯하다. 

예를 들어 이미지 안에 처음에는 `FROM` 을 사용해 OS 환경을 구축하고 그 후에 `ENTRYPOINT` 를 사용해 환경 설정을 해준 후 `RUN` 을 사용해 어플리케이션을 설치 및 라이브러리 환경 구성을 하는 단계로 이어지게 된다. 이렇게 Dockerfile은 만약에 이미지가 만들어졌다고 가정했을 때 어떤 OS를 넣을 것인지 혹은 어떤 환경을 넣을 건지 설정할 수 있는 방식이라 생각하면 된다.

필자는 Python의 `Django` 를 많이 사용해왔기 때문에 Python 이미지를 가져와 구축하는 방식으로 진행해볼까 한다.

-----

## Dockerfile의 간단한 기본형태

본격적으로 `Dockerfile` 을 작성하기 전에 간단한 Dockerfile을 작성해보기로 하겠다. 간단한 어플리케이션을 사용하지 않고 여기서 직접 한 파일에 Dockerfile을 만들어보기로 했다.

```dockerfile
FROM alpine

ENTRYPOINT ["echo", "Hellodocker!"]
```

우선 간단한 리눅스 형태인 alpine이미지를 생성해 거기에 Hellodocker!를 출력하는 간단한 Dockerfile을 만들어보도록 하겠다. 우선 OS를 가져오기 위해 `FROM` 을 사용해 리눅스 알파인 이미지를 가져온다. 그리고 `ENTRYPOINT` 는 컨테이너 안에서 직접 실행하는 명령어를 가져오게 된다. 이렇게 가져오고 난 후에 터미널로 빌드를 실행해보겠다. 해당 Dockerfile이 있는 패스로 이동한 후

```
docker build --tag testecho:1.0 .
```

을 시켜주도록 한다. 여기서 tag는 해당 이미지의 이름과 같다. testecho는 이미지명으로 지정하고 그 옆의 1.0은 버전으로 처리된다. 실행하게 된다면

```
> docker build --tag testecho:1.0 .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM alpine
latest: Pulling from library/alpine
df20fa9351a1: Pull complete 
Digest: sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321
Status: Downloaded newer image for alpine:latest
 ---> a24bb4013296
Step 2/2 : ENTRYPOINT ["echo", "Hellodocker!"]
 ---> Running in 63177cc875b7
Removing intermediate container 63177cc875b7
 ---> df5dac324dba
Successfully built df5dac324dba
Successfully tagged testecho:1.0
```

이렇게 testecho이미지가 빌드되며 여기서 

```
docker images
```

를 입력하게 되면 

```
> docker images
REPOSITORY               TAG                 IMAGE ID            CREATED              SIZE
testecho                 1.0                 df5dac324dba        About a minute ago   5.57MB
alpine                   latest              a24bb4013296        4 months ago         5.57MB
```

`Docker Hub` 안에서 직접 가져온 alpine과 빌드한 testecho가 형성되게 된다. 이렇게 직접 빌드를 했으면 실행하는 방법도 알아둬야 하지 않겠는가

```
docker run testecho:1.0
```

를 입력하게 되면

```
> docker run testecho:1.0
Hellodocker!
```

이전 Dockerfile에 작성한 ENTRYPOINT의 echo가 실행이 되며 출력이 되는 것을 확인할 수 있다. 이렇게 Dockerfile을 작성해 직접 이미지를 생성해 환경구성도 가능하다는 점에서 편리함을 느낄 수 있다. 그렇다면 본격적으로 필자가 실행하는 Django의 Dockerfile작성법을 실행해 보도록 하겠다.

-----

## Django의 Dockerfile작성

방식 참조 : [Docker 공식 문서 (Quickstart: Compose and Django)](https://docs.docker.com/compose/django/)

Django의 이미지 생성은 상당히 간단한 편이지만 직접 실행까지는 `docker-compose` 의 개념도 알아야 하기 때문에 본 포스팅에서는 Dockerfile작성 후 이미지 생성을 진행해보기로 하겠다. 우선 Dockerfile을 만들기 전에 Django 프로젝트를 생성해보도록 하겠다. 

```
django-admin startproject ProjectForDocker
```

프로젝트가 생성되었다면 폴더 안으로 들어가서 Dockerfile을 생성하도록 하겠다. Django의 Dockerfile은 다음과 같다.

```dockerfile
FROM python:3
ENV PYTHONUNBUFFERED=0
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
```

이 Dockerfile에 사용된 각 명령어들을 나열하겠다.

`FROM` : Docker Hub에서 이미지를 가져와서 컨테이너에 적용시킨다.
`ENV` : 환경설정을 실행해주는 명령어다. Windows의 cmd로는 export와 같은 개념이다.
`RUN` : 이미지내의 파일 실행 혹은 행동들을 명령어로 표현하는 명령어다.
`WORKDIR` : RUN혹은 COPY를 실행시킬 위치를 지정하는 명령어이다.
`COPY` : 빌드시 들어가는 로컬 파일들을 이미지로 직접 복사하는 명령어이다. (첫번째 인수: 로컬에서 가져올 파일 위치 혹은 파일명, 두번째 인수: 이미지내에 이동시킬 파일 위치)

이렇게 각 Dockerfile의 명령어를 작성해보았다. 빌드하기에 앞서 Python의 라이브러리들을 설치해야 하는 것이 우선이다. Python의 라이브러리를 일괄 설치해주는 `requirements.txt` 를 작성해야 한다. 우선 기본적으로 Django가 필요하며 Django의 디폴트 DB인 Postgres에 접속이 필요하므로 `requirements.txt` 를 이렇게 작성해보도록 하겠다.

```
Django 					== 3.1.2
psycopg2-binary == 2.8
```

이렇게 Django 설치에 필요한 라이브러리를 requirements.txt를 작성까지 했으니 직접 Docker에 빌드해보도록 하겠다.

```
docker build --tag djangofordocker:1.0 .
```

처음에는 라이브러리에서 직접 파이썬 이미지를 가져오기때문에 대용량으로 가져올 것이므로 시간이 필요하다. 혹시 파일 위치가 잘못 되었거나 Dockerfile 수정이 없는 한 빌드는 문제없이 성공할 것이다. 이제 이미지 리스트를 확인해보면

```
> docker images
REPOSITORY               TAG                 IMAGE ID            CREATED              SIZE
djangofordocker          1.0                 b53b44b7865d        About a minute ago   926MB
testecho                 1.0                 df5dac324dba        34 minutes ago       5.57MB
python                   3                   bbf31371d67d        7 days ago           882MB
alpine                   latest              a24bb4013296        4 months ago         5.57MB
```

djamgofordocker 이미지가 잘 들어가있는 것을 확인할 수 있다. 이렇게 Django이미지 빌드를 했으면 직접 실행까지 시켜봐야 한다. 다음 포스트에서는 docker-compose에 대해서 알아보겠다.