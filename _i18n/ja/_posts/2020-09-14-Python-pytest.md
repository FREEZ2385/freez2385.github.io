---
title: Pythonテストライブラリー Pytest
date: 2020-09-14 15:30:00 +0900
categories: [Development, Python, Pytest]
tags: [Pytest]
seo:
  date_modified: 2020-09-23 21:43:04 +0900

---



**本ポストはMacOS 10.15.6を基準で作成しました。**

開発する方々に大事なものの一つはテストであります。それぞれの開発言語に合ってるテスト方法があり、今回紹介させていただいたいのはPythonのテストライブラリのPytestであります。僕も最近、Djangoを使いながらテストを探した途中Pytestを知るし、楽にテストすることを分かりました。

まず、Pytestをするためにはライブラリをインストールしなければならない。多分Anacondaを実行するプロジェクトなら基本でインストールされていますけど、基本のPythonでインストールしたらPypiからダウンロードしなければならない。

```sh
python -m pip -U install pytest
```

参照 : Pytest 公式サイトは[こちら](https://docs.pytest.org/en/latest/contents.html)

------

## 基本テスト

Pytestを実行するためにはテスト用の`.py`を用意して実行するこのにしましょう。

```python
# test.py
def test_case_first():
  assert 1
```

例で、`test_case_first`っというテスト関数を簡単に作ってみました。関数の生成者は同じくdefで指定してくれましたが、変換してreturnの代わりにassertを入れてみました。assertを入れるとこの関数は自動でテスト関数で認識せれてくれますので関数の間にテスト関数を入れてテストしてもテストはテスト関すのみ認識されています。

それなら、テスト関連コードのテストの結果は以下となります。

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

assertが1(True)になった関係でテストはいつでもパスすることになっていました。そのように簡単にテストすることができます。

------

## 関数テスト

```python
# test.py
def test_case_first():
    assert 1

def function_add_three(num):
    return num + 3

def test_case_second():
    number_data = 1

    expect = 4 #期待数
    result = function_add_three(number_data) #結果
    assert expect == result
```

上記の`test_case_first`を下に２つの関数を追加してみました。１つはテストのための関数で、3を追加して変換する`function_add_three`と関数をテストする`test_case_second`を追加しました。今度は直接関数を入れてテストをしてみたし、ここからは２つのテストケースがあるけど既存の命令語で実行した時に単純に成功したかどうかだけの確認なので、今回には既存命令語に*-v*を入ってさせてみました。

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

このようにpytest命令語に*-v*を入れてみたら、各テストケースごとの状況を確認することができます。このように各テストケースの状況を見て、異常ありの部分を確認することができます。もし、テストが失敗した場合にはどうなるか確認してみましょう。２つのテストケースの期待数を5に変更してテストしました。

```python
def test_case_second():
    number_data = 1

    expect = 5 #期待数 (4)
    result = function_add_three(number_data) #結果数
    assert expect == result
```

この状態でテストする場合の結果は以下となります。

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

失敗した場合AssertionErrorを起こす、エラーが出ちゃいました。もし、AssertionErrorが発生したら上と同じデータのValueが表示されてどの部分が間違っているか確認が可能であります。このようにデータを確認しながらもし、関数に異常があるかどうかを確認して、テストを整理することができます。