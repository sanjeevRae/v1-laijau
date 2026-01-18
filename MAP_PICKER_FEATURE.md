# Map Location Picker Feature Documentation

## Overview
Enhanced the home page with an interactive map location picker that allows users to select their pickup and destination locations by tapping directly on the map.

## New Features

### 1. **Choose on Map Option**
- Located in the expanded search view
- When tapped, prompts user to select whether they're choosing:
  - 🚶 **Pickup location** (green icon)
  - 📍 **Destination location** (red icon)

### 2. **Interactive Map Selection**
When entering map selection mode:
- **Full-screen map view** with semi-transparent header
- **Clear instructions**: "Tap anywhere on the map to pin location"
- **Visual feedback**: Red location pin appears where user taps
- **Pin can be moved**: Simply tap a new location to move the pin
- **Back button**: Cancel selection and return to normal view

### 3. **Location Pin Marker**
- 📍 Large red pin icon with shadow
- Appears instantly when tapping the map
- Easy to see and understand
- Professional appearance

### 4. **Action Buttons**

#### Recenter Button (During Selection)
- **White circular button** with green location icon
- **Position**: Bottom right, above the Done button
- **Function**: Centers map on your current GPS location
- **Feedback**: Shows snackbar message "Centered on your location"
- **Smart logic**: If location unavailable, automatically requests it

#### Done Button
- **Large green button** spanning bottom of screen
- **Text**: "Confirm Location" with checkmark icon
- **Appears only when**: A location has been selected
- **Action**: Saves the selected location to pickup/destination field
- **Returns**: Back to the search view automatically

### 5. **Enhanced Navigation Icon** 
- **Always visible** in normal mode (not during selection)
- **Icon**: My Location (target symbol)
- **Color**: Green with white background
- **Position**: Bottom right, above search panel
- **Smart functionality**:
  - Centers map on your current location
  - Shows confirmation message
  - Automatically fetches location if unavailable
  - Smooth animation when moving map

## User Flow

### Selecting a Location:
1. Tap "Choose on map" option in search panel
2. Select "Pickup" or "Destination"
3. Map enters selection mode with instructions
4. Tap anywhere on map to place the pin
5. Adjust by tapping elsewhere if needed
6. Use recenter button to find your current position
7. Tap "Confirm Location" button
8. Location coordinates are saved to the field
9. Success message appears
10. Returns to search view

### Using Navigation:
1. In normal map view, tap the green navigation button
2. Map smoothly centers on your GPS location
3. Confirmation message appears
4. Zoom level adjusts to 15 for optimal view

## Technical Implementation

### State Management
```dart
bool _isSelectingLocationOnMap = false;  // Selection mode active
LatLng? _selectedMapLocation;            // Currently selected point
String _selectingFor = '';               // 'from' or 'to'
```

### Key Methods
- `_openMapLocationPicker()` - Shows pickup/destination dialog
- `_startMapSelection(String)` - Enters selection mode
- `_confirmMapSelection()` - Saves selected location
- `_cancelMapSelection()` - Exits without saving
- `_centerOnCurrentLocation()` - Smart recentering with feedback

### Map Interaction
- **onTap**: Captures tap position and updates pin location
- **Dynamic markers**: Shows different markers based on mode
- **Conditional UI**: Different overlays for selection vs normal mode

## Visual Design

### Colors
- **Selection header**: Black gradient (70% opacity fading to transparent)
- **Pin color**: Red (#F44336) with shadow
- **Done button**: Green (#689F38) with elevation
- **Navigation button**: Green (#689F38) icon on white
- **Success message**: Green (#689F38) snackbar

### Shadows & Elevation
- Pin has subtle shadow for depth
- Buttons have pronounced shadows for prominence
- Header gradient creates focus on map

### Typography
- **Header title**: 20pt, bold, white
- **Subtitle**: 14pt, regular, white with opacity
- **Button text**: 18pt, bold, white
- **Snackbar**: 16pt, white

## Coordinates Format
Selected locations are displayed as:
```
27.7172, 85.3240
(Latitude, Longitude with 4 decimal precision)
```

## Future Enhancements (Suggested)
- 🔍 Reverse geocoding to show actual address
- 🗺️ Search bar while in selection mode
- 📌 Save favorite locations
- 🎯 Snap to roads/buildings
- 🌐 Multiple map styles (satellite, terrain)
- ↩️ Undo last pin placement
- 📏 Show distance from current location

## User Experience Benefits
✅ Intuitive visual selection
✅ Clear feedback at every step
✅ Easy to correct mistakes
✅ Professional appearance
✅ Smooth animations
✅ Helpful guidance messages
✅ No confusion about which field is being set

## Accessibility
- Large tap targets (60px button height)
- Clear visual hierarchy
- Descriptive labels
- Confirmation messages
- Easy cancellation
