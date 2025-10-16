# MZFlood

A nicer, smoother implementation of the [Flood Fill puzzle game from Simon Tatham's Portable Puzzle Collection](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/flood.html).

Powered by [Flutter](https://flutter.dev).

## Features

- Smooth UI and visuals
- **Grid size** and **palette size** customization — non-square rectangular grids are also supported
- **Flood-fill point position** customization: any corner, any side, the very center, or even random if you like
- Hiding the color panel (you can tap the cells on the grid itself to flood-fill)
- Optional slow **flood-fill effect** (can be tweaked or even disabled if you prefer good old instant flood-fill)
- **Monochrome more** support (grayscale and tint color)
- Color palette's saturation, brightness, and contrast customization
- **Color Accessability Mode** support (mark cells with numbers)

## For developers

### Generate Localizations

```bash
flutter gen-l10n
```

### Generate Splash Screen

```bash
dart run flutter_native_splash:create
```

### Update launcher icons

```bash
dart run flutter_launcher_icons
```
