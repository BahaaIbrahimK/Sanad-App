import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/ManageStoreScreen.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/arrange_orders_view.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/beneficiary_evaluation_view.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/profile_view.dart';
import 'package:sanad/core/Utils/signoutMessage.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم تغيير كلمة المرور بنجاح")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildChangePasswordForm(),
              ),
            ],
          ),
        ),
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
          Image.asset(
            "assets/images/logo.png",
            height: 70,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تغيير كلمة المرور",
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildPasswordField("كلمة المرور الحالية", _oldPasswordController),
            const SizedBox(height: 12),
            _buildPasswordField("كلمة المرور الجديدة", _newPasswordController),
            const SizedBox(height: 12),
            _buildPasswordField("تأكيد كلمة المرور الجديدة", _confirmPasswordController, isConfirm: true),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.cairo(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "الرجاء إدخال $label";
        }
        if (isConfirm && value != _newPasswordController.text) {
          return "كلمة المرور غير متطابقة";
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _changePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "حفظ التغييرات",
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, size: 28, color: Colors.green[700]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green[700],
      elevation: 8,
      offset: const Offset(0, 40),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem("الملف الشخصي", "profile", Icons.person),
        _buildMenuItem("تقييم الطلبات الجديده", "evaluate_accounts", Icons.account_balance_wallet),
        _buildMenuItem("طلبات المستفيدين المقبوله", "organize_shipments", Icons.receipt_long),
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
      showSignOutDialog(context);
    }
  }

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) {
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
