// --- Recursos ---
PImage fondo;
PImage oso_default, oso_happy, oso_sad, oso_surprised;
PImage deer_default, deer_happy, deer_seriusly, deer_surprised;


PVector btnSi, btnNo, btnContinuar;
int estado = 0;           // 0=intro, 1=aceptó, 2=rechazó, 3=acepta tras insistencia
int paso = 0;             // índice de línea dentro del estado
String lineaActual = "";
boolean hablaOso = true;  // quién habla en la línea actual

void setup() {
  size(800, 600);
  fondo = loadImage("background game.jpg");

  // Cargar imágenes
  oso_default = loadImage("oso_default.png");
  oso_happy = loadImage("oso_happy.png");
  oso_sad = loadImage("oso_sad.png");
  oso_surprised = loadImage("oso_surprised.png");

  deer_default = loadImage("deer_default.png");
  deer_happy = loadImage("deer_happy.png");
  deer_seriusly = loadImage("deer_seriusly.png");   // nombre según tu archivo
  deer_surprised = loadImage("deer_surprised.png");

  // Botones
  btnSi = new PVector(120, height - 80);
  btnNo = new PVector(240, height - 80);
  btnContinuar = new PVector(width - 140, height - 80);

  textSize(18);
}

void draw() {
  // Fondo escalado al tamaño de la ventana
  image(fondo, 0, 0, width, height);

  // Actualizar contenido según estado/paso
  actualizarLinea();

  // Dibujar personajes (abajo) sólo el que habla
  float altoOso = 260;
  float altoDeer = 300;
  float margin = 20;

  if (!hablaOso) {
    // Habla ciervo (izquierda)
    float xDeer = 40;
    float yDeer = height - altoDeer - 140; // zona inferior
    PImage deerImg = imagenCiervoParaEstado();
    dibujarEscalado(deerImg, xDeer, yDeer, altoDeer);
  } else {
    // Habla oso (derecha)
    float xOso = width - 40 - (oso_default.width * (altoOso / oso_default.height));
    float yOso = height - altoOso - 140;
    PImage osoImg = imagenOsoParaEstado();
    dibujarEscalado(osoImg, xOso, yOso, altoOso);
  }

  // Cuadro de diálogo abajo
  mostrarCuadroDialogo();

  // Opciones o continuar, según el momento
  if (muestraOpciones()) {
    mostrarBoton(btnSi, "SI");
    mostrarBoton(btnNo, "NO");
  } else {
    mostrarBoton(btnContinuar, "Continuar");
  }
}

void mousePressed() {
  if (muestraOpciones()) {
    if (mouseEnBoton(btnSi)) {
      if (estado == 0) {
        // eligió SI en la intro
        estado = 1;
        paso = 0;
      } else if (estado == 2) {
        // eligió SI tras insistencia
        estado = 3;
        paso = 0;
      }
    }
    if (mouseEnBoton(btnNo)) {
      if (estado == 0) {
        // eligió NO en la intro
        estado = 2;
        paso = 0;
      } else if (estado == 2) {
        // bucle si sigue eligiendo NO
        estado = 2;
        paso = 0;
      }
    }
  } else {
    // Avanzar entre líneas dentro del estado
    if (mouseEnBoton(btnContinuar)) {
      paso++;
    }
  }
}

// --- Lógica de diálogo por estado/paso ---
void actualizarLinea() {
  // Cada estado tiene líneas secuenciales; sólo una visible por vez
  if (estado == 0) {
    // Intro con cuatro líneas
    if (paso == 0) { lineaActual = "Oso: Hola, Ciervo, te quería pedir tu ayuda."; hablaOso = true; }
    else if (paso == 1) { lineaActual = "Ciervo: ¿Sí? ¿Qué pasa, Oso?"; hablaOso = false; }
    else if (paso == 2) { lineaActual = "Oso: No recolecté suficiente comida para invernar... ¿me ayudas a recolectar algunas?"; hablaOso = true; }
    else if (paso == 3) { lineaActual = "Oso: ¿Me podrías ayudar?"; hablaOso = true; }
    else { paso = 3; } // mantener en la última línea hasta elegir (aparecen opciones)
  }
  else if (estado == 1) {
    // Aceptó
    if (paso == 0) { lineaActual = "Ciervo: ¡Sí, por supuesto que lo haré!"; hablaOso = false; }
    else if (paso == 1) { lineaActual = "Oso: ¡Muchas gracias! Ahora te daré una pequeña guía."; hablaOso = true; }
    else { paso = 1; } // fin del bloque: acá iniciaría el tutorial
  }
  else if (estado == 2) {
    // Rechazó
    if (paso == 0) { lineaActual = "Ciervo: Lo siento, no."; hablaOso = false; }
    else if (paso == 1) { lineaActual = "Oso: ..."; hablaOso = true; }
    else if (paso == 2) { lineaActual = "Oso: ¡POR FAVOR!"; hablaOso = true; }
    else { paso = 2; } // mantener, aparecen opciones SI/NO (bucle si NO)
  }
  else if (estado == 3) {
    // Acepta tras insistencia
    if (paso == 0) { lineaActual = "Ciervo: ¡DE ACUERDO, DE ACUERDO!"; hablaOso = false; }
    else if (paso == 1) { lineaActual = "Ciervo: Lo haré, no llores, por favor."; hablaOso = false; }
    else if (paso == 2) { lineaActual = "Oso: ..."; hablaOso = true; }
    else if (paso == 3) { lineaActual = "Oso: Gracias, ahora te daré una pequeña guía."; hablaOso = true; }
    else { paso = 3; } // fin del bloque: acá iniciaría el tutorial
  }
}

// --- Helpers de imágenes según estado ---
PImage imagenOsoParaEstado() {
  if (estado == 0) return oso_default;
  if (estado == 1) return oso_happy;
  if (estado == 2) {
    if (paso == 1) return oso_surprised;
    return oso_sad;
  }
  if (estado == 3) return oso_happy;
  return oso_default;
}

PImage imagenCiervoParaEstado() {
  if (estado == 0) return deer_default;
  if (estado == 1) return deer_happy;
  if (estado == 2) return deer_seriusly;
  if (estado == 3) return deer_surprised;
  return deer_default;
}

// --- UI ---
void mostrarCuadroDialogo() {
  // Cuadro en la parte inferior
  float boxX = 20;
  float boxY = height - 130;
  float boxW = width - 40;
  float boxH = 110;

  noStroke();
  fill(0, 150);
  rect(boxX, boxY, boxW, boxH);

  fill(255);
  textAlign(LEFT, TOP);
  text(lineaActual, boxX + 16, boxY + 14, boxW - 32, boxH - 28);
}

boolean muestraOpciones() {
  // En intro (estado 0) y rechazo (estado 2), cuando se llega a la última línea del bloque, mostrar SI/NO
  if (estado == 0 && paso >= 3) return true;
  if (estado == 2 && paso >= 2) return true;
  return false;
}

void mostrarBoton(PVector pos, String label) {
  float w = 100, h = 40;
  boolean hover = mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h;

  fill(hover ? color(255, 230, 160) : color(255, 210, 120));
  stroke(60);
  rect(pos.x, pos.y, w, h, 8);

  fill(0);
  textAlign(CENTER, CENTER);
  text(label, pos.x + w/2, pos.y + h/2);
}

boolean mouseEnBoton(PVector pos) {
  float w = 100, h = 40;
  return mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h;
}

// --- Utilidad de escala proporcional ---
void dibujarEscalado(PImage img, float x, float y, float altoDeseado) {
  float escala = altoDeseado / img.height;
  float ancho = img.width * escala;
  image(img, x, y, ancho, altoDeseado);
}
