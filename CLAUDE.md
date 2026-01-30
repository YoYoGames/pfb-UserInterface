# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GameMaker UI Prefabs library (`@gm-prefabs/UI`) that provides reusable UI components for GameMaker projects. It's distributed as a `.yymps` package file and includes components like buttons, dropdowns, checkboxes, sliders, textboxes, progress bars, and more.

## GameMaker Project Structure

This is a **GameMaker Studio project** (`.yyp` format), not a traditional code repository:

- **`.yyp` file**: The main project file (`UI_Prefabs.yyp`) - JSON format defining all project resources
- **`.yy` files**: Resource definition files (objects, sprites, scripts, etc.) - JSON format
- **`.gml` files**: GameMaker Language code files (event handlers, scripts)
- **`.yymps` files**: GameMaker package files for distribution

## Development Workflow

### Opening the Project
Open `UI_Prefabs.yyp` in GameMaker Studio IDE (requires GameMaker 2022.0.2 LTS or later).

### Building Packages
The package is built through GameMaker IDE's Local Package export feature. The current version is `0.1.5` but the latest `.yymps` file is `io.gamemaker.userinterface-0.1.6.yymps`.

### Version Management
When updating the package version:
1. Update `version` in `package.json`
2. Update `files` array in `package.json` to reference the new `.yymps` filename
3. Export the package through GameMaker IDE

### Dependencies
This project has a forced dependency on `io.gamemaker.sdfshaders-1.0.0` (see `ForcedPrefabProjectReferences` in `.yyp`).

## Architecture

### Object Hierarchy

The UI system uses a clear object inheritance hierarchy:

```
oUIParent (base class)
  ├─ oLocalised (adds localisation support)
  │   ├─ Button
  │   ├─ CheckBox
  │   ├─ DropDown
  │   ├─ Slider
  │   ├─ Toggle
  │   ├─ Textbox
  │   ├─ ProgressBar
  │   ├─ Spinner
  │   └─ Infobox
  └─ oSlot
```

**Key base classes:**
- `oUIParent`: Root parent with `prevent_clickthrough` property
- `oLocalised`: Adds text localization with properties: `text`, `localisation_string`, `localisation_lang_override`

### UI Layer System

The project uses **FlexPanel** layouts with special layer naming convention. All UI layers are prefixed with `GMUI_` to ensure uniqueness:

- `GMUI_MainMenu` - Main menu (visible by default)
- `GMUI_Options` - Settings menu with controls mapped to `global.control_*` variables
- `GMUI_Pause` - Pause overlay with Resume/Restart/Quit
- `GMUI_Confirmation` - Modal dialog with Yes/No buttons
- `GMUI_Character` - Equipment/stats screen with `oSlot` objects
- `GMUI_GameOver` - Game over screen

**Important:** When creating new UI layers, always prefix them with `GMUI_` (see commit 94ea50e6).

**Layer Management:** All layers default to `visible: false` except MainMenu. Use `layer_set_visible()` to show/hide, never `instance_deactivate`.

### Localisation System

The localisation system uses:
- **CSV file**: `datafiles/localisation.csv` with columns: `name`, `en`, `fr`, `de`
- **Global structures**:
  - `global.language`: Current language (default "English")
  - `global.languages`: Array of available languages
  - `global.language_strings`: Nested struct of translations
  - `global.ui_text`: Struct mapping UI text elements to localisation strings

**Key functions** (in `scripts/LocalisationFunctions/LocalisationFunctions.gml`):
- `Localisation_Load(filename)`: Loads CSV and populates `global.language_strings`
- `GetLocalisation(string_name, language)`: Retrieves translated string
- `Localisation_Update_All()`: Updates all UI text when language changes
- `GetAllText()`: Maps FlexPanel text elements to localisation keys

### FlexPanel Integration

UI is built using GameMaker's FlexPanel system. Helper functions in `scripts/UIFunctions/UIFunctions.gml`:

**FlexPanel Helpers:**
- `GetInstanceIDFromElement(struct, object_id)`: Find instance ID from FlexPanel struct
- `GetTextElementId(struct)`: Find text element ID in FlexPanel struct

**Layer Management Functions:**
- `HideAllUI()`: Hides all GMUI_* layers at once
- `FindControls()`: Maps Options menu controls to `global.control_*` variables
- `FillOptions()`: Populates control values from global settings

**Menu Navigation:**
- `OpenOptions()`: Opens options menu, calls FindControls/GetAllText/FillOptions
- `ApplyOptions()`: Saves settings from controls to globals, updates localisation
- `CancelOptions()`: Closes options without saving
- `OpenEquipment()` / `CloseEquipment()`: Character screen management
- `Pause()`: Toggles pause state and GMUI_Pause visibility
- `Confirm(yes_func, no_func)`: Opens confirmation dialog with custom callbacks
- `CancelConfirmation()`: Closes confirmation dialog
- `ConfirmQuit()`: Opens confirmation before quitting
- `Quit()`: Returns to main menu
- `ExitGame()`: Confirms before calling `game_end()`

### UI Components

All components inherit from `oLocalised` and share common patterns:

**Common properties:**
- Scale handling: `base_xscale`, `base_yscale`, scale animation on hover/press
- Font scaling: `Text_Size`, `Font`, calculated `Font_Scale`
- Visual customization: `Colour`, `Icon`, `Icon_Scale`
- Interaction: `Sound`, callback functions

**Component-specific details:**

- **Button**: Uses `Button_Release` callback property (function reference), supports icon or text, has `Press_Scale` and `Hover_Scale`. Mouse events: hover (10/11), pressed (4), released (7), no-click (56).

- **CheckBox**: Simple boolean toggle with `Checked` property. Uses `check_sprite` (default: Icon_Tick) drawn on top when checked. Mouse events: click (4), release (7), no-click (56).

- **DropDown**: Methods: `FillList(array)`, `Scroll(amount)`, `ResizeList()`. Uses surface rendering for scrollable list. Properties: `selected` (index), `items` (array), `shown_items` (visible count). Auto-detects `dropdown_direction` based on screen position.

- **Slider**: Methods: `getValue()`, `setValue(value)`, `getMinValue()`, `setMinValue(value)`, `getMaxValue()`, `setMaxValue(value)`, `updateSliderThumbPos(x, y)`. Supports `num_steps` for discrete values or `step_size` for snapping. Handles drag (50), hover (53), click (4), release (56).

- **Toggle**: Animated switch using sequence (`qToggle`). `Checked` property toggles state. Color properties for both checked/unchecked states applied to background and/or dot via `colour_area` enum.

- **Textbox**: Methods: `updateText(text, isLocalised)`, `ParseInput(input)`. Properties: `editable`, `expected_input` ("all"/"int"/"real"), `overflow_behaviour` ("wrap"/"scroll"). Handles keyboard input validation in Step_0, focus on click.

- **ProgressBar**: Methods: `getCurrentValue()`, `setCurrentValue(value)`, `getMaxValue()`, `setMaxValue(value)`. Draws background sprite then scaled foreground sprite based on progress ratio.

- **Spinner**: Animated loading indicator using sequence (`qSpinner`). Control via `spinning` (boolean) and `animation_speed` (0.1-2).

- **Infobox**: Tooltip that appears on hover (Mouse_10). Method: `reposition_infobox_to_window()` keeps tooltip in bounds. Drawn on GUI layer (Draw_64). Auto-sizes to text content.

- **ScrollBar**: Methods: `Scroll(amount)`, `SetPosition(position)`. Auto-detects orientation (horizontal if wider, vertical if taller). Supports mouse wheel (60/61) and gesture drag (3/4). Property: `percentage` (0-1).

- **oSlot**: Minimal base object with no events or methods. Extend for inventory/equipment systems.

### Known Issues & Recent Fixes

Recent commits show fixes for:
- Dropdown closing behavior when clicking button vs menu items (fee11615)
- ScrollBar rendering issues (5c4467f2)
- Mouse down event handling (a2fde3c3)
- Spinner sprite rendering (f1eab939)

## File Organization

```
objects/          - GameMaker objects (UI components, managers)
scripts/          - Reusable GML script files
  ├─ UIFunctions/          - FlexPanel helpers, control management
  └─ LocalisationFunctions/ - Translation system
sprites/          - All sprite assets
  ├─ 9Sliced/     - Nine-slice scalable sprites
  ├─ Icons/       - UI icon set (arrows, cog, cross, etc.)
  └─ SVG/         - SVG-based sprites
datafiles/        - Data files (localisation.csv, font license)
fonts/            - fUI and fUI_Bold fonts (Open Font License)
rooms/            - Demo/test rooms
roomui/           - FlexPanel UI room layouts
sequences/        - Animation sequences (qSpinner, qToggle)
```

## Important Conventions

### Layer Naming
Always prefix UI layers with `GMUI_` for uniqueness in consuming projects.

### Event Inheritance
Most component Create events start with `event_inherited()` to properly inherit from parent objects.

### Localisation Strings
When adding new UI text:
1. Add entries to `datafiles/localisation.csv` for all supported languages
2. Reference the key via `localisation_string` property on `oLocalised` objects
3. Update `GetAllText()` if using FlexPanel text elements

### 9-Slice Sprites
Many UI sprites have `_Scalable` variants that use 9-slice scaling. Use these for components that need to resize dynamically.

### Global State
The project uses global variables extensively:
- Settings: `global.volume`, `global.resolution_w/h`, `global.fullscreen`, `global.aa`, `global.shadows`
- UI state: `global.paused`, `global.previous_menu`
- Controls: `global.control_*` for quick access to UI component instances

## Documentation

**Comprehensive user documentation** is available in `notes/README/README.txt`. This file contains:
- Complete component API reference with all properties and methods
- Usage examples for each component
- Detailed UI layer documentation (all 6 GMUI_* layers)
- Integration tips and best practices
- Table of contents with anchor links

When making changes to components or layers, update the README to keep documentation in sync.

## Common Workflows

### Adding a New UI Component
1. Create object inheriting from `oLocalised` (for text) or `oUIParent` (no text)
2. Add Create event with `event_inherited()` first line
3. Define properties in `.yy` file with descriptive `varDescription` and `varFriendlyName`
4. Implement mouse events as needed (4=click, 7=release, 10=hover, 11=hover_end, 56=no-click)
5. Add to `objects/` directory
6. Update README.txt with component documentation
7. Test in UIRoom

### Modifying UI Layers
1. UI layers are defined in `roomui/RoomUI/RoomUI.yy` (large JSON file)
2. Edit in GameMaker IDE Room Editor, not directly in JSON
3. Always use FlexPanel for layout
4. Ensure layer name starts with `GMUI_`
5. Set default `visible: false` (except MainMenu)
6. Update helper functions in UIFunctions.gml if adding controls
7. Update README.txt layer documentation

### Adding Localisation Strings
1. Add row to `datafiles/localisation.csv` with format: `key,en_value,fr_value,de_value`
2. If FlexPanel text element, add mapping in `GetAllText()` function
3. If object property, set `localisation_string` property to key
4. Test with language dropdown in Options menu

### Updating Package Version
1. Increment version in `package.json`
2. Update `files` array to reference new `.yymps` filename
3. Export package via GameMaker IDE (Local Package)
4. Commit both `package.json` and new `.yymps` file

## Testing

The demo room (`UIRoom`) showcases all components and can be used for testing changes. The room includes:
- All 6 UI layers (MainMenu, Pause, Options, Character, Confirmation, GameOver)
- `oUIManager` instance that initializes `global.previous_menu`
- FlexPanel layouts defined in `roomui/RoomUI/RoomUI.yy`

Run the project in GameMaker IDE to test UI components interactively. The room demonstrates:
- Layer visibility management
- Localisation system (EN/FR/DE)
- Settings persistence via global variables
- Component interactions and callbacks
