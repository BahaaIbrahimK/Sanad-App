import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanad/core/Utils/signoutMessage.dart';
import '../../../Donation/presenation/view/donation_view.dart';
import '../../../Previous Donations/presenation/view/Previous_Donations_view.dart';
import '../../data/User_Data_Details.dart';
import '../manger/profile_user_details_cubit.dart';

class ProfileDonorsScreen extends StatefulWidget {
   final String uid;
   const ProfileDonorsScreen({super.key, required this.uid});

  @override
  State<ProfileDonorsScreen> createState() => _ProfileDonorsScreenState();
}

class _ProfileDonorsScreenState extends State<ProfileDonorsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Map<String, TextEditingController> _controllers = {
    'fullName': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'locationTitle': TextEditingController(),
  };
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickImage() async {
    await context.read<ProfileUserDetailsCubit>().pickFile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileUserDetailsCubit()..fetchUserDetails(widget.uid),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: BlocConsumer<ProfileUserDetailsCubit, ProfileUserDetailsState>(
            listener: (context, state) {
              if (state is ProfileImagePicked) {
                setState(() {
                  _imageFile = state.imageFile;
                });
              } else if (state is ProfileImagePickCancelled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إلغاء اختيار الصورة')),
                );
              } else if (state is ProfileImagePickFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('فشل اختيار الصورة: ${state.error}')),
                );
              } else if (state is ProfileUserDetailsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                );
              } else if (state is ProfileUserDetailsLoaded && _isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تحديث الملف الشخصي بنجاح', style: GoogleFonts.cairo()),
                    backgroundColor: Colors.green[700],
                  ),
                );
                setState(() => _isEditing = false);
              }
            },
            builder: (context, state) {
              if (state is ProfileUserDetailsLoading || state is ProfileImagePicking) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF1B8E33)));
              }

              UserDetailsModel? userData;
              if (state is ProfileUserDetailsLoaded) {
                userData = state.userData;
                _controllers['fullName']?.text = userData.fullName;
                _controllers['phoneNumber']?.text = userData.phoneNumber;
                _controllers['locationTitle']?.text = userData.locationTitle;
              }

              return Stack(
                children: [
                  _buildTopGreenBackground(),
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildCustomHeader(),
                          const SizedBox(height: 10),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: _buildProfileHeader(
                              userData?.fullName ?? "فاطمة بنت عبدالله",
                              userData?.imageUrl,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 800),
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.white, Colors.green.shade50],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("معلومات الحساب", style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                                          IconButton(
                                            onPressed: () => setState(() => _isEditing = !_isEditing),
                                            icon: Icon(_isEditing ? Icons.check_circle : Icons.edit, color: Colors.green[700]),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 30, thickness: 1),
                                      ..._buildFields(),
                                      if (_isEditing && _imageFile != null) _buildImagePreview(),
                                      if (_isEditing) const SizedBox(height: 24),
                                      if (_isEditing) _buildUpdateButton(context),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopGreenBackground() => Container(
    height: 360,
    decoration: BoxDecoration(
      color: Colors.green[700],
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
    ),
  );

  Widget _buildCustomHeader() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMenuButton(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Text("الملف الشخصي", style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 8),
              Image.asset("assets/images/logo.png", height: 32),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildMenuButton() => Container(
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
    child: PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white),
      color: Colors.green[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 50),
      onSelected: (value) => _handleMenuSelection(value, context),
      itemBuilder: (_) => [
        _menuItem("الملف الشخصي", "profile", Icons.person),
        _menuItem("حالة حساب المتبرع", "donor_status", Icons.account_balance_wallet),
        _menuItem("تقارير التبرعات", "donation_reports", Icons.receipt_long),
        _menuItem("تسجيل الخروج", "logout", Icons.logout),
      ],
    ),
  );

  PopupMenuItem<String> _menuItem(String text, String value, IconData icon) => PopupMenuItem(
    value: value,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );

  void _handleMenuSelection(String value, BuildContext context) {
    final routes = {
      "profile": ProfileDonorsScreen(uid: widget.uid,),
      "donor_status":  DonationScreen(uid: widget.uid,),
      "donation_reports":  PreviousDonationsScreen(uid: widget.uid,),
    };
    if (routes.containsKey(value)) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => routes[value]!));
    } else if (value == "logout") {
      showSignOutDialog(context);
    }
  }

  Widget _buildProfileHeader(String name, String? imageUrl) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Hero(
              tag: 'profile_image',
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/user.jpg') as ImageProvider,
                backgroundColor: Colors.grey[100],
              ),
            ),
            if (_isEditing)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
                  child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Text(name, style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
        child: Text("متبرع نشط", style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    ],
  );

  List<Widget> _buildFields() => [
    _field("الاسم الكامل", _controllers['fullName']!, Icons.person_outline_rounded),
    _field("رقم الهاتف", _controllers['phoneNumber']!, Icons.phone_outlined),
    _field("عنوان الموقع", _controllers['locationTitle']!, Icons.location_on_outlined),
  ];

  Widget _field(String label, TextEditingController controller, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      enabled: _isEditing,
      style: GoogleFonts.cairo(fontSize: 16, color: Colors.green[900]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.cairo(color: Colors.green[700], fontWeight: FontWeight.w600),
        prefixIcon: Icon(icon, color: Colors.green[700]),
        suffixIcon: _isEditing ? Icon(Icons.edit, color: Colors.green[300], size: 20) : null,
        filled: true,
        fillColor: _isEditing ? Colors.white : Colors.green.shade50.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green[700]!, width: 2)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green.shade100)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    ),
  );

  Widget _buildImagePreview() => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Row(
      children: [
        Icon(Icons.image, color: Colors.green[700]),
        const SizedBox(width: 8),
        Expanded(child: Text("تم اختيار صورة: ${_imageFile!.path.split('/').last}", style: GoogleFonts.cairo())),
      ],
    ),
  );

  Widget _buildUpdateButton(BuildContext context) => Center(
    child: ElevatedButton(
      onPressed: () {
        final updatedData = {
          'fullName': _controllers['fullName']!.text,
          'phoneNumber': _controllers['phoneNumber']!.text,
          'locationTitle': _controllers['locationTitle']!.text,
          // Only include imageUrl if it exists in current state
          if (context.read<ProfileUserDetailsCubit>().state is ProfileUserDetailsLoaded)
            'imageUrl': (context.read<ProfileUserDetailsCubit>().state as ProfileUserDetailsLoaded)
                .userData
                .imageUrl ??
                '',
        };
        context.read<ProfileUserDetailsCubit>().updateUserDetails(
          updatedData,
          imageFile: _imageFile,
          uid: widget.uid,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.save_rounded, size: 20),
          const SizedBox(width: 12),
          Text('حفظ التغييرات', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

// Add this extension to UserDetailsModel if not already present
extension UserDetailsModelExtension on UserDetailsModel {
  String? get imageUrl => null; // Add this if imageUrl isn't part of your original UserDetailsModel
}