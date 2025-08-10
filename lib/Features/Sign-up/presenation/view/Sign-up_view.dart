import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/Features/Sign-up/presenation/manger/sign_up_cubit.dart';
import 'package:sanad/core/Utils/Core%20Components.dart';
import 'package:sanad/core/Utils/Shared%20Methods.dart';
import 'package:sanad/core/Utils/top_snackbars.dart';
import '../../../../Core/Utils/App Colors.dart';
import '../../../Login/presenation/view/login_view.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _formKey = GlobalKey<FormState>();
  String accountType = 'Beneficiaries'; // Default to match cubit validation
  final _fullNameController = TextEditingController();
  final _locationTitleController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fullNameController.dispose();
    _locationTitleController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: BlocConsumer<SignUpCubit, SignUpState>(
                    listener: (context, state) {
                      if (state is SignUpAuthenticated) {
                        TopSnackbars().success(
                          context: context,
                          message:
                              accountType == 'Donors'
                                  ? "تم إنشاء حساب متبرع بنجاح"
                                  : "تم إنشاء حساب مستفيد بنجاح",
                        );
                        navigateAndFinished(context, const LoginScreen());
                      } else if (state is SignUpError) {
                        TopSnackbars().error(
                          context: context,
                          message: state.message,
                        );
                      }
                    },
                    builder: (context, state) => _buildForm(context, state),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, SignUpState state) {
    final signUpCubit = context.read<SignUpCubit>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/logo.png",
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              "مرحبا بك في تطبيق سند\nيمكنك الآن الانضمام لدينا كمستفيد أو متبرع",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextField(
              label: "الإسم كاملاً :",
              icon: Icons.person_outline,
              controller: _fullNameController,
              tooltip: "أدخل اسمك الكامل",
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextField(
              label: "عنوان السكن :",
              icon: Icons.home_outlined,
              controller: _locationTitleController,
              tooltip: "أدخل عنوان سكنك",
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextField(
              label: "رقم الهاتف :",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              tooltip: "أدخل رقم هاتفك",
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextField(
              label: "كلمة المرور :",
              icon: Icons.lock_outlined,
              isPassword: true,
              controller: _passwordController,
              tooltip: "كلمة المرور يجب أن تكون على الأقل 6 أحرف",
            ),
          ),
          const SizedBox(height: 30),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "نوع الحساب :",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          'مستفيد',
                          style: GoogleFonts.cairo(fontSize: 14),
                        ),
                        value: 'Beneficiaries',
                        groupValue: accountType,
                        onChanged:
                            (value) => setState(() => accountType = value!),
                        activeColor: AppColorsData.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          'متبرع',
                          style: GoogleFonts.cairo(fontSize: 16),
                        ),
                        value: 'Donors',
                        groupValue: accountType,
                        onChanged:
                            (value) => setState(() => accountType = value!),
                        activeColor: AppColorsData.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (state is SignUpLoading)
             LoadingWidget(color: AppColorsData.green,)
          else
            SlideTransition(
              position: _slideAnimation,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signUpCubit.signUp(
                      fullName: _fullNameController.text.trim(),
                      locationTitle: _locationTitleController.text.trim(),
                      phoneNumber: _phoneNumberController.text.trim(),
                      password: _passwordController.text.trim(),
                      userType: accountType,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsData.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 50,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "أنشئ حساب",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "هل تملك حساب بالفعل؟ ",
                style: GoogleFonts.cairo(fontSize: 15),
              ),
              GestureDetector(
                onTap: () => navigateTo(context, const LoginScreen()),
                child: Text(
                  "تسجيل الدخول",
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: AppColorsData.green ,fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? "",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          style: GoogleFonts.cairo(),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            hintText: label,
            hintStyle: GoogleFonts.cairo(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى ملء هذا الحقل';
            if (isPassword && value.length < 6)
              return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
            if (keyboardType == TextInputType.phone &&
                !RegExp(r"^\+?[0-9]{10,15}$").hasMatch(value)) {
              return 'رقم الهاتف يجب أن يكون صالحًا (مثال: +1234567890)';
            }
            return null;
          },
        ),
      ),
    );
  }
}
