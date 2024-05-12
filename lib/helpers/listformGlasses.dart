class FormOptions {
  // Opciones de tipo de gafas
  static List<String> availableGlassesTypes = [
    "Redondas",
    "Wayfarers",
    "Aviadores",
    "Rectangulares",
    "Ovaladas",
    "Cat Eye",
    "Browline",
    "Geométrico",
    "Vintage",
    "Retro",
    "Futurista",
  ]; // opciones para el dropdown de tipo de gafas
  static String selectedGlassesType =
      availableGlassesTypes[0].toString(); // tipo preseleccionado

  // Opciones de colores de gafas
  static List<String> availableColors = [
    "Rojo",
    "Azul",
    "Verde",
    "Negro",
    "Blanco",
    "Gris",
    "Rosa",
    "Morado",
    "Marrón",
    "Oro",
    "Plata",
    "Transparente",
    "Multicolor",
  ]; // opciones de colores disponibles
  static String selectedColor =
      availableColors[0].toString(); // color preseleccionado

  // Opciones de materiales de gafas
  static List<String> availableMaterials = [
    "Plástico",
    "Fibra de carbono",
    "Acero inoxidable",
    "Titanio",
    "Acetato",
    "Poliéster",
    "Policarbonato",
    "Aluminio",
  ]; // opciones de materiales disponibles
  static String selectedMaterial =
      availableMaterials[0].toString(); // material preseleccionado
}
