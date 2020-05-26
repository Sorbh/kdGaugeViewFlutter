# KdGaugeViewFlutter

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
    alertSpeedArray: [40, 80, 100],
    alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
)
```
Update the speed of the Gauge View using this method

```
key.currentState.updateSpeed(120, animate: true,duration: Duration(milliseconds: 400));
```