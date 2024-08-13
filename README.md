# flutter_decorated_container
A Customisable Container widget for the dashed border with rounded corner radius and its background
color.

## Features
- A Container with special decorated options to make the widget more powerful
  - Dashed border around the container with rounded corner radius
  - Customisable strokeColor for the dashed line
  - Both width and gap of the dash can be customised
  - fillColor as background color of the container

## Usage
### With Default values
```dart
DecoratedContainer(
  cornerRadius: 16,
  fillColor: Colors.white,
  strokeColor: Colors.red,
  child: Center(child: Text("sample child widget")),
)
```

### With customised values
```dart
DecoratedContainer(
  strokeWidth: 3,
  dashSpace: 4,
  dashWidth: 6,
  fillColor: Colors.white,
  cornerRadius: 16,
  strokeColor: Colors.red,
  child: Center(child: Text("sample child widget")),
)
```
### Sample UI:
(as per the app module of `/example`)

<img src="https://github.com/user-attachments/assets/a225cc60-d1bf-4323-9c63-acf34e998d89" alt="Screenshot_1723557954" width="400"/>


## Configuration Parameters
| Variable Name  | Default Value  | Purpose                                                                                       |
|----------------|----------------|-----------------------------------------------------------------------------------------------|
| `strokeColor`  | `Colors.grey`  | Specifies the color of the border or stroke around the `Container`.                           |
| `fillColor`    | `Colors.white` | Specifies the color used to fill the inside of the  `Container`.                              |
| `strokeWidth`  | `2.0`          | Defines the thickness of the border or stroke.                                                |
| `dashWidth`    | `5.0`          | Specifies the width of each dash in a dashed border.                                          |
| `dashSpace`    | `3.0`          | Specifies the space between each dash in a dashed border.                                     |
| `cornerRadius` | `null`         | Defines the radius of the corners for rounded shapes. If `null`, the shape has sharp corners. |
| `child`        | `null`         | Defines the child element as a `Widget`.                                                      |
