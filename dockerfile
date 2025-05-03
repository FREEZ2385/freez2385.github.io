FROM ubuntu:22.04

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    python3.11 \
    python3-pip \
    ruby-full \
    ruby-dev

# 작업 디렉토리 설정 및 복사
WORKDIR /mydir
COPY ./ /mydir

# Ruby gem 설치 (Gemfile이 있는 경우)
RUN gem install bundler
RUN bundle install

# 필요하면 Python 패키지 설치
RUN pip3 install -r requirements.txt

# Python 스크립트 실행 후 Jekyll 실행
RUN bundle exec jekyll build
