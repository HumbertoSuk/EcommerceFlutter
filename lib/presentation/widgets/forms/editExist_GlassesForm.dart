import 'package:app_lenses_commerce/helpers/listformGlasses.dart';
import 'package:app_lenses_commerce/presentation/providers/addProduct_Provider.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_lenses_commerce/presentation/widgets/groupWidgets/GroupWidgetsCustom.dart';
import 'package:app_lenses_commerce/presentation/widgets/DropDownutton/DropDownButtonCustom.dart';
import 'package:app_lenses_commerce/helpers/validation/validation.dart';

class EditExistForm extends StatefulWidget {
  final SnackbarProvider snackbarProvider;
  final String glassId;

  const EditExistForm({
    Key? key,
    required this.snackbarProvider,
    required this.glassId,
  }) : super(key: key);

  @override
  _EditExistFormState createState() => _EditExistFormState();
}

class _EditExistFormState extends State<EditExistForm> with ValidationMixin {
  @override
  void initState() {
    super.initState();
    productProvider =
        ProductProvider(snackbarProvider: widget.snackbarProvider);
    // cargar productos
    loadProductData(widget.glassId);
  }

  late ProductProvider productProvider;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController stockMinController = TextEditingController();
  final TextEditingController stockMaxController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  bool isAvailable = true;
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  // Variables para almacenar los mensajes de error de validación
  String? nameError = '';
  String? priceError = '';
  String? stockError = '';
  String? stockMinError = '';
  String? stockMaxError = '';
  String? errorDescription = '';
  String? imageUrlError = '';
  DateTime? selectedDateTime = DateTime.now();
  // Variable para habilitar o deshabilitar el botón de crear producto
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          _buildNameTextField(),
          const SizedBox(height: 25),
          _buildGlassesTypeDropdown(),
          const SizedBox(height: 12),
          _buildColorDropdown(),
          const SizedBox(height: 12),
          _buildMaterialDropdown(),
          const SizedBox(height: 12),
          _buildDescriptionTextField(),
          const SizedBox(height: 30),
          _buildPriceTextField(),
          const SizedBox(height: 30),
          _buildStockFields(),
          _buildAvailableCheckbox(),
          const SizedBox(height: 30),
          _buildDateTimePicker(),
          const SizedBox(height: 50),
          _buildImageUrlTextField(),
          const SizedBox(height: 30),
          _buildCreateProductButton(),
        ],
      ),
    );
  }

  // Métodos para construir diferentes widgets

  // Construir campo de texto para el nombre del producto
  Widget _buildNameTextField() {
    return CustomTextField(
      hintText: 'Nombre producto',
      controller: nameController,
      onChanged: (_) => _validateFieldNameProduct(),
      errorText: nameError,
      maxLength: 25,
    );
  }

  // Construir menú desplegable para el tipo de gafas
  Widget _buildGlassesTypeDropdown() {
    return GroupedWidget(
      title: 'Tipo de gafas',
      widget: CustomDropdownButton(
        hintText: 'Selecciona el tipo de gafas',
        value: FormOptions.selectedGlassesType,
        items: FormOptions.availableGlassesTypes,
        onChanged: (value) {
          setState(() {
            FormOptions.selectedGlassesType = value as String;
          });
        },
      ),
    );
  }

  // Construir menú desplegable para el color de gafas
  Widget _buildColorDropdown() {
    return GroupedWidget(
      title: 'Color de gafas',
      widget: CustomDropdownButton(
        hintText: 'Selecciona el color de gafas',
        value: FormOptions.selectedColor,
        items: FormOptions.availableColors,
        onChanged: (value) {
          setState(() {
            FormOptions.selectedColor = value as String;
          });
        },
      ),
    );
  }

  // Construir menú desplegable para el material de las gafas
  Widget _buildMaterialDropdown() {
    return GroupedWidget(
      title: 'Material',
      widget: CustomDropdownButton(
        hintText: 'Selecciona el material',
        value: FormOptions.selectedMaterial,
        items: FormOptions.availableMaterials,
        onChanged: (value) {
          setState(() {
            FormOptions.selectedMaterial = value as String;
          });
        },
      ),
    );
  }

  // Construir campo de texto para la descripción del producto
  Widget _buildDescriptionTextField() {
    return GroupedWidget(
      title: 'Descripción',
      widget: CustomTextField(
        hintText: 'Agrega una descripción',
        controller: descriptionController,
        maxLines: 3,
        onChanged: (_) => _validateFieldDescription(),
        errorText: errorDescription,
      ),
    );
  }

  // Construir campo de texto para el precio del producto
  Widget _buildPriceTextField() {
    return GroupedWidget(
      title: 'Precio',
      widget: CustomTextField(
        hintText: 'Precio',
        controller: priceController,
        onChanged: (_) => _validatePrice(),
        errorText: priceError,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 10,
      ),
    );
  }

  // Construir campos de texto para el stock mínimo, máximo y actual
  Widget _buildStockFields() {
    return GroupedWidget(
      title: 'Stock',
      widget: Column(
        children: [
          CustomTextField(
            hintText: 'Stock',
            controller: stockController,
            onChanged: (_) => _validateStock(),
            errorText: stockError,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 5,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: 'Stock Mínimo',
            controller: stockMinController,
            onChanged: (_) => _validateStock(),
            errorText: stockMinError,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 5,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: 'Stock Máximo',
            controller: stockMaxController,
            onChanged: (_) => _validateStock(),
            errorText: stockMaxError,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 5,
          ),
        ],
      ),
    );
  }

  // Construir checkbox para indicar si el producto está disponible
  Widget _buildAvailableCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Disponible para venta',
          style: TextStyle(fontSize: 18.0),
        ),
        Checkbox(
          value: isAvailable,
          onChanged: (value) => setState(() => isAvailable = value!),
        ),
      ],
    );
  }

  // Construir campo de texto para la URL de la imagen del producto
  Widget _buildImageUrlTextField() {
    return CustomTextField(
      hintText: 'URL de la imagen',
      controller: imageUrlController, // Utiliza el controlador aquí
      onChanged: (_) => _validateImageUrl(),
      errorText: imageUrlError,
    );
  }

  // Construir selector de fecha y hora de creación del producto
  Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fecha y Hora de Creación',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: _formatDateTime(selectedDateTime),
                onPressed: _selectDateTime,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    return dateTime == null
        ? 'Selecciona la fecha y hora'
        : '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  void _selectDateTime() async {
    final selected = await _showDateTimePicker(context);
    setState(() => selectedDateTime = selected);
  }

  // Construir botón para crear un nuevo producto
  Widget _buildCreateProductButton() {
    return CustomButton(
      onPressed: isButtonEnabled ? _updateProduct : null,
      text: 'Editar Producto',
    );
  }

  // Métodos para validar campos y actualizar el estado del botón-------------------------------

  // Validar el campo del nombre del producto
  void _validateFieldNameProduct() {
    final isNameValid = !containsSpecialCharacters(nameController.text);
    setState(() {
      nameError =
          isNameValid ? null : 'El nombre no puede tener caracteres especiales';
      _updateButtonState();
    });
  }

  // Validar el campo de la descripción del producto
  void _validateFieldDescription() {
    final isDescriptionValid = !isTextGrammatical(descriptionController.text);
    setState(() {
      errorDescription =
          isDescriptionValid ? null : 'No debe contener caracteres especiales';
      _updateButtonState();
    });
  }

  // Validar el campo del precio del producto
  void _validatePrice() {
    final String value = priceController.text.trim();
    setState(() {
      priceError = isValidPrice(value) ? null : 'Precio inválido';
      _updateButtonState();
    });
  }

  // Validar los campos de stock mínimo, máximo y actual del producto
  void _validateStock() {
    final String stockValue = stockController.text.trim();
    final String stockMinValue = stockMinController.text.trim();
    final String stockMaxValue = stockMaxController.text.trim();
    setState(() {
      stockError = isValidStock(stockValue) ? null : 'Stock inválido';
      stockMinError = isValidStockMin(stockMinValue, stockValue)
          ? null
          : 'Stock mínimo inválido';
      stockMaxError = isValidStockMax(stockMaxValue, stockValue)
          ? null
          : 'Stock máximo inválido';
      _updateButtonState();
    });
  }

  // Validar el campo de la URL de la imagen del producto
  void _validateImageUrl() {
    final isValidUrl = imageUrlController.text.trim().isNotEmpty;
    setState(() {
      imageUrlError =
          isValidUrl ? null : 'La URL de la imagen no puede estar vacía';
      _updateButtonState();
    });
  }

  // Comprobar si todos los campos son válidos y contienen algo
  bool _isValidFields() {
    return nameError == null &&
        priceError == null &&
        stockError == null &&
        stockMinError == null &&
        stockMaxError == null &&
        errorDescription == null &&
        descriptionController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        imageUrlController.text.isNotEmpty;
  }

  // Actualizar el estado del botón de creación del producto
  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _isValidFields();
    });
  }

  // Método para limpiar el formulario
  void _clearForm() {
    setState(() {
      _clearFields();
      _resetFormState();
    });
  }

  // Método para limpiar los campos
  void _clearFields() {
    nameController.clear();
    descriptionController.clear();
    materialController.clear();
    priceController.clear();
    stockController.clear();
    stockMinController.clear();
    stockMaxController.clear();
    imageUrlController.clear();
  }

// Método para restablecer el estado del formulario
  void _resetFormState() {
    isAvailable = true;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    _resetFormErrors();
    isButtonEnabled = false;
  }

// Método auxiliar para restablecer los errores
  void _resetFormErrors() {
    nameError = null;
    priceError = null;
    stockError = null;
    stockMinError = null;
    stockMaxError = null;
    errorDescription = null;
  }

  // Método auxiliar para mostrar el selector de fecha y hora
  Future<DateTime?> _showDateTimePicker(BuildContext context) async {
    final initial = DateTime.now();
    final first = DateTime(2000);
    final last = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null;
  }

  // Método para actualizar un producto existente
  void _updateProduct() {
    final productProvider =
        ProductProvider(snackbarProvider: widget.snackbarProvider);
    productProvider.updateProduct(
      productId: widget.glassId,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      material: FormOptions.selectedMaterial,
      type: FormOptions.selectedGlassesType,
      color: FormOptions.selectedColor,
      price: double.parse(priceController.text.trim()),
      stock: int.parse(stockController.text.trim()),
      minStock: int.parse(stockMinController.text.trim()),
      maxStock: int.parse(stockMaxController.text.trim()),
      available: isAvailable,
      image: imageUrlController.text.trim(),
      creationDate: selectedDateTime ?? DateTime.now(),
      context: context,
    );

    FocusScope.of(context).unfocus();
    resetValidation();
  }

  void loadProductData(String glassId) async {
    try {
      final glassesModel =
          await productProvider.getProductDetails(context, glassId);
      if (glassesModel != null) {
        setState(() {
          nameController.text = glassesModel.name;
          descriptionController.text = glassesModel.description;
          materialController.text = glassesModel.material;
          priceController.text = glassesModel.price.toString();
          stockController.text = glassesModel.stock.toString();
          stockMinController.text = glassesModel.minStock.toString();
          stockMaxController.text = glassesModel.maxStock.toString();
          imageUrlController.text = glassesModel.image.toString();
          isAvailable = glassesModel.available;

          // Set the selected date and time
          selectedDateTime = glassesModel.creationDate.toDate();

          // Set the selected glasses type
          FormOptions.selectedGlassesType = glassesModel.type;

          // Set the selected color
          FormOptions.selectedColor = glassesModel.color;

          // Set the selected material
          FormOptions.selectedMaterial = glassesModel.material;

          // Update the button state
          _updateButtonState();
          resetValidation();
        });
      } else {
        print('No data found for the provided ID.');
      }
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  resetValidation() {
    //Validaciones
    _validateFieldNameProduct();
    _validateFieldDescription();
    _validatePrice();
    _validateStock();
    _validateImageUrl();
  }
}
