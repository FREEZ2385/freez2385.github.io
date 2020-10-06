---
title: Docker-compose의 운용과 작성방식
date: 2020-10-06 22:00:00 +0900
categories: [Development, Docker]
tags: [Docker, Virtual, Container, Image]
seo:
  date_modified: 2020-09-28 22:25:47 +0900




---

**본 포스트는 MacOS 10.15.7 을 기준으로 작성하였습니다.**

저번 포스팅에서 Dockerfile을 이용하여 컨테이너를 통해서 이미지를 빌드시키는 방법을 설명했었다. 이번에는 이러한 컨테이너들을 다중으로 존재할 때 쉽게 제어가 가능한 `Docker-compose` 에 대해서 알아보도록 하겠다. `Docker-compose` 는 Docker를 이용하기 위한 툴로써 여러가지 컨테이너들을 관리 혹은 실행하기에 아주 편리함을 가지고 있다. 특히 docker의 명령어로 사용하는 run의 경우 환경 설정을 하고 실행을 위해서는 몇번 써야 하는 경우가 빈번하지만, `Docker-compose` 는 이러한 다중 명령어를 처리하는 docker-compose.yml에 작성해 `up` 혹은 `run` 하나로 순식간에 다중 명령어를 입력할 수 있다. 

거기에다 Docker-compose는 거의 대부분의 환경을 구상(Product, Test, Development)할 수 있기에, 다양한 환경으로 프로젝트를 관리 혹은 개발이 가능하다. 이번에는 저번 포스팅에서 작성한 프로젝트를 기반으로 직접 `Docker-compose` 를 사용해 실행까지 하는 방법에 대해서 설명해보도록 하겠다.

-----

## Docker-compose.yml

`Docker-compose` 를 사용하기 위해선 우선 `yml` 파일이 필요하다. docker-compose.yml 파일을 생성해서 각 환경에 대한 구성 및 이미지명, 그리고 구성을 좀 더 다양하게 작동시킬 수 있다. 저번에 작성한 Dockerfile이 쉽게 컨테이너를 생성할 수 있다면 Docker-compose는 쉽게 컨테이너를 조작할 수 있다고 볼 수 있다. 그럼 지난 포스팅에 이어서 django의 프로젝트를 docker-compose로 실행해보도록 하겠다.

지난 포스팅 => [Dockerfile 작성 및 빌드를 해보자](https://freez2385.github.io/posts/Dockerfile/)

지난 포스팅에서 작성한 Django 프로젝트에 Dockerfile까지 생성했다면, 이번에는 docker-compose.yml 파일을 생성해 다음과 같이 작성해 보도록 하자.

```yaml
version: "3.0"
   
services:
  db:
    image: postgres
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
    depends_on:
      - db
```

간단히 해석을 하자면 맨 위에 있는 `version` 은 yaml 파일의 버전이라고 생각하면 된다. 대체로 docker는 `3.0` 에 compose가 적합하기에 보통은 `3.0` 을 사용한다. yaml파일에서는 version이 맨 위에 올라가도록 해야 한다.

그리고 `services` 는 docker 컨테이너의 옵션을 의미한다. 각 웹 어플리케이션, 데이터베이스등 하나의 프로젝트라는 의미로도 사용하고 있다. `services` 안에서 각 어플리케이션, 데이터베이스 등의 다양한 환경등을 제각각 조정 가능하다.

각 `db` , `web` 는 말할 필요 없이 데이터베이스, 웹 어플리케이션의 옵션 설정이다. 하지만 각 입력에 사용하는 명령어가 다르니 주의해야 한다. 우선 `db` 에 대한 내용부터 알아보도록 하겠다.

`db -> image` 는 데이터베이스의 이미지명이다. docker hub에서 데이터베이스명을 직접 빌려와서 컨테이너까지 전부 생성하도록 만들어준다. 대표적으로 postgres, mongodb등 다양한 이미지를 가져올 수 있다.

`db -> enviroment` 는 데이터베이스 내 환경설정을 의미한다. 각 데이터베이스에 필요한 환경들을 여기서 설정할 수 있으며, 데이터 베이스에 필요한 옵션을 수정할 수 있다.

`web -> build` 는 저번 포스팅에서 알려준 docker build의 명령어이다. docker를 빌드할때 어디에 빌드할 것인지 위치만 지정해주면 해당 위치의 Dockerfile을 알아서 찾아 빌드작업을 실행한다. 지난 포스팅에 작성한 Dockerfile을 자동으로 docker-compose에서 실행할 수 있다는 소리가 될 수 있다.

`web -> command` 는 빌드에 성공하고 난 후에 자동으로 진행해줄 명령어이다.  `docker run` 의 명령어를 빌드하자마자 실행한다고 볼 수 있다. 그렇기에 빌드가 성공하면 자동으로 django의 runserver를 이용해 서버를 작동시키는 의미이기도 하다.

`web -> volumes` 는 컨테이너 내부에서 실행할 볼륨 위치이다. 지난 dockerfile에 파일들을 전부 컨테이너의 /code 안에 카피하는 형태로 되어 있기에, 이번에 실행되는 데이터들도 역시 volumes에 위치를 지정해주어야 한다.

`web -> ports` 는 컨테이너의 포트 할당이다. `docker run -p` 와 같은 명령어이다. 해당 서비스의 웹 어플리케이션의 포트를 지정해줄 수 있으며, 지정하지 않는다면 각 웹 프레임워크, 데이터베이스 고유 포트로 지정해준다.

`web -> depend_on` 은 서비스 내 다른 환경과의 의존을 의미한다. django의 데이터베이스로 postgres를 이용하기 위해 의존 관계를 `db` 로 지정했기 때문에 자연스럽게 연동이 가능하게끔 조정이 되어 있다.



-----

## Docker-compose 명령어

이제 docker-compose.yml을 작성하고 나면 본격적으로 docker를 빌드 할 수 있게 되었다. 실제로 docker 명령어를 작성하지 않고도 docker-compose 하나면 다 가능하기 때문에 간편한 것이 장점이라 할 수 있다.

```
docker-compose up
```

docker-compose.yml의 파일 위치에서 실행 시 자동으로 파일의 정보를 인식해 빌드부터 실행까지 전부 처리해준다. 

```sh
> docker-compose up
Starting projectfordocker_db_1 ... done
Starting projectfordocker_web_1 ... done
Attaching to projectfordocker_db_1, projectfordocker_web_1
db_1   | 
db_1   | PostgreSQL Database directory appears to contain a database; Skipping initialization
db_1   | 
db_1   | 2020-10-06 12:40:39.512 UTC [1] LOG:  starting PostgreSQL 13.0 (Debian 13.0-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
db_1   | 2020-10-06 12:40:39.512 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
db_1   | 2020-10-06 12:40:39.512 UTC [1] LOG:  listening on IPv6 address "::", port 5432
db_1   | 2020-10-06 12:40:39.514 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
db_1   | 2020-10-06 12:40:39.519 UTC [26] LOG:  database system was shut down at 2020-10-05 13:38:31 UTC
db_1   | 2020-10-06 12:40:39.530 UTC [1] LOG:  database system is ready to accept connections
web_1  | Watching for file changes with StatReloader
```

필자는 한번 빌드를 한 터라 빌드 단계를 스킵하고 바로 port, command 작업으로 들어갔다. 그리고 나서 url로 localhost:8000 으로 들어가면 django 프로젝트가 실행되는 것을 확인할 수 있다. 이렇게 명령어 하나로 빌드부터 시작해 시작까지 전부 겸비한 docker-compose를 이용해서 필자는 편리함을 확실하게 느낄 수 있었다. 그리고 추가적으로

```
docker-compose up -d
```

을 사용하면 현재 실행되는 컨테이너의 로그들을 전부 무시하고 docker에서 계속 run상태로 유지해준다. 

```
docker-compose down
```

up이 있으면 반드시 down도 있는 법이다. 빌드부터 커멘드까지 입력하는 것이 up이라면 종료하는 것인 down으로 처리할 수 있다. 단순히 종료만 하는 것이 down이라면

```
docker-compose down --rmi all 
```

이 명령어는 해당 이미지까지 순식간에 날려버릴 수 있다. 그렇기에 개발환경에 변화가 있어서 이미지를 새로 빌드 해야 한다는 경우에는 이렇게 이미지까지 삭제시키고 다시 빌드시킬 수 있다.

