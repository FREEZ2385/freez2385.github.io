---
title: Material-UI에 대해서 알아보고 실제로 컴포넌트를 이용하기
date: 2020-10-10 23:10:00 +0900
categories: [Development, React]
tags: [React, Component, MaterialUI]
seo:
  date_modified: 2020-10-10 23:15:13 +0900







---

**본 포스트는 MacOS 10.15.7 을 기준으로 작성하였습니다.**

필자는 React를 사용하면서 UI에 대한 프레임워크로는 Material-UI라는 프레임워크를 사용하고 있다. 상당히 깔끔한 디자인에다 편집하기 쉬운 컴포넌트들로 구성되어 있으며, CSS도 어렵지 않게 수정할 수 있다는 것이 매력적이였다. 사실상 컴포넌트들로 세팅할 수 있어서 단지 불러오기만 하면 알아서 구성할 수 있고 템플릿 작업 시간도 덜 수 있어서 좋다.

지금은 프론트, 백엔드 웹 개발을 하고 있어서 프론트에 대한 부담과 디자인에 대한 부담을 동시에 줄일 수 있다는 것이 좋아서 Material-UI를 자주 사용하고 있다.  거기에 Material-UI 페이지 안에서 샘플로 템플릿이 있어 좋은 레퍼런스가 될 수도 있다.

그렇다면 실제로 Material-UI를 작성하는 방법에 대해 작성해보도록 하겠다. 이전에 필자가 작성해놓은 간단한 템플릿을 만들어 Github에 올려둔 것이 있다. 참고하면서 해보는 것도 좋을 것 같다.

### Material-UI example repository (Freez Github) : [react-material-ui-project](https://github.com/FREEZ2385/react-material-ui-project)

### Material-UI 홈페이지 : [Material-UI](https://material-ui.com/)

-----

## Material UI 설치

아마 React를 다루고 있는 사람들이라면 npm, yarn 등도 알고 있을 것이라 생각되어 기본적인 설치법부터 시작해보겠다. 프로젝트를 작성했다면 프로그램의 package.json 파일 내부에 해당 명령어를 작성하도록 하자.

Material-UI의 컴포넌트 전용 패키지 설치

```
npm install @material-ui/core 

yarn add @material-ui/core
```

Material-UI의 SVG Icon 패키지 설치

```
npm install @material-ui/icons

yarn add @material-ui/icons
```

`@matrial-ui/core` 는 Material-UI에서 작성되는 컴포넌트들의 패키지를 설치할 수 있으며 기본적인 컴포넌트는 다 core에서 작성될 수 있다고 볼 수 있다. `@material-ui/icons` 는 Material-UI에서의 아이콘들을 사용할 수 있게 해주는 패키지이다. 해당 아이콘에 대한 내용은 다음 URL을 통해 확인이 가능하며, 즉시 컴포넌트로 사용이 가능하다.

[Material-UI Material Icons](https://material-ui.com/components/material-icons/)

[Material-UI Icons](https://material-ui.com/components/icons/)

설치가 완료되었다면 간단한 버튼을 제작해보도록 하겠다.

-----

## Material UI을 이용한 템플릿 작성

패키지 설치를 하고 난 이후에는 간단히 제작이 가능하다. 필자는 일일이 템플릿 하나에다 직접 작성하는 것보다 하나의 컴포넌트를 지정해 해당 컴포넌트 안에서 스타일을 바꾸는 것을 선호한다. 원래 작성에는 scss, js 파일을 나누어 스타일과 코드를 나누는 편을 좋아하지만 js안에서 모두 처리하도록 하겠다.

예시로 Github에 사용된 레포지터리의 ButtonComponent.js의 코드를 가져와보았다.

```javascript
import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import { Button } from '@material-ui/core';

const buttonStyle = makeStyles((theme) => ({
    large: {
      width: 256,
      marginRight: 20,
    },
    middle: {
      width: 164,
      marginRight: 20,
    },
    small: {
      width: 75,
      marginRight: 20,
    },
  }));

export default function ButtonComponent(props) {
    const { text, size, onClick } = props;
    const sizeStyle = buttonStyle();

    return (
        <Button variant="contained" color="Secondary" className={sizeStyle[size]} onClick={onClick}>
        {text}
        </Button>
        );
}

```

Material-UI의 기본적인 컴포넌트를 import시켜와 로컬로 컴포넌트 작업을 시켰다. 필자는 그대로의 버튼을 작성하는 것도 괜찮은 방법이지만, 규칙이나 이런 것들을 생각해 컴포넌트로 작성하였다. text, size, onClick의 props를 받아오면 각자 자기위치에서 사용할 수 있도록 작성해보았다. 그렇다면 실제로 보기 위해 App.js에 넣어보도록 하겠다. App.js는 단순한 예시로 작성되었기 때문에 Github의 레포지터리에는 표시되지 않는다.

```javascript
import { Container } from '@material-ui/core';
import React from 'react';
import './App.css';
import ButtonComponent from './component/Atoms/ButtonComponent';

function App() {
  return (
    <div className="App">
      <div className="button-area">
        <ButtonComponent text="Large-Button" onClick="" size="large"/>
        <ButtonComponent text="Middle-Button" onClick="" size="middle"/>
        <ButtonComponent text="Small-Button" onClick="" size="small"/>
      </div>
    </div>
  );
}

export default App;

```

간단하게 App.js를 이런 식으로 구성해보았다. 이렇게 작성을 했다면 다음과 같은 화면으로 나올 것이다.

![Material-UI1](../../assets/img/2020_10_10_react_materal_ui/materal_ui1.png)

이렇게 버튼 구상을 하여 정해진 규격의 버튼을 받아올 수 있으며, 여기서 받은 버튼은 일괄 수정이 가능한 컴포넌트가 되어있다. 이렇게 간편하게 Material UI의 디자인으로 작성해서 프론트엔드의 디자인 기획과 구현의 부담이 조금은 덜해질 수 있어서 편하다는 생각이 많이 든다.

그 외에도 다른 Material-UI의 컴포넌트들을 응용해 생성해본 Github 레포지터리에서 확인할 수 있다. 이것도 급하게 제작된 것이라 서투른 것일 수 있으므로 피드백은 언제나 환영이다.

### Material-UI example repository (Freez Github) : [react-material-ui-project](https://github.com/FREEZ2385/react-material-ui-project)