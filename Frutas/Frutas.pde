class Fruta {
  PImage imagen;
  int puntos;
  float x, y;   // posición en pantalla

  Fruta(String rutaImagen, int puntos, float x, float y) {
    this.imagen = loadImage(rutaImagen);
    this.puntos = puntos;
    this.x = x;
    this.y = y;
  }

  void mostrar() {
    image(imagen, x, y);
  }

  int getPuntos() {
    return puntos;
  }
}

// Clase hija: Naranja
