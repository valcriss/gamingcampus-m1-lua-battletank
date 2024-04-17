## Gaming Campus Module 1 LUA BattleTank

--------

### framework/configuration/Configuration.lua

La classe configuration enregistre dans un fichier les éléments de configuration de l'utilisateur (full-screen, vsync,
volume de la musique, volume des effets sonores, niveau de difficulté, retourne également les différents parametres du
jeu en fonction de la difficulté)

<img src="./docs/configuration.svg" width="300">

--------

### framework/screen/ScreenManager.lua

ScreenManager permet de gérer les changements de résolution, lors de son initialisation l'objet ScreenManager est
initialisé avec la résolution de développement.
Ensuite la classe permet d'obtenir le ratio à appliquer à chaque composant du jeu afin de s'adapter à la résolution
actuelle.

<img src="./docs/screenmanager.svg" width="300">

--------

## Les bases de l'architecture

### framework/scenes/ScenesManager.lua

ScenesManager gère la collection de scene actuellement actives dans le jeu, il permet également d'appeler
automatiquement les méthodes load, update, draw, unload de chaque scene.

### framework/scenes/Scene.lua

La classe Scene est une classe abstraite dont chaque scene hérite, les scenes contiennent une collection de composants,
c'est la scene qui est en charge d'appeler les méthode load, update, draw, unload de chaque composant qu'elle contient.

### framework/scenes/Component.lua

La classe Component est une classe abstraite dont chaque composant hérite, les composants contiennent une collection de
sous-composants, c'est le composant qui est en charge d'appeler les méthodes load, update, draw, unload de chaque
sous-compopsant qu'il contient.

![ScenesManager Scene Component](./docs/scenesmanager-scenes-component.svg)

--------

## Les composants du framework

### framework/audio/SoundEffect.lua

Le composant SoundEffect permet de lire un fichier audio, il possède des méthodes play, stop, pause

<img src="./docs/sound-effect.svg" width="300">

### framework/drawing/Rectangle.lua

La classe Rectangle n'est pas un composant mais elle est utilisée par les composants pour définir la zone de dessin ou
de collision

<img src="./docs/rectangle.svg" width="300">

### framework/drawing/Vector2.lua

La classe Vector2 n'est pas un composant mais elle est utilisée par les composants pour définir une position

<img src="./docs/vector2.svg" width="300">

### models/images/Image.lua

Le composant Image permet d'afficher une image, il possède des propriétés permettant de changer l'orientation, la taille

<img src="./docs/image.svg" width="300">

### models/images/Parallax.lua

Le composant Parallax permet d'afficher une image en appliquant un effet de mouvement sur l'axe X

<img src="./docs/parallax.svg" width="300">

### models/images/SpriteSheetImage.lua

Le composant SpriteSheetImage permet d'afficher un sprite sheet animé en définissant le nombre de colonnes, de lignes,
la vitesse de lecture

<img src="./docs/sprite-sheet-image.svg" width="300">

### models/texts/BitmapText.lua

Le composant BitmapText permet d'afficher un texte en utilisant une bitmap font

<img src="./docs/bitmap-text.svg" width="300">

### models/texts/Text.lua

Le composant Text permet d'afficher un texte en utilisant la font standard de love

<img src="./docs/text.svg" width="300">

--------

### models/ui/Button.lua

Le composant Button permet d'afficher un bouton avec l'effet au survol, cliqué, il permet également d'executer un
callback lors du click

### models/ui/CheckBox.lua

Le composant CheckBox permet d'afficher une checkbox

### models/ui/Frame.lua

Le composant Frame permet d'afficher une fenetre en utilisant une texture compatible nine-patch

### models/ui/Slider.lua

Le composant Slider permet d'afficher un slider qui permet à l'utilisateur de sélectionner une valeur comprise entre 0
et 1

### models/ui/SliderButton.lua

Le composant SliderButton est utilisé dans le composant Slider afin d'afficher les boutons + et - qui permettent de
modifier la valeur de ce-dernier.

--------

### models/tools/Fps.lua

Le composant Fps permet d'afficher les FPS actuels à l'écran