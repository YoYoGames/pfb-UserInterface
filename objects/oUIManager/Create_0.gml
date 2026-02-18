/// @description Mark all GMUI layers as used and initialize the previous menu global variable

// Prevent GameMaker from stripping UI layers during compilation
gml_pragma("MarkUILayerAsUsed","GMUI_Confirmation");
gml_pragma("MarkUILayerAsUsed","GMUI_Options");
gml_pragma("MarkUILayerAsUsed","GMUI_Character");
gml_pragma("MarkUILayerAsUsed","GMUI_GameOver");
gml_pragma("MarkUILayerAsUsed","GMUI_Pause");
gml_pragma("MarkUILayerAsUsed","GMUI_MainMenu");

// Initialize the menu to return to when closing other menus
global.previous_menu = "GMUI_MainMenu";