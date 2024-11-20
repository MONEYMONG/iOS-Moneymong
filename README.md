<img src = "https://github.com/user-attachments/assets/dc81afb5-6f46-4803-b434-17736d4a9262" width = "100%">

# 머니몽

> 엑셀로 더이상 시간을 낭비하지 마세요.
> 회비 관리는 머니몽에서 스캔 한 번으로 5초면 가능하니깐요!

여러 문제들

- 직접 내역을 타이핑해야 하는 귀찮음
- 장부 가독성 저하
- 회계 장부의 불투명성

을 해결하여 한 눈에 알아보며, 쉽고 편하게 동아리/학생회의 회비를 관리할 수 있는 서비스를 만들고자 합니다


<a href="https://github.com/MONEYMONG/Android-Moneymong/graphs/contributors">
  <img src = "https://github.com/user-attachments/assets/193f656c-d2c7-4f61-bb7b-2f6d43da41d9" width = "250">
</a>

# 프로젝트 정보

### 팀원

|<img src = "https://avatars.githubusercontent.com/u/69573768?v=4" width=200>|<img src = "https://avatars.githubusercontent.com/u/91936941?v=4" width=200>|<img src = "https://avatars.githubusercontent.com/u/88717147?v=4" width=200>|
|:-:|:-:|:-:|
|[김도연](https://github.com/FirstDo)|[이시원](https://github.com/Siwon-L)|[김동욱](https://github.com/malrang-malrang)|

### 사용 라이브러리 & Tool

- FastLane, Github Action: 빌드/ 배포할 때 수행해야 하는 반복작업들을 자동화 하기 위해 사용
- Tuist: 프로젝트 생성, 유지관리, 모듈화를 위해 사용
- ReactorKit(RxSwift): 단방향 플로우를 통한 앱 상태관리를 위해 사용
- Clean Architecture: 확실한 의존성 분리를 통해 유지보수성을 높이기 위해 사용
- PinLayout, FlexLayout: Auto Layout 보다 빠르고 간결하게 Layout을 구성하기 위해 사용

### 프로젝트 구조

<img src = "https://github.com/user-attachments/assets/cf7fe82b-2614-49c8-8c99-94e6db75d656" width = "100%">

# 핵심기능

### 1. 사용한 영수증만 찍으면 돼요
장부는 회비 내역부터 잔액 계산까지 머니몽이 알아서 작성할께요

<img src = "https://github.com/user-attachments/assets/25a8d508-abc3-42fd-94c9-f0ffc0398cae" width = "100%">

### 2. 원하는 장부를 마음껏 만들어봐요
함께 돈을 관리하는 곳이라면 유용하게 쓰일 거라고 확신해요

<img src = "https://github.com/user-attachments/assets/86b00edc-f2f2-41be-b764-25cb58e617ea" width = "100%">

### 3. 초대코드로 간편하게 소속 멤버들과 공유해봐요
같이 사용하며, 회비를 투명하게 관리해요

<img src = "https://github.com/user-attachments/assets/37dfbe0b-5621-4350-9fad-96a0921e93c9" width = "100%">

### 4. 위젯을 통해 핵심 작업에 빠르게 접근해요
영수증 스캔, 회비 내역 확인, 사용한 금액 입력 등을 할 수 있어요!

<img src = "https://github.com/user-attachments/assets/081b5a60-f38d-407d-a310-8d7207962abb" width = "100%">

# 트러블 슈팅

## OCR 기능 개발시, 디바이스 기종의 카메라 개수에 따른 초점 문제

사진촬영을 했을때 기종에 따라서 화면에 초점이 안맞는 문제가 있었다.  
찾아보니 iPhone의 카메라 개수는 기종에 따라서 1~3개로 차이가 나고, 어떤 카메라를 사용할 것인지의 문제였다.  
사용할 카메라가 여러개라면 기본 카메라로 설정하도록 구현해서 해결하였다.  

## Fastlane을 적용할때 원격저장소에서 Xcode signing certificate를 얻어야 하는 문제

처음에는 tuist 문서를 참고해서 tuist signing을 적용해서 원격저장소에서 git action CI/CD 사이클을 돌렸다.  
문제는 추후 개발과정에서 widget이 추가되면서 widget target의 signing역시 해줘야 했는데, 방법을 못찾은건진 모르겠지만 tuist signing으론 해결할 수 없다는 결론을 내렸다.  
fastlane 문서를 참고해서 match방식으로 변경해서 해당 문제를 해결할 수 있었다.

## ReactorKit애서 Swift Concurrency를 지원하지 않았던 문제

이 프로젝트의 network, repository의 함수들은 모두 swift concurrency (async await)을 사용해서 만들어져 있었다.  
그런데 reactorKit이 해당 부분을 지원하지 않아서 reactor에서 사용할 수가 없었다.  
async -> Observable로 바꿔줄 수 있는 extension을 만들어서 해결하였다.
