## **데이터프레임 병합**

# Merge
두개의 데이터프레임을 병합 `merge` 를 사용하게 되면 동일한 열 데이터가 존재할 시 해당 열을 기준으로, 동일한 열이 없을 시 인덱스로 병합하는 방식이다. 이 때 기준이 되는 열의 데이터는  ```key```라고 한다.

```python
import pandas as pd

dataframe_a = pd.DataFrame({'a': ['1','2','3','4','5'], 'b': ['5','6','7','8','13']})
dataframe_b = pd.DataFrame({'a': ['1','2','3','4','6'], 'c': ['9','10','11','12','14']})

pd.merge(dataframe_a, dataframe_b, how='inner') # 이때 Key가 되는 열은 a열이 되며, 공통된 a열 데이터를 기준으로 다른 열 데이터들을 배치해 병합 / 이때 inner를 사용시 같은 key값에 한 데이터라도 들어가지 않을 시 그 key값의 데이터는 병합되지 않는다. (how의 Default는 inner라, 지정하지 않아도 상관이 없다.)
```
|| ```a```| b| c|
|---|:---:|:---:|:---:|
| 0| ```1```|  5| 9|
| 1| ```2```|  6| 10|
| 2| ```3```|  7| 11|
| 3| ```4```|  8| 12|
| ~~4~~| ~~```5```~~|  ~~13~~| |
| ~~5~~| ~~```6```~~|  | ~~14~~|

### ```how=outer``` 사용시
```python
pd.merge(dataframe_a, dataframe_b, how='outer') # outer를 사용하게 되면 key값에 모든 데이터가 들어가 있지 않더라도 빈 데이터는 NaN으로 변환해 병합된다.
```
|| ```a```| b| c|
|---|:---:|:---:|:---:|
| 0| ```1```|  5| 9|
| 1| ```2```|  6| 10|
| 2| ```3```|  7| 11|
| 3| ```4```|  8| 12|
| 4| ```5```|  13| NaN|
| 5| ```6```|  NaN| 14|

### ```how=left``` 사용시
```python
pd.merge(dataframe_a, dataframe_b, how='left') # left를 사용하게 되면, 첫번째 인수 데이터를 전부 보여주게 된다. (dataframe_a)
```
|| ```a```| b| c|
|---|:---:|:---:|:---:|
| 0| ```1```|  5| 9|
| 1| ```2```|  6| 10|
| 2| ```3```|  7| 11|
| 3| ```4```|  8| 12|
| 4| ```5```|  13| NaN|

### ```how=right``` 사용시
```python
pd.merge(dataframe_a, dataframe_b, how='right') # right를 사용하게 되면, 두번째 인수 데이터를 전부 보여주게 된다. (dataframe_b)
```
|| ```a```| b| c|
|---|:---:|:---:|:---:|
| 0| ```1```|  5| 9|
| 1| ```2```|  6| 10|
| 2| ```3```|  7| 11|
| 3| ```4```|  8| 12|
| 5| ```6```|  NaN| 14|

---

두 데이터프레임의 공통된 열 데이터가 없을 시 두 데이터프레임을 이어줄 데이터를 지정해야 한다. 이는`left_on, right_on`을 사용하여 공통된 열 데이터를 지정해 병합이 가능하다. 단, 공통된 키데이터가 없을 경우는 `how`의 `inner,outer,left,right`로 적절히 사용해야 한다.

```left_on, right_on``` 미사용시

```python
import pandas as pd

dataframe_a = pd.DataFrame({'a': ['1','2','3','4','5'], 'b': ['5','6','7','8','13']})
dataframe_b = pd.DataFrame({'d': ['1','2','3','4','6'], 'c': ['9','10','11','12','14']})

pd.merge(dataframe_a, dataframe_b) # 해당 상태로 병합시 공통된 키 데이터가 없어 에러가 발생한다.
```
`MergeError:` No common columns to perform merge on. Merge options: left_on=None, right_on=None, left_index=False, right_index=False

### ```(left_on, right_on)``` 동일, ```how='inner'``` 사용시

```python
import pandas as pd

dataframe_a = pd.DataFrame({'a': ['1','2','3','4','5'], 'b': ['5','6','7','8','13']})
dataframe_b = pd.DataFrame({'d': ['1','2','3','4','6'], 'c': ['9','10','11','12','14']})

pd.merge(dataframe_a, dataframe_b, left_on='a', right_on='d')
```
|| ```a```| b| ```d```|c|
|---|:---:|:---:|:---:|:---:|
| 0| ```1```|  5| ```1```|9|
| 1| ```2```|  6| ```2```|10|
| 2| ```3```|  7| ```3```|11|
| 3| ```4```|  8| ```4```|12|

### ```(left_on, right_on)``` 동일, ```how='outer'``` 사용시

```python
import pandas as pd

dataframe_a = pd.DataFrame({'a': ['1','2','3','4','5'], 'b': ['5','6','7','8','13']})
dataframe_b = pd.DataFrame({'d': ['1','2','3','4','6'], 'c': ['9','10','11','12','14']})

pd.merge(dataframe_a, dataframe_b, left_on='a', right_on='d', how='outer')
```
|| ```a```| b| ```d```|c|
|---|:---:|:---:|:---:|:---:|
| 0| ```1```|  5| ```1```|9|
| 1| ```2```|  6| ```2```|10|
| 2| ```3```|  7| ```3```|11|
| 3| ```4```|  8| ```4```|12|
| 4| ```5```|  13| NaN|NaN|
| 5| NaN|  NaN| ```6```|14|

### ```(left_on, right_on)``` 상이, ```how='inner'``` 사용시

```python
import pandas as pd

dataframe_a = pd.DataFrame({'a': ['1','2','3','4','5'], 'b': ['5','6','7','8','13']})
dataframe_b = pd.DataFrame({'d': ['1','2','3','4','6'], 'c': ['9','10','11','12','14']})

pd.merge(dataframe_a, dataframe_b, left_on='b', right_on='c')
```
|| a |```b```|d|```c```|
|---|:---:|:---:|:---:|:---:|

### ```(left_on, right_on)``` 상이, ```how='outer'``` 사용시

```python
import pandas as pd

dataframe_a = pd.DataFrame({'a': ['1','2','3','4','5'], 'b': ['5','6','7','8','13']})
dataframe_b = pd.DataFrame({'d': ['1','2','3','4','6'], 'c': ['9','10','11','12','14']})

pd.merge(dataframe_a, dataframe_b, lefft_on='b', right_on='c', how='outer')
```
|| a| ```b```| d|```c```|
|---|:---:|:---:|:---:|:---:|
| 0| 1|  ```5```| NaN|```NaN```|
| 1| 2|  ```6```| NaN|```NaN```|
| 2| 3|  ```7```| NaN|```NaN```|
| 3| 4|  ```8```| NaN|```NaN```|
| 4| 5|  ```13```| NaN|```NaN```|
| 5| NaN|  ```NaN```| 1|```9```|
| 6| NaN|  ```NaN```| 2|```10```|
| 7| NaN|  ```NaN```| 3|```11```|
| 8| NaN|  ```NaN```| 4|```12```|
| 9| NaN|  ```NaN```| 6|```14```|