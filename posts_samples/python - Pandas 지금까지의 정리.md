# python - Pandas 지금까지의 정리

## Pandas Series 기본 (생성 및 이용)

## **시리즈 생성**

시리즈를 생성할 시에는 List를 넣을 수 있으며, List별로 인덱스를 부여해 시리즈를 생성하게 된다.

```python
import pandas as pd

data = ['1','2','3','4']

obj = pd.Series(data)
```

|     |     |
| --- | :-: |
| 0   |  1  |
| 1   |  2  |
| 2   |  3  |
| 3   |  4  |

### 인덱스를 직접 지정해 시리즈 생성

```python
import pandas as pd

data ={
  'a':[1,2],
  'b':[3,4],
  'c':[5]
  }

obj = pd.Series(data)
# ------------------- 동일 값 ---------------
data = [[1,2], [3,4], [5]]

obj = pd.Series(data, index=['a','b','c'])
```

|     |       |
| --- | :---: |
| a   | [1,2] |
| b   | [3,4] |
| c   |  [5]  |

## 시리즈의 접근