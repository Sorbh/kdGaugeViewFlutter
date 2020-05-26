
# KdGaugeViewFlutter
KDGaugeView is a simple and customizable gauge control for Android inspired by [KdGaugeView](https://github.com/Sorbh/kdgaugeView)

The source code is **100% Dart**.

![Pub Version](https://img.shields.io/pub/v/box2d?style=flat-square)

![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg?style=flat-square)


# Motivation

I need some clean Guage view for my Flutter application.

# Getting started

## Installing
Add this to your package's pubspec.yaml file:

This library is posted in pub.dev

#### pubspec.yaml
```dart
dependencies:  
	kdgaugeview: ^1.0.0
```

# Usage

After Importing this library, you can directly use this view in your Widget tree

```dart
import  'package:kdgaugeview/kdgaugeviewflutter.dart';
```

```
 GlobalKey<KdGaugeViewState> key = GlobalKey<KdGaugeViewState>();
```

```dart
KdGaugeView(
    key: key,
    minSpeed: 0,
    maxSpeed: 180,
    speed: 70,
    animate: true,
)
```
Update the speed of the Gauge View using this method

```
key.currentState.updateSpeed(120, animate: true,duration: Duration(milliseconds: 400));
```

# Customization
  Depending on your view you may want to tweak the UI. For now you can these custom attributes

  | Property | Type | Description |
  |----------|------|-------------|
  | 'speed' | double | Initial speed for the Gauge |
  | 'speedTextStyle' | TextStyle | Text Style for Speed Text |



# Screenshots
![alt text](https://github.com/sorbh/kdGaugeViewFlutter/blob/master/raw/demo.jpeg)   ![alt text](https://github.com/sorbh/kdGaugeViewFlutter/blob/master/raw/demo.gif)

# Author
  * **Saurabh K Sharma - [GIT](https://github.com/Sorbh)**
  
      I am very new to open source community. All suggestion and improvement are most welcomed. 
  
 
## Contributing

1. Fork it (<https://github.com/sorbh/kdgaugeViewflutter/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

