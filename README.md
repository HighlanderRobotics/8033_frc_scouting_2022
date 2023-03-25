# 8033 FRC Collection App 2023

To build, open folder in VSCode or Android Studio. Make sure to build using dart and flutter dev tools (Use flutter doctor to check status of flutter). 

# ScoutReport Objects


## Charge Station

| Localized Description | Index | Long Localized Description                                                                                                |
|-----------------------|-------|---------------------------------------------------------------------------------------------------------------------------|
| No Climb              | 0     | Did not even attempt to climb                                   |
| Docked                | 1     | The robot is securely attached to the Charge Station and is not touching any other part of the field                 |
| Engaged               | 2     | The robot is securely attached to the Charge Station and is touching another part of the field.                 |
| Failed                | 3     | The robot was attempting to Dock or Engage with the Charge Station but was unsuccessful                      |
| In Community          | 4     | The robot did not attempt to climb, but still was in the community |

## Robot Actions
```dart
0 = Picked up Cube
1 = Picked up Cone
2 = Placed Object
3 = Dropped Object
4 = Delivered to Team
5 = Start Defense
6 = End Defense
7 = Crossed Community Line
8 = Starting Position
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

#### Middle Cargo
```dart
13 |
14 |
15 |
16 |
```

#### Field Starting Positions
```dart
17 = tag id 3
18 = tag id 2
19 = tag id 1
```

## Field Orientation Direction
```dart
0 = left
1 = right
```

## Robot Role
```dart
0 = Offense
1 = Defense
2 = Feeder
3 = Immobile
```

## Driver Ability
### Localized Description to Index to Long Localized Description

| Localized Description | Index | Long Localized Description                                                                                                |
|-----------------------|-------|---------------------------------------------------------------------------------------------------------------------------|
| Terrible              | 0     | This driver cannot control the robot at all. They are a danger to everyone around them.                                   |
| Poor                  | 1     | This driver struggles to keep the robot under control. They make many mistakes and are not very reliable.                 |
| Average               | 2     | This driver can operate the robot competently. However, they are not particularly skilled or exceptional.                 |
| Good                  | 3     | This driver can operate the robot with skill and precision. They are reliable and make few mistakes.                      |
| Great                 | 4     | This driver can operate the robot with mastery. They are highly skilled, precise, and efficient and they can think ahead. |
