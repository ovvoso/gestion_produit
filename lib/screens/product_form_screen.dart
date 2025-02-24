import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/supabase_service.dart';
import '../widgets/main_drawer.dart';
import 'product_list_screen.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  
  late TextEditingController _codeController;
  late TextEditingController _designationController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  DateTime? _expirationDate;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.product?.code ?? '');
    _designationController = TextEditingController(text: widget.product?.designation ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _expirationDate = widget.product?.expirationDate;
  }

  void _navigateToList() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const ProductListScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Nouveau Produit' : 'Modifier le Produit'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: 'Code',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.qr_code),
                          ),
                          enabled: widget.product == null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir un code';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _designationController,
                          decoration: InputDecoration(
                            labelText: 'Désignation',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.label),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir une désignation';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Prix',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.payments),
                            suffixText: 'FCFA',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir un prix';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Veuillez saisir un nombre valide';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text('Date d\'expiration'),
                            subtitle: Text(
                              _expirationDate?.toLocal().toString().split(' ')[0] ?? 
                              'Non définie'
                            ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _expirationDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 3650)),
                              );
                              if (date != null) {
                                setState(() => _expirationDate = date);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final product = Product(
          id: widget.product?.id,
          code: _codeController.text.trim(),
          designation: _designationController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          description: _descriptionController.text.trim(),
          expirationDate: _expirationDate,
        );

        if (widget.product == null) {
          await _supabaseService.ajouterProduit(product.toJson());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produit ajouté avec succès')),
            );
          }
        } else {
          await _supabaseService.updateProduit(product.id!, product.toJson());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produit modifié avec succès')),
            );
          }
        }

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ProductListScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        print('Erreur dans _submitForm: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _designationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
