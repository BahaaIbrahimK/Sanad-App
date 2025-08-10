import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Documents/presentation/view/upload_documents_view.dart';
import 'package:sanad/core/Utils/top_snackbars.dart';

import '../../../../../Core/Utils/App Colors.dart';
import '../../../../../core/Utils/signoutMessage.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../manger/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _incomeController;
  late TextEditingController _familySizeController;
  late TextEditingController _housingDescController;
  late TextEditingController _eligibleIncomeController;

  bool _isEditing = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _incomeController = TextEditingController();
    _familySizeController = TextEditingController();
    _housingDescController = TextEditingController();
    _eligibleIncomeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _incomeController.dispose();
    _familySizeController.dispose();
    _housingDescController.dispose();
    _eligibleIncomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchUserProfile(widget.uid),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            TopSnackbars().error(context: context, message: state.message);
          } else if (state is ProfileUpdateSuccess) {
            TopSnackbars().success(
              context: context,
              message: "تم تحديث الملف الشخصي بنجاح ",
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            _nameController.text = state.profile.name.toString();
            _addressController.text = state.profile.address.toString();
            _phoneController.text = state.profile.phone.toString();
            _incomeController.text = state.profile.income.toString();
            _familySizeController.text = state.profile.familySize.toString();
            _housingDescController.text =
                state.profile.housingDescription.toString();
            _eligibleIncomeController.text = state.profile.monthlyAmount?.toString() ?? "0.00";
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(context),
                    // Content Section
                    state is ProfileLoading
                        ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColorsData.green,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "جاري تحميل البيانات...",
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: ListView(
                          children: [
                            const SizedBox(height: 16),
                            _buildProfileCard(context),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Header Section with menu and logo
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, size: 28, color: AppColorsData.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColorsData.green,
            elevation: 8,
            itemBuilder:
                (BuildContext context) => [
              _buildMenuItem("الملف الشخصي", "profile", Icons.person),
              _buildMenuItem(
                "تقييم الحالة",
                "assessment",
                Icons.assessment,
              ),
              _buildMenuItem(
                "المحفظه الماليه",
                "balance",
                Icons.account_balance_wallet,
              ),
              _buildMenuItem(
                "شركاء النجاح",
                "request_aid",
                Icons.help_outline,
              ),
              _buildMenuItem(
                "الاشعارات",
                "notification",
                Icons.notifications,
              ),
              _buildMenuItem(
                "الوثائق",
                "documents",
                Icons.file_copy_rounded,
              ),
              _buildMenuItem(
                "تقارير المساعده الشهريه",
                "reports",
                Icons.monetization_on,
              ),
              _buildMenuItem("تسجيل الخروج", "signout", Icons.logout),
            ],
            onSelected: _handleMenuSelection,
          ),
          Image.asset(
            "assets/images/logo.png",
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // Main profile card with user info and form fields
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture and Name
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColorsData.green, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/user.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _nameController.text.isEmpty
                  ? "اسم المستخدم"
                  : _nameController.text,
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Text(
                "يمكنك تعديل بياناتك الشخصية وتحديثها بسهولة",
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.green[700]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Section: Personal Information
          _buildSectionHeader("المعلومات الشخصية", Icons.person),
          const SizedBox(height: 16),
          _buildField(
            label: "عنوان السكن",
            hintText: "أدخل عنوان السكن الكامل",
            controller: _addressController,
            icon: Icons.location_on,
            validator: (value) {
              if (value == null || value.isEmpty) return 'يرجى إدخال العنوان';
              return null;
            },
          ),
          _buildField(
            label: "رقم الهاتف",
            hintText: "أدخل رقم الهاتف (10 أرقام)",
            controller: _phoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'يرجى إدخال رقم الهاتف';
              if (!RegExp(r'^\d{10,}$').hasMatch(value))
                return 'يرجى إدخال رقم هاتف صحيح';
              return null;
            },
          ),

          // Section: Financial Information
          const SizedBox(height: 24),
          _buildSectionHeader("المعلومات المالية", Icons.monetization_on),
          const SizedBox(height: 16),
          _buildField(
            label: "الدخل الشهري",
            hintText: "أدخل الدخل الشهري (بالريال)",
            controller: _incomeController,
            icon: Icons.money,
            keyboardType: TextInputType.number,
            suffixText: "ريال",
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'يرجى إدخال الدخل الشهري';
              if (double.tryParse(value) == null)
                return 'يرجى إدخال قيمة صحيحة';
              return null;
            },
          ),
          // Add the read-only الدخل المستحق field
          _buildReadOnlyField(
            label: "الدخل المستحق",
            controller: _eligibleIncomeController,
            icon: Icons.attach_money,
          ),

          // Section: Family Information
          const SizedBox(height: 24),
          _buildSectionHeader("معلومات الأسرة", Icons.family_restroom),
          const SizedBox(height: 16),
          _buildField(
            label: "عدد الأفراد",
            hintText: "أدخل عدد أفراد الأسرة",
            controller: _familySizeController,
            icon: Icons.group,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'يرجى إدخال عدد الأفراد';
              if (int.tryParse(value) == null) return 'يرجى إدخال عدد صحيح';
              return null;
            },
          ),
          _buildField(
            label: "وصف البيئة السكنية",
            hintText: "صف حالتك السكنية (نوع السكن، الحالة...)",
            controller: _housingDescController,
            icon: Icons.home,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'يرجى إدخال وصف البيئة السكنية';
              return null;
            },
          ),

          // Action Buttons
          const SizedBox(height: 30),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  // Section header with icon
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.green[700],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  // Support section at the bottom
  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.support_agent, color: Colors.blue[700], size: 24),
              const SizedBox(width: 12),
              Text(
                "الدعم الفني",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "إذا واجهت أي مشكلة في تحديث بياناتك أو في استخدام التطبيق، يرجى التواصل مع فريق الدعم الفني",
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.blue[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              // Handle support action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("جاري الاتصال بالدعم الفني..."),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: Icon(Icons.headset_mic, color: Colors.blue[700]),
            label: Text(
              "التواصل مع الدعم",
              style: GoogleFonts.cairo(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Action buttons for saving and uploading documents
  Widget _buildActionButtons(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        bool isValid = true;
                        [
                          _addressController,
                          _phoneController,
                          _incomeController,
                          _familySizeController,
                          _housingDescController,
                        ].forEach((controller) {
                          if (controller.text.isEmpty) isValid = false;
                        });

                        if (isValid) {
                          context.read<ProfileCubit>().updateUserProfile(
                            address: _addressController.text,
                            phone: _phoneController.text,
                            income: _incomeController.text,
                            familySize: _familySizeController.text,
                            housingDescription: _housingDescController.text,
                            uid: widget.uid,
                          );
                          _isEditing = false;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("يرجى ملء جميع الحقول بشكل صحيح!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        _isEditing = true;
                      }
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    size: 20,
                  ),
                  label: Text(
                    _isEditing ? 'حفظ المعلومات' : 'تعديل المعلومات',
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditing ? Colors.green : AppColorsData.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
                icon: const Icon(Icons.close, size: 18),
                label: Text(
                  "إلغاء التعديل",
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Reusable TextField widget with hint text and validation
  Widget _buildField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? suffixText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 8),
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            enabled: _isEditing,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.cairo(fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[400]),
              filled: true,
              fillColor: _isEditing ? Colors.white : Colors.grey[100],
              prefixIcon: Icon(icon, color: AppColorsData.green, size: 20),
              suffixText: suffixText,
              suffixStyle: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColorsData.green!, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  // Special read-only field for الدخل المستحق (eligibleIncome)
  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 8),
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: Colors.amber.shade800,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "للقراءة فقط",
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              enabled: false, // Always disabled, regardless of _isEditing
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.amber[800],
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.amber.shade50,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.amber.shade700,
                    size: 18,
                  ),
                ),
                suffixText: "ريال",
                suffixStyle: GoogleFonts.cairo(
                  fontSize: 15,
                  color: Colors.amber.shade900,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.amber.shade300, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable PopupMenuItem for the menu
  PopupMenuItem<String> _buildMenuItem(
      String text,
      String value,
      IconData icon,
      ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Handle menu selection
  void _handleMenuSelection(String value) {
    final routes = {
      "profile": () =>  ProfileScreen(uid: widget.uid,),
      "assessment": () => AssessmentScreen(uid: widget.uid,),
      "balance": () =>  MonthlyBalanceWrapper(uid: widget.uid,),
      "request_aid": () =>  NeedsOrdersScreen(uid: widget.uid,),
      "notification": () =>  NotificationsScreen(uid: widget.uid,),
      "reports": () =>  ReportsScreen(uid: widget.uid,),
      "documents": () =>  UploadDocumentsScreen(uid: widget.uid,),
    };

    if (routes.containsKey(value)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[value]!()),
      );
    } else if (value == "signout") {
      showSignOutDialog(context);
    }
  }
}