# 8033 FRC Scouting for 2022

## TODO
- Convert to Template app
- Protobuf Serializer
   - Switch from JSON to Custom Schema

To build, open folder in VSCode or Android Studio. Make sure to build using dart and flutter dev tools (Use flutter doctor to check status of flutter). 

# ScoutReport Enum Conversions

## GameScreenPosition
```dart
hub = 0
tarmac = 1
launchpad = 2
fieldEnd = 3
field = 4
```

## EventType

```dart
shotSuccess          = 0
shotMiss             = 1
robotBecomesImmobile = 2
robotBecomesMobile   = 3
```

## CompetitionKey

```dart
chezyChamps2022 ("Chezy Champs 2022")
- Event Code: "2022cc"
```

## Climbing Challenge
```dart
didntClimb  = 0
failedClimb = 1
bottomBar   = 2
middleBar   = 3
highBar     = 4
traversal   = 5
```

## Robot Role
```dart
offense = 0
defense = 1
mix     = 2
```

## Overall Defense and Defense Frequency Rating
```dart
0
1
2
3
4
5
```
NOTE: 0 means there was no defense played (indicated by RobotRole as set to offense)

# Screenshots

#### Game Screen Screenshots (red boxes shown for clarification of the positional data gathered)

<img width="901" alt="image" src="https://user-images.githubusercontent.com/70717139/201489938-9de6d19c-629d-4abf-a06c-9c3018b653df.png">
<img width="888" alt="image" src="https://user-images.githubusercontent.com/70717139/201489940-bd8c7620-f1d5-470a-a196-85ac27dacdb1.png">
<img width="977" alt="image" src="https://user-images.githubusercontent.com/70717139/201489942-8aba9ced-1e46-439d-abb2-141b5fff9e94.png">
