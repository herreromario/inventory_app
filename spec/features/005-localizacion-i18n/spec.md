# 005 · Localización (i18n)

**Estado:** propuesta

## Qué hace

La aplicación detecta automáticamente el idioma del dispositivo y muestra
todos los textos de UI en español o inglés. Se usa `flutter gen-l10n` con
archivos ARB para generar una clase `AppLocalizations` con keys tipadas.
No hay selector manual de idioma; se respeta la configuración del sistema.

## Por qué

El código actual mezcla texto en español e inglés de forma inconsistente
(la sección de estadísticas está en español, el resto en inglés). Esto
genera una experiencia de usuario confusa. Localizar correctamente permite
demostrar buenas prácticas en el portafolio profesional.

## Criterios de aceptación

- [ ] La app detecta el idioma del dispositivo y muestra textos en ese idioma.
- [ ] Todos los strings de UI están en archivos ARB (no hardcodeados).
- [ ] `AppLocalizations.of(context)!.keyName` funciona en todas las páginas.
- [ ] Los strings en español son correctos (no traducciones literales).
- [ ] No hay strings hardcodeados restantes en archivos `.dart`.
- [ ] El símbolo de moneda se muestra según el idioma: `$` en inglés, `€` en español.
- [ ] La abreviatura de cantidad se muestra según el idioma: `Qty` en inglés, `Cant` en español.
- [ ] `flutter analyze` pasa sin errores.
- [ ] Todos los tests existentes siguen pasando.

## Fuera de alcance

- Selector manual de idioma en la UI.
- Persistencia de preferencia de idioma.
- Localización de fechas o números (formatos decimales/miles).
- Traducción a otros idiomas además de ES/EN.
