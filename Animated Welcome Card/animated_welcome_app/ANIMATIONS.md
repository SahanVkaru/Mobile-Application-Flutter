# Flutter Animation Explanations

## Fade Animation

Fade animation controls the **opacity** of a widget, transitioning it from invisible (0.0) to fully visible (1.0). In this app, `FadeTransition` is used with an `AnimationController` and a `Tween<double>(begin: 0.0, end: 1.0)` over a 3-second duration. When the app starts, the welcome card gradually appears on screen by increasing its opacity from 0 to 1 using `Curves.easeInOut` for a smooth effect.

## Scale Animation

Scale animation changes the **size** of a widget over time. Here, `ScaleTransition` is used with a `Tween<double>(begin: 0.5, end: 1.0)`, meaning the card starts at half its normal size and grows to full size. It shares the same 3-second `AnimationController` as the fade animation and uses `CurvedAnimation` with `Curves.easeInOut`, so the card smoothly scales up while fading in simultaneously.

## Rotation Animation

Rotation animation **continuously spins** a widget around its center. The Flutter logo uses `RotationTransition` driven by a separate `AnimationController` with a 4-second duration. Calling `_controller.repeat()` makes the logo rotate indefinitely without stopping. The `turns` property maps the controller's value (0.0 to 1.0) to a full 360° rotation, creating a smooth continuous spin effect.
