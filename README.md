# Today's Me - 오늘의 나
> 일정, 할일 ,일기 등을 간편하게 관리할 수 있는 앱입니다.
> 플러터 Provider 상태관리 방식과 SQLite 데이터베이스를 사용하였습니다.

<br><br>

## 주요 기능
 - 홈 페이지
    - Tab 기능을 이용해서 오늘 날짜에 해당하는 일정, 할일, 일기 화면 구현
- 일정, 할일, 일기 페이지
    - 캘린더 화면에서 날짜를 클릭하거나 범위를 선택하여 해당 기간 동안의 데이터를 리스트 형태로 구현
    - 추가 기능 모달 창 구현
    - 편집 및 삭제 기능

<br><br>


## 화면
![image.jpg1](https://user-images.githubusercontent.com/71866185/167249241-5021a46a-d06f-4f55-a648-1981ba35a03a.png) |![image.jpg2](https://user-images.githubusercontent.com/71866185/167249242-3f0af430-bbb2-4166-acc4-7af98aa66464.png) |![image.jpg2](https://user-images.githubusercontent.com/71866185/167249244-7cf221a1-a64f-489a-baeb-5f85c5c1a0cc.png) |![image.jpg2](https://user-images.githubusercontent.com/71866185/167249245-06c90be6-5d05-4444-8264-1dfcf5e1ce41.png)
--- | --- | --- | --- | 

<br><br>

## 기술적 구현 사항

### LinkedHashMap을 이용하여 날짜별 일정을 분리하여 보여주는 기능 구현

- **TableCalendar** widget에 Custom events를 적용하려면 eventLoader를 사용한다.
  
``` Dart
eventLoader: (day) {
  return _getEventsForDay(day);
},

List<Event> _getEventsForDay(DateTime day) {
  return events[day] ?? [];
}
```
  
- DB에 저장된 List<Schedule> 데이터를 **LinkedHashMap<DateTime, List<Schedule>>** 형식으로 만듬

``` Dart
//  {2024-05-03 00:00:00.000: [apple, banana, orange], 2024-05-04 00:00:00.000: [car, bus, train]}
//  다음과 같은 형태로 데이터를 만듬

final events = LinkedHashMap<DateTime, List<Schedule>>(
  equals: isSameDay,
  hashCode: DataUtils.getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
```
<br>

### DefaultTabController Widget과 Provider를 이용해 탭 기능 구현

- TabBar 사용해 탭 목록 구현 및 TabBarView 사용하여 각 탭에 해당하는 위젯을 표시

``` Dart
DefaultTabController(
 child: Column(
  children:[
   TabBar(
    tabs:[
     Tab(text: "Schedule"),
     Tab(text: "Todo"),
     Tab(text: "Diary"),
    ],
    onTap: (index){
     provider.changeIndex(index);
    },
  ),
   TabBarView(
    children:[
     ScheduleView(),
     TodoView(),
     DiaryView(),
    ],
   ),
  ],
 ),
),
```



