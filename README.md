# flutter_life_devo_app_v2

## Bundle name  
com.taehoon.lifeDevoApp

## 유용한 커맨드들  
```
flutter pub upgrade

flutter clean
flutter pub get
cd ios
pod install  
```

## Sample UI from Rachel  
https://www.figma.com/file/XgCeo7uB3zDXN0Cx2EmLlH/Bridgeway-Life-Devo?node-id=35%3A1
## UI 의 기본은 다음을 참조:  
https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI  
https://github.com/hossin529/flutter-article-ui-Tutorial-1  

## UI: App bar 에 탭이 붙는 디자인:  
https://blog.logrocket.com/flutter-tabbar-a-complete-tutorial-with-examples/  

## Date time picker  
https://stackoverflow.com/questions/53749248/flutter-datepicker-without-day  
https://stackoverflow.com/questions/63724025/flutter-create-dropdown-month-year-selector  



## TODO:  
- Login 성공 웹페이지 만들고 여기에 적용. 
- 라이프 디보 시작한김에 세번째 탭 (라이프디보) 마저 하기  

# 2022.03.03 ~ 2022.03.04    
- [X] Live life devo, Discipline topic, Discipline, Sermon Model 만들기  
- [X] admin repo 에 각 데이터에 대한 CRUD 구현  
- [X] Live life devo, sermon 의 Latest 가져노는거 구현  
- [X] 각 컨텐츠의 디테일 페이지 구현 (단순히 컨텐츠만 보여주는 페이지라서 컨트롤러와 바인딩은 하지 않는다.)  
- [X] 두번째 탭에 대한 컨트롤러 만들기  
- [X] 두번째 탭 페이지 꾸미기. Live life devo, Discipline, Sermon 버튼들 크게 만들기  
- [ ] Sermon, Live life devo 버튼을 누르면 리스트가 죽 나오게하기 (가능하면 pagination?)  
- [ ] Discipline 은 전체 리스트전에 Topic 리스트 먼저 (pagination 없이)  
- [ ] 각 토픽을 누르면 그제서야 해당 토픽의 전체 리스트 불러오기 (pagination 없이)  
- [ ] Svelte dashboard project 에 Pagination 구현 (https://svelte.dev/repl/4863a658f3584b81bbe3d9f54eb67899?version=3.32.3)   

# 2022.02.19  
- Friend search, request 구현까지만 (Back & Front)  

# 2022.01.19  
- Life devo 탭에서 Month calendar 에 selectedDate 를 controller 로 옮기기. (다른 페이지 갔다가 돌아와도 유지 되게끔)  
- Life devo 의 My, shared 상단탭에도 캘린더 적용  
- 그 후에 API 작업 (Pagination 적용할 필요 없이 다 불러오기. 물론 month 별로)   

## Load controller and repo  
상황에 따라 어떤 controller 와 repo 는 main 에서 declare  
해주도록 한다.  (global 이랄지...)

## Youtube Thumbnail address  
https://img.youtube.com/vi/tOud_J9ScBM/hqdefault.jpg  


