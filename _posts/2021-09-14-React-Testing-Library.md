---
title: React Testing Library 컴포넌트 테스트 사용법
date: 2021-09-14 22:30:00 +0900
categories: [Development, React]
tags: [React, Component, Test]
seo:
  date_modified: 2022-11-22 21:25:26 +0900











---



오랜만에 블로그를 다시 열어보고 작성해보게 되었다. 그동안 React에 대해서도 이것저것 많이 배우면서 동시에 사이드 프로젝트를 준비하면서 서버 구축에 클라우드 서버 시스템인 AWS를 사용해보았다. AWS에 대한 이야기는 나중에 하며 이번에는 React Testing Library에 대해 알아보도록 하겠다. 지금까지 React로 이루어진 테스트는 단위 테스트, Redux Sagas를 이용한 Saga 테스트만 진행을 해보았지만 컴포넌트 자체를 테스트해보는건 처음 보았고 신기했다. 어떻게 사용하는지 알아보도록 하겠다.

참고로 필자는 테스트 툴을 Jest로 바꿔서 Testing Library를 이용해 컴포넌트 테스트를 시도하였다.

-----

## Install

`Create-React-App`  0.3.0 버전 이상으로 프로젝트를 생성하게 되면 Testing Library React이 자동으로 설치되었을 것이다. 하지만, 그 이하의 버전이라면 개별로 설치가 필요할 것이다.  

```
npm install jest
npm install @testing-library/react
npm install @testing-library/jest-dom
npm install @testing-library/user-event
```

필자는 기본 Creact-React-App의 테스트방식을 무시하고 Jest를 직접 설치해 실행해보았다.

jest를 직접 설치했다면 package.json에도 직접 테스트 방식을 jest로 바꾸어보았다.

```json

"scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "jest src/test/",
    "eject": "react-scripts eject"
  }

```



-----

## File Tree

```
/ * -> 새로 생성된 프로젝트에서 변화가 있는 파일 /
src
├── App.css
├── App.js
├── App.test.js
├── component *
│   └── Typography.js *
├── index.css
├── index.js
├── logo.svg
├── reportWebVitals.js
├── setupTests.js
└── test *
    └── component.test.js *
```

React의 프로젝트를 생성하면 기본적인 src폴더에 *인 폴더를 새로 생성하고 결과적으로 나온 파일 트리이다. 우선 컴포넌트 테스트를 위한 샘플 컴포넌트와 그것을 테스트하는 폴더를 생성해 component.test.js로 파일을 생성하였다.

-----

## Sample Code

컴포넌트로 사용할 Typography.js는 말그대로 div 태그안에 텍스트를 집어넣는 용도로 간단하게 만들었다.

```jsx
import React from 'react';
import PropTypes from 'prop-types';

function Typography(props) {
  const { text } = props;
  return <div className="typography">{text}</div>;
}

Typography.PropsTypes = {
  text: PropTypes.string,
};

Typography.DefaultProps = {
  text: '',
};

export default Typography;

```

text라는 파라미터를 통해 컴포넌트 테스트를 할 때 이 text가 잘 들어갈 것인가를 확인해보도록 하겠다.

-----

## Test Code

본격적인 테스트 코드를 작성해보도록 하겠다. 우선 테스트를 하기 위해 `@testing-library/react` 에서 render 함수를 가져와야 한다. 테스트환경에서 테스트 케이스를 랜더링하여 후의 상태를 확인해볼 수 있기 때문이다.

```jsx
import React from 'react';
import { render } from '@testing-library/react';
import Typography from '../component/Typography';

describe('Typography', () => {
  test('renders App component', () => {
    render(<Typography />);
  });
});

```

이렇게 간단하게 랜더링을 테스트를 할 수 있다. 단순히 render만 하는 것이 아닌 그 안의 screen을 불러들어 HTML안의 내용을 확인할 수 있다.

```jsx
import React from 'react';
import { render, screen } from '@testing-library/react';
import Typography from '../component/Typography';

describe('Typography', () => {
  test('renders App component', () => {
    render(<Typography />);
  });

  test('text props debuging', () => {
    render(<Typography text="Hello world!" />);
    screen.debug();
  });
});

```

이 상태에서 jest test를 시도해보면

```
Typography
    ✓ renders App component (17 ms)
    ✓ text props (46 ms)

  console.log
    <body>
      <div>
        <div
          class="typography"
        >
          Hello world!
        </div>
      </div>
    </body>
```

console.log로 랜더링 되어있는 상태를 확인할 수 있다. 이제 여기서 props를 확인할 수 있는 테스트를 해보도록 하겠다.

```jsx
import React from 'react';
import { render, screen } from '@testing-library/react';
import Typography from '../component/Typography';

describe('Typography', () => {
  test('renders App component', () => {
    render(<Typography />);
  });

  test('text props debuging', () => {
    render(<Typography text="Hello world!" />);
    screen.debug();
  });

  test('text props test', () => {
    render(<Typography text="Hello Component!" />);
    expect(screen.getByText('Hello Component!')).toHaveClass('typography');
  });
});

```

세번째로 props에 Hello Component!를 넣은 후 랜더링을 시키고 테스트를 해보았다. screen함수에 `getByText`를 넣으면 랜더링된 HTML에서 'Hello Component!'라는 텍스트를 가진 태그를 집어넣을 수 있다. 그리고 [Sample Code](#sample-code) 와 같이 텍스트가 적힌 div함수는 typograpy라는 클래스명을 가지고 있을 것이다. 이렇게 컴포넌트 테스트를 통해 다양한 테스트를 진행할 수 있다.

그 외에도 다양한 함수에 대한 것은 아래 URL을 참고하기 바란다.

[testing-library-react](https://testing-library.com/docs/react-testing-library/intro/)

[testing-library-jest-dom](https://github.com/testing-library/jest-dom)

혹시 피드백 혹은 모르는 것이 있다면 댓글 부탁드립니다.

