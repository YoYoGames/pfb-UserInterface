# UI Prefabs Library

A comprehensive collection of reusable UI components for GameMaker projects.

# Contents

[Available Components](#Available-Components)
* [Button](#Button)
* [Checkbox](#Checkbox)
* [Dropdown](#Dropdown)
* [Infobox](#Infobox)
* [ProgressBar](#ProgressBar)
* [ScrollBar](#ScrollBar)
* [Slider](#Slider)
* [Spinner](#Spinner)
* [Textbox](#Textbox)
* [Toggle](#Toggle)
* [oSlot](#oSlot)

[Common Features](#Common-Features)
* [Localisation Support](#Localisation-Support)
* [Clickthrough Prevention](#Clickthrough-Prevention)
* [Scaling Sprites](#Scaling-Sprites)

[UI Layers](#UI-Layers)
* [Main Menu](#Main-Menu)
* [Pause](#Pause)
* [Options](#Options)
* [Character](#Character)
* [Confirmation](#Confirmation)
* [Game Over](#Game-Over)

[UI Manager Object](#UI-Manager-Object)\
[Layer Management Functions](#Layer-Management-Functions)\
[Integration Tips](#Integration-Tips)

## Available Components

### Button
**Purpose:** A clickable button with visual feedback and callback support.

**Key Properties:**
- `text` / `localisation_string` - Button text (inherited from oLocalised)
- `Icon` - Use a sprite icon instead of text
- `Icon_Scale` - Size of the icon (default: 1)
- `Font` - Font for button text (default: fUI)
- `Text_Size` - Font size in pixels (default: 10)
- `Colour` - Text/icon color
- `Sound` - Audio to play when button is released
- `Button_Release` - Function to execute on click
- `Press_Scale` - Scale when pressed (default: 0.9)
- `Hover_Scale` - Scale when hovered (default: 1.01)

**Usage:**
```gml
// Set button text
button.text = "Click Me";

// Or use localisation
button.localisation_string = "button_confirm";

// Assign callback function
button.Button_Release = function() {
    show_debug_message("Button clicked!");
    // Your code here
};
```

---

### CheckBox
**Purpose:** A simple on/off toggle control with a checkmark indicator.

**Key Properties:**
- `text` / `localisation_string` - Label text
- `Checked` - Current state (true/false, default: false)
- `check_sprite` - Checkmark icon sprite (default: Icon_Tick)
- `check_colour` - Checkmark color (default: black)
- `check_scale` - Scale of checkmark (default: 0.25, range: 0.1-5)

**Usage:**
```gml
// Check the current state
if (checkbox.Checked) {
    show_debug_message("Checkbox is checked");
}

// Set the state programmatically
checkbox.Checked = true;
```

---

### DropDown
**Purpose:** A selection list that expands/collapses with scrolling support for long lists.

**Key Properties:**
- `text` / `localisation_string` - Default text when nothing selected
- `shown_items` - Number of visible items before scrolling (default: 4)
- `font` - Font for items (default: fUI)
- `text_size` - Font size (default: 16)
- `dropdown_bg` - Menu background sprite
- `item_colour` - Unselected item text color
- `selected_colour` - Selected item text color
- `show_icon` - Show arrow icon (default: true)
- `icon_open` - Arrow icon sprite
- `icon_colour` - Icon color
- `dropdown_direction` - "Up" or "Down" (auto-detected based on screen position)

**Key Methods:**
- `FillList(array)` - Populate the dropdown with items
- `Scroll(amount)` - Scroll the list by percentage

**Usage:**
```gml
// Create item list
var items = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"];
dropdown.FillList(items);

// Check selected item
if (dropdown.selected != undefined) {
    var selected_text = dropdown.items[dropdown.selected];
    show_debug_message("Selected: " + selected_text);
}
```

---

### Infobox
**Purpose:** A tooltip/information popup that appears on hover and auto-positions within window bounds.

**Key Properties:**
- `text` / `localisation_string` - Tooltip text
- `infobox_sprite` - Background sprite (default: TextBox_Scalable)
- `infobox_colour` - Sprite color
- `font` - Text font (default: fUI)
- `text_size` - Font size (default: 16)
- `text_colour` - Text color (default: black)
- `horizontal_padding` - Left/right padding (default: 16)
- `vertical_padding` - Top/bottom padding (default: 8)
- `horizontal_align` - fa_left, fa_center, or fa_right
- `vertical_align` - fa_top, fa_middle, or fa_bottom

**Usage:**
```gml
// Set tooltip text
infobox.text = "This is a helpful tooltip!";

// Or use localisation
infobox.localisation_string = "tooltip_help";

// The infobox automatically shows on mouse hover
```

---

### ProgressBar
**Purpose:** Visual progress indicator showing completion percentage.

**Key Properties:**
- `background_sprite_colour` - Background color
- `progress_bar_sprite` - Foreground sprite (default: Button_Scalable)
- `progress_bar_sprite_colour` - Foreground color (default: green)
- `max_value` - Maximum value (default: 100)

**Key Methods:**
- `getMaxValue()` - Get progress bar's maximum value
- `setMaxValue(value)` - Set progress bar's maximum value
- `getCurrentValue()` - Get current progress
- `setCurrentValue(value)` - Set current progress (clamped 0-max)

**Usage:**
```gml
// Set progress bar's max value
progressbar.setMaxValue(100);

// Read current progress
var progress = progressbar.getCurrentValue();

// Update progress
progressbar.setCurrentValue(progress + 1);
```

---

### ScrollBar
**Purpose:** A scrollable track control for managing viewport scrolling.

**Key Properties:**
- `percentage` - Scroll position (0-1, default: 0)
- `bar_sprite` - Background track sprite (default: ScrollBarBack_Scalable)
- `thumb_sprite` - Draggable handle sprite (default: ScrollBarFront_Scalable)
- `step_size` - Scroll amount per wheel (default: 0.1, range: 0-1)
- `bar_colour` - Track color (default: gray)
- `thumb_colour` - Handle color (default: white)

**Key Methods:**
- `Scroll(amount)` - Change percentage by amount
- `SetPosition(position)` - Set percentage from mouse position

**Usage:**
```gml
// Read scroll position
var scroll_pos = scrollbar.percentage; // 0.0 to 1.0

// Use scroll position to offset content
var content_offset = scroll_pos * max_scroll_height;

// Orientation is auto-detected:
// - Wider than tall = horizontal
// - Taller than wide = vertical
```

---

### Slider
**Purpose:** A continuous value control with a draggable handle.

**Key Properties:**
- `min_value` - Minimum value (default: 0)
- `max_value` - Maximum value (default: 10)
- `current_value` - Current slider value (default: 5)
- `num_steps` - Divide range into N discrete steps
- `step_size` - Snap increment (default: 1)
- `handle_sprite` - Handle/thumb sprite (default: SliderHandleCircle)
- `handle_sprite_colour` - Handle color
- `handle_rotate` - Rotate handle with slider angle (default: true)
- `handle_sprite_scale` - Handle size (default: 1)
- `padding` - Pixel inset from slider ends (default: 18)
- `slider_bar_colour` - Bar color

**Key Methods:**
- `getValue()` - Get current value
- `setValue(value)` - Set current value
- `getMinValue()` / `setMinValue(value)` - Get/set minimum
- `getMaxValue()` / `setMaxValue(value)` - Get/set maximum

**Usage:**
```gml
// Configure slider range
slider.setMinValue(0);
slider.setMaxValue(100);
slider.setValue(50);

// Create stepped slider (e.g., 5 discrete positions)
slider.num_steps = 5;

// Read value
var volume = slider.getValue();
audio_master_gain(volume / 100);
```

---

### Spinner
**Purpose:** An animated loading/processing indicator.

**Key Properties:**
- `spinning` - Is animation playing (default: true)
- `animation_speed` - Playback speed multiplier (default: 1, range: 0.1-2)
- `animation_sequence` - Animation sequence (default: qSpinner)
- `animation_sprite` - Sprite in animation (default: SliderHandleCircle)

**Usage:**
```gml
// Start/stop animation
spinner.spinning = true;

// Adjust animation speed
spinner.animation_speed = 1.5;

// Hide when loading complete
spinner.visible = false;
```

---

### Textbox
**Purpose:** An editable text input field with validation, wrapping, and scrolling.

**Key Properties:**
- `text` / `localisation_string` - Initial/current text
- `font` - Text font (default: fUI)
- `text_size` - Font size (default: 16)
- `text_colour` - Text color (default: black)
- `vertical_padding` - Top/bottom padding (default: 6)
- `horizontal_padding` - Left/right padding (default: 10)
- `vertical_align` - fa_top, fa_middle, or fa_bottom
- `horizontal_align` - fa_left, fa_center, or fa_right
- `highlight_colour` - Color when focused
- `caret_visible` - Show text cursor (default: true)
- `overflow_behaviour` - "scroll" (horizontal) or "wrap" (multiline, default)
- `expected_input` - "all", "int", or "real" (input validation)
- `editable` - Allow user to edit (default: true)

**Key Methods:**
- `updateText(text, isLocalised)` - Update displayed text

**Usage:**
```gml
// Read user input
var player_name = textbox.text;

// Make textbox read-only
textbox.editable = false;

// Restrict to numbers only
textbox.expected_input = "int";

// Update text programmatically
textbox.updateText("New text here", false);
```

---

### Toggle
**Purpose:** An animated on/off switch with customizable colors.

**Key Properties:**
- `text` / `localisation_string` - Label text
- `Checked` - Current state (true/false, default: false)
- `check_sprite` - Moving dot/button sprite (default: ToggleButton)
- `check_scale` - Dot scale (default: 1)
- `check_bg` - Background sprite (default: ToggleBack)
- `frame` - Frame/border sprite (default: ToggleFront)
- `colour_area` - Apply color to: "Background", "Dot", or "Both"
- `background_checked_colour` - Background color when on (default: green)
- `background_unchecked_colour` - Background color when off (default: white)
- `dot_checked_colour` - Dot color when on (default: white)
- `dot_unchecked_colour` - Dot color when off (default: gray)

**Usage:**
```gml
// Check toggle state
if (toggle.Checked) {
    window_set_fullscreen(true);
} else {
    window_set_fullscreen(false);
}

// Set state programmatically
toggle.Checked = true;
```

---

### oSlot
**Purpose:** A base container object for slot-based UI systems (e.g., inventory slots).

**Usage:**
```gml
// This is a minimal base object
// Extend it with your own logic for inventory, equipment, etc.
// Currently has no built-in properties or methods
```

---

## Common Features

### Localisation Support
All text-based components inherit from `oLocalised` and support localisation:

```gml
// Use localisation_string instead of text
button.localisation_string = "button_confirm";

// Override language for specific instance
button.localisation_lang_override = "French";
```

### Clickthrough Prevention
All components inherit from `oUIParent` with `prevent_clickthrough` property to stop clicks from passing through UI elements.

### Scaling Sprites
Many components use 9-slice scalable sprites (ending with `_Scalable`) that resize cleanly without distortion.

---

## UI Layers

This project includes 6 pre-built FlexPanel UI layers demonstrating complete game menus. All layers use the `GMUI_` prefix convention for uniqueness.

### Main Menu
**Name:** GMUI_MainMenu\
**Purpose:** The main menu displayed at game start.

**Contains:**
- Play button
- Options button
- Credits button
- Quit button

**Usage:**
```gml
// Show main menu
layer_set_visible("GMUI_MainMenu", true);

// Hide main menu when starting game
layer_set_visible("GMUI_MainMenu", false);
```

---

### Pause
**Name:** GMUI_Pause\
**Purpose:** Pause menu overlay shown during gameplay.

**Contains:**
- Resume button (calls `Pause()` function)
- Restart button
- Quit button (with confirmation)

**Helper Functions:**
```gml
// Pause/unpause the game
Pause();

// Quit with confirmation dialog
ConfirmQuit();
```

**Managed by:** `global.paused` variable tracks pause state.

---

### Options
**Name:** GMUI_Options\
**Purpose:** Settings/configuration menu.

**Contains:**
- Volume slider (0-100)
- Resolution dropdown
- Fullscreen checkbox
- Anti-aliasing checkbox
- Language dropdown
- Confirm and Cancel buttons

**Helper Functions:**
```gml
// Open options menu
OpenOptions();

// Apply and save options
ApplyOptions();

// Cancel without saving
CancelOptions();

// Populate controls with current values
FindControls();
FillOptions();
```

**Notes:**
- Uses `global.control_*` variables for quick access to UI elements
- Automatically localizes all text when language changes
- Settings stored in global variables: `global.volume`, `global.resolution_w/h`, `global.fullscreen`, `global.aa`

---

### Character
**Name:** GMUI_Character\
**Purpose:** Character equipment/inventory screen.

**Contains:**
- Equipment slots (Head, Chest, Hands, Feet)
- Character stats display (Health, Armour, Attack, Movement, Luck)
- Close button

**Helper Functions:**
```gml
// Open character screen
OpenEquipment();

// Close character screen
CloseEquipment();
```

**Notes:**
- Uses `oSlot` objects as equipment slot containers
- Stats displayed as text labels that can be updated programmatically

---

### Confirmation
**Name:** GMUI_Confirmation\
**Purpose:** Modal confirmation dialog for important actions.

**Contains:**
- Title text ("Confirmation")
- Message text ("Are you sure?")
- Yes button
- No button

**Helper Functions:**
```gml
// Open confirmation with custom callbacks
Confirm(yes_function, no_function);

// Close without action
CancelConfirmation();

// Example: Confirm before quitting
Confirm(game_end);  // Yes executes game_end, No closes dialog
```

**Notes:**
- Yes/No button callbacks are set dynamically via `Button_Release` property
- No button defaults to `CancelConfirmation()` if not specified
- Confirmation text can be changed via FlexPanel text elements

---

### Game Over
**Name:** GMUI_GameOver\
**Purpose:** Game over screen displayed when player loses.

**Contains:**
- Title text ("Game Over")
- Restart button
- Quit button

**Usage:**
```gml
// Show game over screen
layer_set_visible("GMUI_GameOver", true);

// Hide other UI first
HideAllUI();
layer_set_visible("GMUI_GameOver", true);
```

---

## UI Manager Object

### oUIManager
**Purpose:** A controller object that initializes the UI system and handles global keyboard shortcuts.

**What it does:**

1. **Layer Registration (Create Event):**
   - Marks all GMUI_* layers as used with `gml_pragma()` to prevent GameMaker from stripping them during compilation
   - Initializes `global.previous_menu` to "GMUI_MainMenu" for menu navigation tracking

2. **Keyboard Shortcuts (Step Event):**
   - `Ctrl + E`: Toggles the character/equipment screen (GMUI_Character)
   - `Escape`: Pauses the game (opens GMUI_Pause) when not already paused

**Properties:**
- No configurable properties
- Non-persistent (doesn't carry between rooms)
- Invisible (no sprite)

**Usage:**
```gml
// Place one instance of oUIManager in your room
// The object handles everything automatically

// The manager sets up this global variable:
// global.previous_menu - Tracks which menu to return to (default: "GMUI_MainMenu")
```

**Important Notes:**
- Required for the UI system to function properly
- Should be placed in rooms that use the GMUI_* layers
- Only one instance needed per room
- The `gml_pragma()` calls ensure all UI layers are included in final builds
- Keyboard shortcuts can be customized by editing the Step_0 event in objects/oUIManager/Step_0.gml:1

---

### Layer Management Functions

The project includes helper functions in `UIFunctions.gml` for managing layers:

```gml
// Hide all UI layers at once
HideAllUI();

// Update all localized text across all layers
Localisation_Update_All();
```

**Important Notes:**
- All layers are FlexPanel-based for responsive layout
- Layers default to `visible: false` (except GMUI_MainMenu)
- Always use `layer_set_visible()` to show/hide layers
- Layer prefix `GMUI_` ensures unique names when imported into other projects
- FlexPanel layouts recalculate automatically when localisation changes

---

## Integration Tips

1. **UI Layers**: Place UI components on layers prefixed with `GMUI_` for best compatibility
2. **FlexPanel**: Components work well with GameMaker's FlexPanel layout system
3. **Callbacks**: Use function references for button callbacks, not strings
4. **Color Format**: Colors use GameMaker's hex format: #AARRGGBB (alpha, red, green, blue)
5. **Fonts**: Default fonts are `fUI` and `fUI_Bold` (included)
6. **Layer Visibility**: Use `layer_set_visible()` to show/hide UI layers, never `instance_deactivate`
7. **Global State**: UI system uses global variables (`global.paused`, `global.volume`, etc.) for state management

---
