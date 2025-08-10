import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/profile_view.dart';
import 'package:sanad/Features/Sign-up/presenation/view/Sign-up_view.dart';
import 'package:sanad/core/Utils/Core%20Components.dart';
import 'package:sanad/core/Utils/Shared%20Methods.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Profile/presenation/view/Profile_view.dart';
import 'package:sanad/Features/Donors%20Role%20Type/Profile/presenation/view/Profile_view.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/ManageStoreScreen.dart';
import 'package:sanad/core/Utils/top_snackbars.dart';
import '../../../../Core/Utils/App Colors.dart';
import '../manger/login_cubit.dart';
import 'forget_password_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginAuthenticated) {
                        final role = state.appUser.userType;
                        navigateAndFinished(context, switch (role) {
                          'Beneficiaries' => ProfileScreen(uid: state.appUser.uid,),
                          'Donors' => ProfileDonorsScreen(uid: state.appUser.uid,),
                          'Moderator' => ProfileScreenDetails(),
                          _ => ProfileScreen(uid: state.appUser.uid),
                        });
                      } else if (state is LoginAdminAuthenticated) {
                        navigateAndFinished(context, StoresManageScreen());
                      } else if (state is UserNotFound) {
                        TopSnackbars().error(
                          context: context,
                          message: "User Not Found",
                        );
                      } else if (state is LoginError) {

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

  Widget _buildForm(BuildContext context, LoginState state) {
    final loginCubit = context.read<LoginCubit>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/logo.png",
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextField(
              controller: _phoneController,
              hint: "رقم الهاتف",
              icon: Icons.phone,
              type: TextInputType.phone,
              validator:
                  (value) => value!.isEmpty ? "الرجاء إدخال رقم الهاتف" : null,
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextField(
              controller: _passwordController,
              hint: "كلمة المرور",
              icon: Icons.lock,
              obscure: true,
              validator:
                  (value) =>
                      value!.isEmpty
                          ? "الرجاء إدخال كلمة المرور"
                          : value.length < 6
                          ? "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل"
                          : null,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => navigateTo(context, ForgotPasswordScreen()),
              child: Text(
                "نسيت كلمة المرور؟",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColorsData.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (state is LoginLoading)
            const LoadingWidget(color: AppColorsData.green,)
          else
            SlideTransition(
              position: _slideAnimation,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final phone = _phoneController.text.trim();
                    final password = _passwordController.text.trim();
                    loginCubit.login(
                      phoneNumber: phone,
                      password: password,
                      isAdmin: phone == "01111111111" && password == "123456As",
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsData.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 40,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "تسجيل الدخول",
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
              Text("لا تملك حساب؟ ", style: GoogleFonts.cairo(fontSize: 16)),
              GestureDetector(
                onTap: () => navigateTo(context, RegisterScreen()),
                child: Text(
                  "أنشئ حساب الآن",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: AppColorsData.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      style: GoogleFonts.cairo(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
      ),
      validator: validator,
    );
  }
}
