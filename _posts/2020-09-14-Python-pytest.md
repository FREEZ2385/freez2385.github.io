---
title: Python전용 테스트 라이브러리 Pytest
date: 2020-09-14 15:30:00 +0900
categories: [Development, Python, Pytest]
tags: [Pytest]
seo:
  date_modified: 2020-09-23 21:43:04 +0900

---



**본 포스트는 MacOS 10.15.6 을 기준으로 작성하였습니다.**

개발하는 사람들에게 있어서 꼭 필요한 것 중 하나는 바로 테스트이다. 저마다의 개발언어에 맞는 테스트 방법이 있으며 이번에 소개시켜드릴 기능은 파이썬의 테스트 라이브러리인 Pytest를 소개시켜드릴까 한다. 필자도 최근 Django를 사용하면서 테스트 방법을 찾던 도중 Pytest를 알게되었고, 쉽게 테스트 할 수 있다는 것을 알게 되었다.

우선 Pytest를 실행시키기 위해서는 당연히 라이브러리를 설치해줘야 한다. 아마 Anaconda로 실행시키는 프로젝트라면 기본으로 깔려있겠지만, Python으로 설치했다면 Pypi에서 다운로드를 받아야 한다.

```sh
python -m pip -U install pytest
```

참조 : Pytest 공식 문서 [여기를 클릭](https://docs.pytest.org/en/latest/contents.html)

------

## 기본 테스트

Pytest를 실행하기 위해서 테스트용의 .py파일을 준비하고 실행시키기로 하자

```python
# test.py
def test_case_first():
  assert 1
```

우선 예시로 test_case_first라는 테스트 함수를 간단하게 만들었습니다. 함수 생성자는 똑같이 def로 지정해주었지만 반환에서 return 대신 assert를 넣어주었습니다. assert를 넣게 된다면 이 함수는 테스트 함수로 자동으로 인식시켜줘서 함수들 사이에 테스트 함수를 넣어서 테스트해도 테스트는 테스트 함수만 인식하게 됩니다.

그렇다면 이걸 테스트 관련 코드와 테스트 결과는 다음과 같다.

```sh
$ pytest test.py
```

```
=================================================================== test session starts ====================================================================
platform darwin -- Python 3.7.2, pytest-3.8.0, py-1.6.0, pluggy-0.7.1
rootdir: /Users/freezmacbook/Development/workspace/test, inifile:
plugins: remotedata-0.3.0, openfiles-0.3.0, doctestplus-0.1.3, arraydiff-0.2
collected 1 item                                                                                                                                           

test.py .                                                                                                                                            [100%]

================================================================= 1 passed in 0.02 seconds =================================================================
```

assert가 1(True)인 관계로 테스트는 언제나 통과하게 되어있다. 그렇게 간단한 테스트가 가능하다.

------

## 함수 테스트

```python
# test.py
def test_case_first():
    assert 1

def function_add_three(num):
    return num + 3

def test_case_second():
    number_data = 1

    expect = 4 #기대값
    result = function_add_three(number_data) #결과값
    assert expect == result
```

 위의 test_case_first 밑으로 두개의 함수를 추가했다. 하나는 테스트를 위한 함수로 3을 추가해 반환하는 function_add_three와 함수를 테스트하는 test_case_second를 추가했다. 이번엔 직접 함수를 넣어서 테스트를 해보았으며 여기서부턴 두개의 테스트케이스가 있지만 기존의 명령어로 실행할 시에는 단순히 성공했나 안했나만 확인하기 때문에 이번에는 기존 명령어에 *-v*를 넣기로 하겠다.

```sh
$ pytest test.py -v
```

```
=================================================================== test session starts ====================================================================
platform darwin -- Python 3.7.2, pytest-3.8.0, py-1.6.0, pluggy-0.7.1 -- 
.pyenv/versions/anaconda3-5.3.1/bin/python
cachedir: .pytest_cache
inifile:
plugins: remotedata-0.3.0, openfiles-0.3.0, doctestplus-0.1.3, arraydiff-0.2
collected 2 items                                                                                                                                          

test.py::test_case_first PASSED                                                                                                                      [ 50%]
test.py::test_case_second PASSED                                                                                                                     [100%]

================================================================= 2 passed in 0.02 seconds =================================================================
```

이렇게 pytest 명령어에 *-v*를 넣게 된다면 각 테스트케이스마다의 상황을 확인할 수 있게 된다. 이렇게 각 테스트케이스의 상황을 보며 이상있는 부분을 확인할 수 있게 된다. 만약에 테스트에 실패했을 경우에는 어떻게 되는가를 확인해보자. 두번째 테스트케이스의 기대값을 5로 바꿔서 이용해보겠다.

```python
def test_case_second():
    number_data = 1

    expect = 5 #기대값 (4)
    result = function_add_three(number_data) #결과값
    assert expect == result
```

이런 상황에서 테스트할 경우의 결과값은 이렇다.

```
=================================================================== test session starts ====================================================================
platform darwin -- Python 3.7.2, pytest-3.8.0, py-1.6.0, pluggy-0.7.1 -- 
.pyenv/versions/anaconda3-5.3.1/bin/python
cachedir: .pytest_cache
inifile:
plugins: remotedata-0.3.0, openfiles-0.3.0, doctestplus-0.1.3, arraydiff-0.2
collected 2 items                                                                                                                                          

test.py::test_case_first PASSED                                                                                                                      [ 50%]
test.py::test_case_second FAILED                                                                                                                     [100%]

========================================================================= FAILURES =========================================================================
_____________________________________________________________________ test_case_second _____________________________________________________________________

    def test_case_second():
        number_data = 1
    
        expect = 5
        result = function_three_add(number_data)
>       assert expect == result
E       assert 5 == 4

test.py:12: AssertionError
============================================================ 1 failed, 1 passed in 0.06 seconds ============================================================
```

실패했을 경우에는 AssertionError를 일으키며 에러가 나오게 된다. 만약 AssertionError가 발생하게 된다면 위와같이 데이터의 Value가 표시되면서 어느부분이 틀렸는지 확인이 가능하다. 이렇게 데이터를 확인하면서 혹시 함수에 이상이 있는 것인지 확인하면서 테스트를 정리할 수 있다.