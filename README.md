# quiz_millionaire_vscript
An enhanced version of the quiz_millionaire TF2 map, powered by VScript:
- Questions are now stored in text/script files instead of groups of `logic_relay` entities
  - Much easier and more readable than modifying entity data to edit the questions
  - No longer bound by the puny 2048 max entity limit
- Added more variety within individual questions
  - All the answers are now randomly sorted every time the question appears
  - Questions can have more than just 3 wrong answers, which will get picked at random

[Video demonstration](https://www.youtube.com/watch?v=fvepJuHDlOU)

The [original map](https://steamcommunity.com/sharedfiles/filedetails/?id=656539932) was made by Doodle64. I do not own any non-script assets (textures/materials, sounds or geometry) used in the map. All rights reserved to their respective owners.

# Playing the map
**NOTE:** Map has been removed until further notice because it appears to be broken. See note below.

This repository contains a version of the map with 8 example questions (2 for each difficulty) and is **not suitable for proper play**. It is **highly recommended** that you modify the map first. I plan on releasing an official, fully playable version with my custom-tailored questions to the Steam Workshop once I gather enough questions. You can submit questions [here](https://forms.gle/HcRb8P6AXm9GYYtA7).

# Modifying the map
**NOTE:** Appears to be broken. These steps are theoretically 100% correct but I've tried packing the files 3 times and got completely random asset file corruptions. Needs more testing, proceed with caution. If attempting these steps, please reply with success mileage [here](https://github.com/brokenphilip/millionaire/issues/1).

1. Make sure you have a map editor of choice (ie. Hammer) set up, as well as [VIDE](http://www.riintouge.com/VIDE/)
2. Download a copy of the repository [here](https://github.com/brokenphilip/millionaire/archive/refs/heads/main.zip)
3. To avoid any future file conflicts, rename the map (VMF file) to something unique (ie. `quiz_millionaire_vscript_(yourname)_(version)`)
4. Open the VMF in your map editor of choice and compile it
5. Use VIDE's Pakfile Lump Editor to [pack](https://tf2maps.net/threads/vide-a-how-to.21661/) the materials and sounds into the map you just compiled, in regards to their respective relative paths
6. Copy the scripts to your TF2's game folder (`tf`)
7. [Build the cubemaps](https://tf2maps.net/threads/tutorial-building-cubemaps.16452/)
8. Playtest the map and make sure it works correctly; if there are no missing textures in the reflections and if all the asset (texture/material, script and sound) files are fully functional, proceed with the next step
9. Populate the question lists within the scripts. I recommend having at least 100+ entries evenly spread out by difficulty for replayability sake
10. Playtest the map with the new questions. Once you are satisfied with the results, if your questions are 100% final, proceed with the next step
11. Pack the scripts into the map you just compiled, in regards to their respective relative paths
12. Delete the leftover scripts in your TF2's game folder

If the map works perfectly, congrats! You now have your very own fully playable version of the map.

If you wish to edit the questions, unpack the question list script files and repack them once you're finished. However, it is recommended that you repeat these steps from the beginning with a new map name to avoid having mismatched versions of the map.
