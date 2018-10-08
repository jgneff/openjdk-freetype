  /*************************************************************************/
  /*                                                                       */
  /* Uncomment the line below if you want to activate sub-pixel rendering  */
  /* (a.k.a. LCD rendering, or ClearType) in this build of the library.    */
  /*                                                                       */
  /* Note that this feature is covered by several Microsoft patents        */
  /* and should not be activated in any default build of the library.      */
  /*                                                                       */
  /* This macro has no impact on the FreeType API, only on its             */
  /* _implementation_.  For example, using FT_RENDER_MODE_LCD when calling */
  /* FT_Render_Glyph still generates a bitmap that is 3 times wider than   */
  /* the original size in case this macro isn't defined; however, each     */
  /* triplet of subpixels has R=G=B.                                       */
  /*                                                                       */
  /* This is done to allow FreeType clients to run unmodified, forcing     */
  /* them to display normal gray-level anti-aliased glyphs.                */
  /*                                                                       */
/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */
