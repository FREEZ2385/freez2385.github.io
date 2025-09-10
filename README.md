# 프리즈의 귀차니즘

[![Build Status](https://travis-ci.com/cotes2020/jekyll-theme-chirpy.svg?branch=master)](https://travis-ci.com/cotes2020/jekyll-theme-chirpy)
[![GitHub license](https://img.shields.io/github/license/cotes2020/jekyll-theme-chirpy.svg)](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/LICENSE)
[![996.icu](https://img.shields.io/badge/link-996.icu-%23FF4D5B.svg)](https://996.icu)

프리즈의 귀차니즘 블로그 전용 Git 컴포넌트로 기술 개발 및 관련 정보에 관한 글들을 포스트로 작성해 사용할 것이다.

## 권장 프로그램

```
Python = 3.11
Ruby = 3.4.5
```

## 설치 방법

처음 Git에서 Clone 했을 시에 해당 패스에서 각 프로그램 별로 플러그인을 설치할 필요가 있다.

```
pip install -r requirement.txt
gem install bundler
```

## 포스팅 구성

포스팅 구성은 한국어와 일본어로 나뉘어 있으며, 제각각 이하의 파일로 나뉘어 있다

```
_i18n
 ㄴ ja // 일본어
    ㄴ_posts ⇒ 포스팅 내용
    ㄴ_tabs ⇒ about
 ㄴ ko // 한국어
    ㄴ_posts ⇒ 포스팅 내용
    ㄴ_tabs ⇒ about
```

## 포스팅 방법

1. 포스팅 구성에 맞춰 각 언어별 폴더 내 \_posts 폴더에 md 파일로 내용을 작성.  
   포스팅 관련 템플릿은 아직 작성중. 이전 포스팅의 템플릿을 참고
2. 포스팅을 작성 후 태그 혹은 카테고리에 추가가 발생할 경우, `/_posts`에 md 파일을 카피
3. 해당 내용을 master브런치에 커밋 후 push
4. sh 커맨드가 가능한 터미널로 이하의 명령어를 실행  
   ※ Windows - Git Bash  
   ※ Mac - Terminal

```
sh tools/post-push.sh
```
