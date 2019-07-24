![Intrepid logo](/intrepid_logo.png)

# Intrepid

This is the source code of a computer game **Intrepid**. You can download the game from [Steam](https://store.steampowered.com/app/992860/Intrepid/), [itch.io](https://miskatonicstudio.itch.io/intrepid), or directly from [Miskatonic Studio's website](https://miskatonicstudio.com/downloads/Intrepid_1.0.2_windows_linux.zip). Mac OS beta version is available on [itch.io](https://miskatonicstudio.itch.io/intrepid) and on [our website](https://miskatonicstudio.com/downloads/Intrepid_1.0.2_macos_beta.zip).

The source code does not contain the whole history of Intrepid's development. The main reason is that the `.git` folder contained all the changes applied to binary resources (images, models), which significantly increased its size, but didn't bring any value.

The contents of this repository should be enough to build the entire game from scratch. If you encounter any problems, let us know and we'll do our best to assist you.

Intrepid was created using **Godot 3.0.6** and the codebase might not work properly with other versions of the engine.

## Licenses:

While many of the resources used in the game are public domain, please consider crediting their original authors if you decide to use them for your projects.

### Code

The game uses a CRT shader created by [AaronWizard](https://github.com/AaronWizard). It is licensed under the MIT license and available on GitHub: [CRTScreenShader](https://github.com/AaronWizard/CRTScreenShader).

The remaining code used in the game was created by Paweł Fertyk and Stanisław Karlik and is public domain.

### Images

Miskatonic Studio's logo is included in this repository, but it cannot be used without a direct permission from Miskatonic Studio.

Images of the yellow planet and 2 moons were created by Paweł Fertyk using [Fracplanet](https://sourceforge.net/projects/fracplanet/) and [Blender](https://www.blender.org/) and are public domain. The yellow planet uses a cloud texture created by NASA: [Blue Marble](https://visibleearth.nasa.gov/view.php?id=57747).

Other images were created by [Joseph Diaz](https://www.artstation.com/josephdiaz) and [Zaven Boyrazian](https://www.artstation.com/cysis145). All of them (including the game's icon and logo) are public domain.

### Models

The model of a human being was created by Paweł Fertyk and was strongly inspired by the bat creature's model from Ben Simmonds' book: [Blender Master Class](https://nostarch.com/blendermasterclass). The model in this repository is public domain, while the original is licensed under Creative Commons non-commercial attribution license (CC-BY-NC).

Other 3D models were created by [Zaven Boyrazian](https://www.artstation.com/cysis145) and are public domain.

Original Blender files and textures (also public domain) can be downloaded directly:

* [spaceship](https://miskatonicstudio.com/downloads/Intrepid_assets_spaceship.zip)
* [planets](https://miskatonicstudio.com/downloads/Intrepid_assets_planets.zip)

### Fonts

`consola.ttf` was provided by [Zaven Boyrazian](https://www.artstation.com/cysis145) and is public domain. `FiraMono-Bold.otf` and `monospaced_font.otf` (renamed from `FiraMono-Regular.otf`) are licensed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

### Sounds

#### Public domain

The following sounds are public domain and can be downloaded from [Freesound](https://freesound.org/).

* `breaker.wav`: https://freesound.org/people/Deathscyp/sounds/404049/
* `button_01.wav`: https://freesound.org/people/LamaMakesMusic/sounds/403556/
* `click.wav`: https://freesound.org/people/NenadSimic/sounds/171697/
* `cryo-pod-door-closing.wav`: https://freesound.org/people/davidworksonline/sounds/54974/
* `cryo-pod-door-opening.wav`: https://freesound.org/people/davidworksonline/sounds/54974/
* `door.wav`: https://freesound.org/people/NeoSpica/sounds/425090/
* `drawer.wav`: https://freesound.org/people/marcusgar/sounds/360949/
* `fall.wav`: https://freesound.org/people/Suburbanwizard/sounds/417994/
* `inventory_pick_up_item.wav`: https://freesound.org/people/SilverIllusionist/sounds/411177/
* `light_flicker.wav`: https://freesound.org/people/LudwigMueller/sounds/202612/
* `locker_door.wav`: https://freesound.org/people/toddcircle/sounds/442365/
* `locker_unlocked.wav`: https://freesound.org/people/DesignDean/sounds/397314/
* `new_keyboard_sound.wav`: https://freesound.org/people/jim-ph/sounds/194797/
* `one_step.wav`: https://freesound.org/people/mypantsfelldown/sounds/398937/
* `page_turn.wav`: https://freesound.org/people/Mydo1/sounds/198963/ (the sound has been removed from Freesound)
* `pane_sliding.wav`: https://freesound.org/people/Yuval/sounds/210994/
* `planet_database_access_denied.wav`: https://freesound.org/people/Jacco18/sounds/419023/
* `planet_database_access_granted.wav`: https://freesound.org/people/PaulMorek/sounds/330074/
* `rusty_hinge_2.wav`: https://freesound.org/people/j1987/sounds/335752/
* `small_button_click.wav`: https://freesound.org/people/LamaMakesMusic/sounds/403556/
* `small_panel_hinge.wav`: https://freesound.org/people/BMacZero/sounds/94134/
* `small_panel_unlock.wav`: https://freesound.org/people/LamaMakesMusic/sounds/403556/
* `tumbler_lock.wav`: https://freesound.org/people/DDT1997/sounds/445779/
* `unlock_padlock.wav`: https://freesound.org/people/IPaddeh/sounds/422852/

#### Creative Commons Attribution

The following sounds are licensed under Creative Commons Attribution license and can be downloaded from [Freesound](https://freesound.org/).

* `alert_low.wav`: https://freesound.org/people/spoonsandlessspoons/sounds/361333/
* `escape_door_handle.wav`: https://freesound.org/people/JustInvoke/sounds/446110/
* `rumble_mono_1.wav`: https://freesound.org/people/OGsoundFX/sounds/423120/

#### PMSFX

The following sounds were downloaded from [PMSFX](https://www.pmsfx.com/). They are all part of the free [SAMPLER bundle](https://www.pmsfx.com/free) and cannot be redistributed without author's permission (according to the [EULA](https://www.pmsfx.com/legal-1)).

* `credits.ogg`: Converted from [PM_SAMPLER_2018_v1.6] `PM_SFA2_2.wav`
* `escape_door.wav`: [SAMPLER] `PM_FSSF_DOOR_BIG_2.wav`
* `exit_music_reverse.ogg`: Converted from [SAMPLER] `PM_Echopraxia_Impacts_Stingers_3.wav`
* `game_outro_music.ogg`: Converted from [SAMPLER] `PM_RD_Drone_5.wav`
* `intro.ogg`: Converted from [PM_SAMPLER_2018_v1.6] `PM_INT_EXC_30.wav`
* `main_music_loop.ogg`: Converted from [SAMPLER] `PM_FSSF_AMBIENCE_SOUNDSCAPE_LOOP_3.wav`
* `menu_button.wav`: [SAMPLER] `PM_FSSF_UI_BEEP_14.wav`
* `power_panel_lock_code.wav`: [SAMPLER] `PM_CSPH_Beeps_47.wav`

