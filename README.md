# KGenmoji 🎨

> **Creador de Genmojis y Stickers con IA local para KDE Plasma 6 (Wayland).**

KGenmoji mezcla emojis prediseñados, genera stickers con IA local y organiza
los resultados en una galería, con el diseño **Golden Gate / Liquid Glass**
del sistema de diseño `CachyOS.UI`.

---

## ✨ Características

- **Diseño Golden Gate / Liquid Glass** (`CachyOS.UI`): ventana `CachyWindow` con marco translúcido y desenfoque de KWin, cabecera de `44 px` con el divisor duro de `1 px`, radio de `20 px` y proporción canónica `880 × 640`.
- **Navegación por pestañas** como píldoras de cristal en la cabecera: *Mezclador*, *Creador IA* y *Mis Stickers*.
- **Mezclador de emojis**: lista de combinaciones curadas con vista previa grande y copia al portapapeles de un clic.
- **Creador de stickers con IA**: descripción libre, cuatro estilos (3D Emoji, Caricatura, Pixel Art, Pegatina Vector) y generación local.
- **Galería de stickers**: cuadrícula con el tamaño de cada archivo, copia y borrado.
- **Atajos**: `Meta+Shift+W` invoca el panel con la selección activa del sistema.

---

## 🚀 Compilación e Instalación

```bash
# 1. El sistema de diseño (módulo QML + helper de traducciones) debe estar instalado
cd ../cachyos-ui
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build -j"$(nproc)"
DESTDIR=$HOME/.local cmake --install build

# 2. La aplicación
cd ../kgenmoji
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local
cmake --build build
ctest --test-dir build --output-on-failure
cmake --install build
```

---

## 🧪 Tests

```bash
cd kgenmoji
ctest --test-dir build --output-on-failure
```

- `test_kgenmoji`: la lógica del controlador (combinaciones curadas, generación de *prompts*, etc.).
- `test_layout_audit`: monta la escena QML real *offscreen* y verifica las invariantes del diseño (sin solapamientos, sin recortes, sin desbordes) en las tres páginas y en un barrido de anchos de 640 a 1440 px.

---

## 📄 Licencia

GPLv3. Desarrollado por César Conte.
