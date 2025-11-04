import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _brandController.text = widget.product!.brand;
      _priceController.text = widget.product!.price.toString();
      _imageUrlController.text = widget.product!.imageUrl;
      _descriptionController.text = widget.product!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le téléphone' : 'Ajouter un téléphone'),
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du téléphone',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _brandController.text.isEmpty ? null : _brandController.text,
              decoration: const InputDecoration(
                labelText: 'Marque',
                border: OutlineInputBorder(),
              ),
              items: ['Apple', 'Samsung', 'Google', 'OnePlus', 'Xiaomi', 'Huawei']
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
              onChanged: (value) {
                _brandController.text = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une marque';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Prix (MGA)',
                border: OutlineInputBorder(),
                suffixText: 'MGA',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prix';
                }
                if (double.tryParse(value) == null) {
                  return 'Veuillez entrer un prix valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Section Image
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Photo du téléphone',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedImage != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (_imageUrlController.text.isNotEmpty)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: const Icon(Icons.phone_android, size: 60),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Aucune image sélectionnée', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt, size: 20),
                          label: const Text('Appareil photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library, size: 20),
                          label: const Text('Galerie'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            if (isEditing)
              ElevatedButton(
                onPressed: _deleteProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Supprimer'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrlController.text = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection: $e')),
      );
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id,
        name: _nameController.text,
        brand: _brandController.text,
        price: double.parse(_priceController.text),
        imageUrl: _selectedImage?.path ?? _imageUrlController.text,
        description: _descriptionController.text,
      );

      final productProvider = context.read<ProductProvider>();

      if (widget.product != null) {
        await productProvider.updateProduct(product);
      } else {
        await productProvider.addProduct(product);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.product != null
                ? 'Téléphone modifié avec succès'
                : 'Téléphone ajouté avec succès'),
          ),
        );
      }
    }
  }

  void _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce téléphone ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.product != null) {
      await context.read<ProductProvider>().deleteProduct(widget.product!.id!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Téléphone supprimé avec succès')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}