---

title: VSCode를 사용하여 Spring Boot API 작성
date: 2022-11-20 17:00:00 +0900
categories: [Development, Java]
tags: [VSCode, Java, SpringBoot]
seo:
  date_modified: 2022-11-20 17:00:00 +0900











---

## 개요

필자가 이직을 하게 되면서 필요한 기술로, Java와 Spring Boot를 요구받게 되었다. 대학교 과제 이후로 Java를 다루어 본 적이 없어 언어를 처음부터 배운다는 생각으로 가지며, 환경 구축부터 시작을 하게 되었다. 여기서 필자는 VSCode 에디터를 다루는 것을 좋아하기에 IntelliJ 혹은 Eclipse와 같은 IDE를 사용하지 않고, VSCode내에서 디버그 및 빌드까지 가능한 환경을 만들고 싶다고 생각했다. 확실히 VSCode는 코드 에디터라는 가면을 쓴 IDE라고 생각할 정도의 확장 프로그램들이 다양해, 기능적으로 엄청 다양하다는 생각을 하게 되었다. 물론 거기에는 Java의 실행 및 Spring Boot API실행까지 포함되어 있어 각 확장 파일만 설치하게 되면 빌드도 가능한 IDE가 될 수 있다.

Spring Boot로 API를 만드는 것이 주 업무이기 때문에, 이번에는 가벼운 API를 작성해보는 것까지 목적을 두기로 했다.



---

## VSCode 확장 프로그램 설치

VSCode에 Java를 도입하기 위해 확장 프로그램을 알아보다 공식 사이트에서 직접 가이드를 개시해주었다는 것을 보았다. 

[JAVA in Visual Studio Code](https://code.visualstudio.com/docs/languages/java)

대중화된 언어와 프레임워크는 Microsoft에서 직접적으로 빌드 지원을 해주기 때문에, Java언어와 Spring Boot과 같은 프레임워크들도 빌드하기 쉽게 가이드를 작성해주었다. Spring Boot 역시 VSCode에 대한 빌드 환경이 잘 되어 있어, 가이드 대로만 하게 되면 쉽게 환경 설정이 가능할 수 있다.

[Spring Boot in Visual Studio Code](https://code.visualstudio.com/docs/java/java-spring-boot)

위 링크와 같이 설치하게 되면, VSCode에 Spring Boot가 가능하기 때문에 바로 Spring Boot API를 작성하기로 하겠다.

---

## Spring Boot 프로젝트 작성

VSCode의 Spring Boot 확장 프로그램이 깔려있다면 프로젝트 작성도 VSCode에서 가능하다. 
`Ctrl + Shift + P`를 입력하는 확장 프로그램 명령어에서 `Spring Initializr : Create a Gradle Project`를 실행하면 Spring 프로젝트의 Gradle판으로 작성이 가능하다. 

![image1](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_1.png)

실행하게 되면 다양한 자바와 Spring 버전 설정과 동시에 Dependency를 지정할 수 있다.

![image2](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_2.png)

> Spring Boot Version

![image3](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_3.png)

> 프로젝트 언어

![image4](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_4.png)

> 그룹 ID(패키지)

![image5](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_5.png)

> 아티펙트 ID(폴더)

![image6](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_6.png)

> 패키징 타입

![image7](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_7.png)

> Java 버전 설정



API 작성을 위해서 이하의 Dependency를 지정하겠다. 이번 Dependency설정은 DB관련 없이 순수 API만을 움직이기 위한 구성으로 이루어 보았다.

![image8](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_8.png)

- Spring Boot Devtools
- Lombok(편의성을 위해)
- Spring Web

그렇게 지정하게 되면 패키지명과 동시에 프로젝트 작성이 자동으로 진행이 된다.

---

## RestController를 통한 API URL 생성

프로젝트 작성이 완료되었다면 패키지 안의 파일을 작성함으로서 URL작성과 동시에 API를 작성할 수 있다. 필자는 간단하게 같은 폴더에 `rest.java`를 작성하여 클래스를 생성해보았다.

```java
package com.example.demo; // 패키지에 따라 다르기 때문에 변경해주어야 한다.

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class rest {

    @GetMapping(value = "/info") // URL 설정
    public String getString() {
        return "test";
    }

}
```

필요한 코드는 이와 같이 작성하여 URL을 GET하게 되면 "test"라는 문자열을 response하도록 해보았다. 

클래스에 `@RestController`를 씀으로써 컨트롤러를 Override시킬 수 있고, 내부 함수에 `@GetMapping`을 통해 GET 메소드를 작성할 수 있다. 추가로 GET URL을 생성함으로서 response값을 URL을 통해 생성이 가능하다.

이렇게 완료한 다음 VSCode의 run을 통해 실행한 결과 

![image9](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_9.png)

터미널의 서버가 생성되면서 포트를 지정하지 않았다면 https://localhost:8080 으로 가능할 것이다. API 파일을 작성했다면, Getmapping의 url에서만 통하게 되며 들어가게 될 시에는 이와같은 response값을 받을 수 있다.

![image10](https://s3.ap-northeast-1.amazonaws.com/freez2385.blog/img/2022-11-20-Spring-Boot/springboot_10.png)



---

## TroubleShooting

실제로 run을 실행하게 되면 에러가 생기는 것을 볼 수있다. 이것은 VSCode내에서 Java를 실행했다면 해당 프로젝트 내 Java Language 서버가 자동으로 실행이 되며, 다른 프로젝트를 진행되었을때의 설정과 맞지 않아 일어나는 에러이다.

이럴 때는 `Ctrl + Shift + P`의 명령어의 `Java:Clean Java Language Server Workspace`을 한번 진행하여 서버를 한번 초기화시켜주면 된다. 

물론 이것이 정확한 해답은 아니지만, 지금까지의 문제는 이것으로 다 해결을 보았다.

---

이렇게 직접 API를 작성하게 되면서 Spring Boot에 관련하여 이것저것 만져볼 수 있는 기회가 된 것 같다. 이렇게 API를 배워가며 Java Spring Boot를 익혀볼 수 있게 되어 좋았던 것 같다. 불명한 점과 질문 사항은 밑의 댓글로 작성해주시기 바란다.







