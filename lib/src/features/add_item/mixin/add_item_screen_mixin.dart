part of '../screen/add_item_screen.dart';

mixin AddItemScreenMixin on State<AddItemScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final FocusNode _nameNode;
  late final FocusNode _priceNode;

  final nameRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');
  final priceRegExp = RegExp(r'^[0-9]+$');

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    } else if (!nameRegExp.hasMatch(value)) {
      return 'Name must be alphanumeric';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    } else if (!priceRegExp.hasMatch(value)) {
      return 'Price must be numeric';
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _nameNode = FocusNode();
    _priceNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _nameNode.dispose();
    _priceNode.dispose();
    super.dispose();
  }
}
