# - Record App
### - 2017.03.27 ~ 2017.04.21
**- FastCampus Project(IOS & AOS & Frontend & Backend)**

## - Play Record
영상

## - Record Intention of the plan (기획 의도)
**- 여행 중의 행복했던 기억과 특별한 순간들은 새로운 순간들을 만나며 잊혀져 간다. 결국 남은 것은 정리 안된 사진들과 희미해진 여행의 기억... 내가 여행한 곳을 기록하고 정리하고 싶지만 생각만큼 쉽지가 않다. 사진을 통해 쉽고 간편하게 나만의 여행 다이어리를 만들 수 있도록 이 앱을 기획했다.** 

## - Record App Features  

- 개인 e-mail 또는 facebook계정, google계정을  회원가입 및 로그인을 하여 개인 App 계정을 가질 수 있다.
- 언제 어디서나 여행 사진들을 등록할 수 있고, 글을 등록할 수 있다.
- 등록한 사진들과 글을 통해 위치정보를 얻어 나만의 여행 지도를 만들 수 있다.
- 등록된 글과 사진들을 모아 여행 다이어리를 만들어 준다.
 
## - Key Features and Implementation Methods

|Key Features|Implementation Methods|
|:--|:--|
|Account Enrollment| 개인 e-mail 또는 facebook, google계정을 통해 가입을 하여야 서비스 이용이 가능하다.|
|Create Posts| 글과 사진들을 등록 |
|Create Diary| 등록된 posts를 모아 다이어리 형태로 보여 준다.|
|Data Storage| 데이터 통신을 통해 서버에 저장. 데이터 통신이 불가능할 경우를 대비하여 Realm을 통한 local DB에 저장이 된다.|



## - Record App Menu Configuration And App Scenario

![Senario]()

## - App Requirements

- iOS 0.0 or later
- Xcode 0.0 or later

## - Programming Language

- Objective - C

## - Use Library
|라이브러리명|기능|
|:--:|:--:|
|AFNetworking|네트워크 통신을 위한 라이브러리|
|SDWebImage/GIF|웹 이미지 다운로드 및 GIF를 사용하기 위한 라이브러리|
|GoogleMaps|Google 지도 사용을 위한 라이브러리|
|GooglePlaces|Google 장소 검색 사용을 위한 라이브러리|
|GooglePlacePicker|Google 장소 검색 사용을 위한 라이브러리|
|GoogleSignIn|Google 회원가입을 사용하기 위한 라이브러리|
|FBSDKCoreKit|Facebook API를 사용하기 위한 라이브러리|
|FBSDKLoginKit|Facebook 회원가입을 사용하기 위한 라이브러리|
|KeychainItemWrapper|중요 키값을 암호화하기 위한 라이브러리|
|QBImagePickerController|Custom Image Picker를 사용하기 위한 라이브러리|
|VCTransitionsLibrary|Flip Animation을 사용하기 위한 라이브러리|

## - Team members

|분야|이름|이메일|
|:--:|:--:|:--:|
|iOS|조봉기|https://github.com/whalebab|
|iOS|김윤서|https://github.com/KimYunseo|