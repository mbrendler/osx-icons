==========
OS X Icons
==========

``create_iconset.sh`` creates a Icon Set by a given image file.

This is a naive approach, don't use this in production.  See Apples
`High Resolution Guidelines`_ for more informations.

Usage::

   $ ./create_iconset.sh AIconSet a_image.png

This will create the Icon Set (AIconSet.iconset) with PNG files of the needed
resolutions.

After that add the Icon Set to your XCode-Project and set the key *Icon file*
of the Info.plist to the Icon Set name (without extension).

Or create a icon by yourself::

   $ iconutil -c icns AIconSet.icns



.. _High Resolution Guidelines: https://developer.apple.com/library/mac/#documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html
