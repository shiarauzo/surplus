# Learnings

Cómo se llevó el diseño a un Apple Watch.

## El design system es de teléfono

valere-DS está armado para una pantalla de mano: shell, sheets, cards, botones de 44 px. En el reloj se quedan el color, el tipo y el radio. Esos componentes no entran en 184×224. La pantalla del reloj se redibuja con los tokens, no se encoge la de teléfono.

## El sistema no estaba en el Figma

El archivo no tenía la librería publicada. Los tokens salieron del CSS de Evolve, en modo oscuro, y se crearon ahí como variables. Sin eso, el diseño del reloj queda con colores sueltos que no se pueden volver a usar.

## El marco ya existía

El archivo tenía plantillas de Apple Watch 44 mm, 184×224. Las pantallas nuevas usan ese tamaño. Un frame de teléfono puesto en chico no es un reloj.

## Figma no muestra el gesto

Una fila de pantallas con puntos dice que se desliza. No se siente. Para ver el diseño hay que correrlo en el simulador del reloj.

## No es una web

Un prototipo en el navegador, aunque tenga el tamaño del reloj, no es la superficie. El diseño se ve en una app de watchOS, dentro del bisel, con la hora del sistema y el gesto de verdad.

## El simulador se instala aparte

Xcode trae el SDK de watchOS. El simulador no viene con eso. Hay que bajar el runtime de watchOS, varios gigas, desde Componentes. Sin esa pieza no hay un Apple Watch donde correr, aunque el proyecto compile.

## La descarga puede quedar a medias

La imagen puede figurar como lista y no estar montada, o duplicarse. Hasta que el volumen está montado, el simulador no ofrece un reloj. Hay que comprobar el runtime antes de crear el dispositivo.

## Una app solo de reloj se declara así

Si el Info.plist no dice que es watch-only, el simulador exige una app de iPhone al lado y no la instala. El diseño no llega a verse.

## El mapa del archivo no es el mapa

En Figma el mapa era una captura, con la interfaz de otro mapa encima. En el simulador es MapKit. Un pin dibujado y el título del sistema se leen dos veces si se dejan los dos. El gesto de arrastrar el mapa se come el deslizamiento entre páginas, así que el mapa no se mueve.

## En el reloj el deslizamiento de páginas es vertical

El control nativo de páginas va de arriba a abajo. El diseño pedía izquierda y derecha. Eso se construye con un scroll horizontal paginado, no con el tab del sistema.

## Sin una segunda foto, la tarjeta cambia

Había una sola imagen en el archivo. Un rectángulo vacío parece una foto rota. La tarjeta sin imagen pasa a ser tipográfica: el nombre del plato ocupa el lugar de la foto.

## El borde no es tuyo

La hora del sistema y el aviso legal del mapa ocupan las esquinas. Los pines y los puntos de página tienen que caer adentro de eso, no debajo.

## Un gesto nuevo se enseña al llegar

Si la dirección no es la del resto de la app, una fila de pantallas no la explica. Al caer en esa pantalla, un gesto corto —una mano y una línea, como el «desliza para ver más» de un video— muestra hacia dónde se mueve, y se va. No es un tutorial ni una pantalla de instrucciones.

## Encontrar una pantalla en los Figma

Hace falta un lugar que lea los archivos de Figma de la organización y diga dónde está cada cosa. Pedir un login devuelve el listado de los que hay, con el archivo y la pantalla.
