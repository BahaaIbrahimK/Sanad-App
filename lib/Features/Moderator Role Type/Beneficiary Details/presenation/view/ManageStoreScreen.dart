import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanad/core/Utils/Core%20Components.dart';

import '../../../../../core/Utils/signoutMessage.dart';
import '../../data/store_model.dart';
import '../manger/Stores/stores_manage_cubit.dart';
import '../manger/Stores/stores_manage_state.dart';
import 'arrange_orders_view.dart';
import 'beneficiary_evaluation_view.dart';
import 'profile_view.dart';

class StoresManageScreen extends StatefulWidget {
  final StoreModel? storeToEdit; // Add this parameter to support editing mode

  const StoresManageScreen({super.key, this.storeToEdit});

  @override
  State<StoresManageScreen> createState() => _StoresManageScreenState();
}

class _StoresManageScreenState extends State<StoresManageScreen> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeLocationController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool isEditMode = false;

  // Global variables for image handling
  File? storeImage;
  String? imageUrl;

  // Store type options
  final List<String> _storeTypes = ['بقاله', 'صيدليه'];
  String? selectedStoreType; // Track selected store type

  @override
  void initState() {
    super.initState();
    // Initialize fields if in edit mode
    if (widget.storeToEdit != null) {
      isEditMode = true;
      _storeNameController.text = widget.storeToEdit!.storeName;
      _storeLocationController.text = widget.storeToEdit!.storeLocation;
      imageUrl = widget.storeToEdit!.imageUrl; // Initialize imageUrl if editing
      selectedStoreType = widget.storeToEdit!.storeType; // Initialize store type
    } else {
      selectedStoreType = _storeTypes.first; // Default store type
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoresManageCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: BlocConsumer<StoresManageCubit, StoresManageState>(
                    listener: (context, state) {
                      if (state is StoresManageError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      if (state is StoresManageAddStoreSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Store added successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Clear text fields after successful store addition
                        _storeNameController.clear();
                        _storeLocationController.clear();

                        // Go back if in edit mode
                        if (isEditMode) {
                          Navigator.pop(context);
                        }
                      }

                      if (state is StoresManageImageReplacedSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildAppBar(),
                          const SizedBox(height: 20),
                          _buildImagePicker(context, state),
                          const SizedBox(height: 20),
                          _buildEditableField(
                            'اسم المتجر',
                            Icons.storefront_rounded,
                            _storeNameController,
                            'الرجاء إدخال اسم المتجر',
                          ),
                          _buildEditableField(
                            'الموقع',
                            Icons.location_on_rounded,
                            _storeLocationController,
                            'الرجاء إدخال موقع المتجر',
                          ),
                          _buildStoreTypeSelection(context, state),
                          const SizedBox(height: 20),
                          _buildAddStoreButton(context, state),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, StoresManageState state) {
    // Update image if a new one is picked
    if (state is StoresManageImagePickedSuccess) {
      storeImage = state.image;
      imageUrl = state.imageUrl;
    } else if (state is StoresManageImageReplacedSuccess) {
      imageUrl = state.newImageUrl;
    }

    return GestureDetector(
      onTap: () {
        if (isEditMode && widget.storeToEdit?.id != null) {
          // If in edit mode, call pickAndReplaceImage instead
          context.read<StoresManageCubit>().pickAndReplaceImage(widget.storeToEdit!.id!);
        } else {
          // Otherwise, just pick an image
          context.read<StoresManageCubit>().pickImage();
        }
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade500, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: (storeImage != null || imageUrl != null)
                      ? DecorationImage(
                    image: kIsWeb || imageUrl != null
                        ? NetworkImage(imageUrl!)
                        : FileImage(storeImage!) as ImageProvider,
                    fit: BoxFit.cover,
                  )
                      : null, // No default image
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    if (isEditMode && widget.storeToEdit?.id != null) {
                      context.read<StoresManageCubit>().pickAndReplaceImage(widget.storeToEdit!.id!);
                    } else {
                      context.read<StoresManageCubit>().pickImage();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isEditMode ? 'اضغط لتغيير صورة المتجر' : 'اضغط لاختيار صورة المتجر',
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreTypeSelection(BuildContext context, StoresManageState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: Colors.green[600], size: 22),
              const SizedBox(width: 12),
              Text(
                'نوع المتجر',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: _storeTypes.map((type) {
              return RadioListTile<String>(
                title: Text(
                  type,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                value: type,
                groupValue: selectedStoreType,
                onChanged: (value) {
                  setState(() {
                    selectedStoreType = value; // Update selected store type
                  });
                },
                activeColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStoreButton(BuildContext context, StoresManageState state) {
    return SizedBox(
      width: double.infinity,
      child: state is StoresManageLoading || state is StoresManageImagePickedLoading
          ? LoadingWidget(color: Colors.green,)
          :ElevatedButton(
        onPressed:  () async {
          if (_formKey.currentState!.validate()) {
            // Upload image to ImgBB if an image is selected
            if (storeImage != null && !kIsWeb && imageUrl == null) {
              try {
                imageUrl = await context
                    .read<StoresManageCubit>()
                    .uploadImageToImgBB(storeImage!);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل تحميل الصورة: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            }

            if (isEditMode && widget.storeToEdit?.id != null) {
              // If in edit mode, update the store
              final updatedStore = StoreModel(
                id: widget.storeToEdit!.id,
                storeName: _storeNameController.text,
                storeLocation: _storeLocationController.text,
                storeType: selectedStoreType ?? 'بقاله',
                imageUrl: imageUrl,
              );

              context.read<StoresManageCubit>().updateStore(updatedStore);
            } else {
              // Otherwise add new store
              context.read<StoresManageCubit>().addStore(
                storeName: _storeNameController.text,
                storeLocation: _storeLocationController.text,
                storeType: selectedStoreType ?? 'بقاله',
                storeImage: imageUrl,
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade500,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        child: state is StoresManageLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          isEditMode ? 'تحديث المتجر' : 'إضافة المتجر',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildEditableField(
      String label,
      IconData icon,
      TextEditingController controller,
      String validationMessage,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green[600], size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[700]),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              contentPadding: const EdgeInsets.all(16),
              hintText: 'أدخل $label',
              hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validationMessage;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMenu(),
          Text(
            isEditMode ? "تعديل متجر" : "اضافة متجر جديد",
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Image.asset(
            "assets/images/logo.png",
            height: 70,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, size: 28, color: Colors.green[700]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[700],
      elevation: 8,
      offset: const Offset(0, 40),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem("الملف الشخصي", "profile", Icons.person),
        _buildMenuItem(
          "تقييم الطلبات الجديده",
          "evaluate_accounts",
          Icons.account_balance_wallet,
        ),
        _buildMenuItem(
          "طلبات المستفيدين المقبوله",
          "organize_shipments",
          Icons.receipt_long,
        ),
        _buildMenuItem("ادارة المتاجر", "market", Icons.shopping_cart),
        _buildMenuItem("تسجيل الخروج", "logout", Icons.logout),
      ],
      onSelected: (value) => _handleMenuSelection(context, value),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    final routes = {
      "evaluate_accounts": () => BeneficiaryEvaluationScreen(),
      "organize_shipments": () => ArrangeOrdersScreen(),
      "profile": () => ProfileScreenDetails(),
      "market": () => StoresManageScreen(),
    };

    if (routes.containsKey(value)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[value]!()),
      );
    } else if (value == "logout") {
      showSignOutDialog(context); // Call the reusable dialog function
    }
  }

  PopupMenuItem<String> _buildMenuItem(
      String text,
      String value,
      IconData icon,
      ) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              text,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }


}