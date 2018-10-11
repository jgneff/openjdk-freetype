# Screenshots

If the FreeType client fails to set the LCD filter when the ClearType methods are enabled, we get severe color fringes in the rendered text. If the client sets the default LCD filter when the ClearType methods are enabled, we get ClearType-style subpixel rendering with a filter applied to remove the color fringes. In FreeType version 2.8.1 and later when the ClearType methods are disabled, we get the new *Harmony* subpixel rendering, equal in quality to ClearType but with no requirement for the application to set the LCD filter.

| ClearType Enabled, No Filter | ClearType Enabled, Default Filter |
|:----------------------------:|:---------------------------------:|
| ![Text rendered without an LCD filter. Screenshot.](images/01-system-lcdnone.png) | ![Text rendered with the default LCD filter. Screenshot.](images/02-system-lcddefault.png) |
| ClearType-style rendering with severe color fringes | ClearType-style rendering with filtered colors |

| ClearType Disabled |
|:------------------:|
| ![Detail of text rendered without an LCD filter.](images/03-bundled-lcdnone.png) |
| FreeType 2.8.1 Harmony rendering (filter ignored) |

| Details Scaled by 800 Percent |
|:----------------------------:|
| ![Detail of text rendered without an LCD filter.](images/8x01-system-lcdnone-TTF.png) |
| **ClearType Enabled, No Filter:** ClearType-style rendering with severe color fringes |
| ![Detail of text rendered without an LCD filter.](images/8x02-system-lcddefault-TTF.png) |
| **ClearType Enabled, Default Filter:** ClearType-style rendering with filtered colors |
| ![Detail of text rendered with the default LCD filter.](images/8x03-bundled-lcdnone-TTF.png) |
| **ClearType Disabled:** FreeType 2.8.1 Harmony rendering (filter ignored) |
