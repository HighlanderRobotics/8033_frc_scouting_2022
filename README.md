# 8033 FRC Collection App 2023

To build, open folder in VSCode or Android Studio. Make sure to build using dart and flutter dev tools (Use flutter doctor to check status of flutter). 

# ScoutReport Objects

## Climbing Result
```dart
0 = No Climb
1 = Supported
2 = Charged
3 = Failed
4 = In Community
```

## Robot Actions
```dart
0 = Picked up Cube
1 = Picked up Cone
3 = Placed Object
4 = Dropped Object (On Accident)
5 = Delivered to Team
6 = Blocked
7 = Pinned
8 = Crossed (to/from) Community
```

## Positions
```dart
7, 8, 9
4, 5, 6
1, 2, 3
```

#### Auto-Specific Positions
```dart
10 = Crossed Cable
11 = Crossed Charge Pad
12 = Crossed Near Barrier
```

## Robot Role
```dart
0 = Offense
1 = Defense
2 = Mixed
3 = Feeder
```
