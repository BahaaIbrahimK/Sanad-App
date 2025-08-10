import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import 'package:sanad/Features/Donors%20Role%20Type/Donation/data/credit_card_model.dart';
import 'package:sanad/core/Utils/Core%20Components.dart';
import '../../../../../Core/Utils/signoutMessage.dart';
import '../../../Previous Donations/presenation/view/Previous_Donations_view.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../manger/donation_cubit.dart';

class DonationScreen extends StatelessWidget {
  final String uid;
  const DonationScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DonationCubit()..fetchUserDetails(uid),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFC),
          body: SafeArea(
            child: BlocConsumer<DonationCubit, DonationState>(
              listener: _handleStateChanges,
              builder: (context, state) {
                final cubit = context.read<DonationCubit>();
                return state is ProfileUserDetailsLoading ||
                        state is DonationLoading
                    ? LoadingWidget(color: Colors.green)
                    : state is ProfileUserDetailsError || state is DonationError
                    ? buildErrorState(
                      context,
                      (state is ProfileUserDetailsError
                          ? (state).error
                          : (state as DonationError).message),
                      () {
                        cubit.fetchUserDetails(uid);
                      },
                    )
                    : Column(
                      children: [
                        _buildAppBar(context),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  _buildWalletCard(cubit, context),
                                  const SizedBox(height: 24),
                                  _buildAccountDetails(cubit),
                                  const SizedBox(height: 24),
                                  SimplifiedCreditCardSection(
                                    cubit: cubit,
                                    uid: uid,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, DonationState state) {
    if (state is DonationError) {
      _showSnackBar(context, state.message, Colors.red);
    } else if (state is WalletTopUpSuccess) {
      _showSnackBar(
        context,
        "تم شحن المحفظة بنجاح",
        Colors.green[700]!,
        icon: const Icon(Iconsax.tick_circle, color: Colors.white),
      );
    } else if (state is ProfileUserDetailsError) {
      _showSnackBar(context, state.error, Colors.red);
    } else if (state is DonationLoaded) {
      _showSnackBar(context, "تم حفظ بيانات البطاقة بنجاح", Colors.green[700]!);
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    Color color, {
    Widget? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[icon, const SizedBox(width: 8)],
            Text(message, style: GoogleFonts.cairo()),
          ],
        ),
        backgroundColor: color,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMenuButton(context),
            Text(
              "المحفظة المالية",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              "assets/images/logo.png",
              height: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.menu, size: 24, color: Colors.green[700]),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green[700],
      itemBuilder:
          (_) => [
            _buildMenuItem("الملف الشخصي", "profile", Iconsax.profile_circle),
            _buildMenuItem("حالة حساب المتبرع", "donor_status", Iconsax.wallet),
            _buildMenuItem(
              "تقارير التبرعات",
              "donation_reports",
              Iconsax.chart,
            ),
            _buildMenuItem("تسجيل الخروج", "logout", Iconsax.logout),
          ],
      onSelected: (value) => _handleMenuSelection(context, value),
    );
  }

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
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.cairo(color: Colors.white)),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    final routes = {
      "profile": () => ProfileDonorsScreen(uid: uid,),
      "donor_status": () =>  DonationScreen(uid: uid,),
      "donation_reports": () => PreviousDonationsScreen(uid: uid,),
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

  Widget _buildWalletCard(DonationCubit cubit, BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[700]!, Colors.green[800]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "رصيد المحفظة",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const Icon(Iconsax.wallet_3, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "${cubit.currentWalletBalance.toStringAsFixed(2)} ريال",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showTopUpDialog(cubit, context),
              icon: const Icon(Iconsax.add, size: 18),
              label: Text(
                "   شحن المحفظة  ",
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails(DonationCubit cubit) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.profile_circle,
                    size: 24,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "معلومات الحساب",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildUserInfo(cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(DonationCubit cubit) {
    return Column(
      children: [
        _buildInfoRow(
          Iconsax.user,
          "الاسم",
          cubit.userDetailsModel?.fullName ?? "غير متوفر",
        ),
        const Divider(height: 24),
        _buildInfoRow(
          Iconsax.call,
          "رقم الجوال",
          cubit.userDetailsModel?.phoneNumber ?? "غير متوفر",
        ),
        const Divider(height: 24),
        _buildInfoRow(Iconsax.sms, "البريد الإلكتروني", "غير متوفر"),
        const Divider(height: 24),
        _buildInfoRow(
          Iconsax.location,
          "المدينة",
          cubit.userDetailsModel?.locationTitle ?? "غير متوفر",
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTopUpDialog(DonationCubit cubit, BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.wallet_add,
                      size: 24,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "شحن المحفظة",
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "المبلغ",
                      labelStyle: GoogleFonts.cairo(),
                      hintText: "أدخل المبلغ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Iconsax.money),
                      suffixText: "ريال",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children:
                        ["50", "100", "200", "600"]
                            .map(
                              (amount) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: InkWell(
                                    onTap: () => amountController.text = amount,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.green[100]!,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "$amount ريال",
                                        style: GoogleFonts.cairo(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "إلغاء",
                    style: GoogleFonts.cairo(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      cubit.topUpWallet(amount, uid);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "شحن",
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

// Simplified Credit Card Section
class SimplifiedCreditCardSection extends StatefulWidget {
  final DonationCubit cubit;
  final String uid;

  const SimplifiedCreditCardSection({
    super.key,
    required this.cubit,
    required this.uid,
  });

  @override
  State<SimplifiedCreditCardSection> createState() =>
      _SimplifiedCreditCardSectionState();
}

class _SimplifiedCreditCardSectionState
    extends State<SimplifiedCreditCardSection> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController.text = widget.cubit.creditCard?.cardNumber ?? "";
    _expiryDateController.text = widget.cubit.creditCard?.expiryDate ?? "";
    _cvvController.text = widget.cubit.creditCard?.cvv ?? "";
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Iconsax.card,
                      size: 24,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "بطاقة الائتمان",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildCreditCardVisual(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _cardNumberController,
                decoration: _buildInputDecoration(
                  "رقم البطاقة",
                  Iconsax.card,
                  "XXXX XXXX XXXX XXXX",
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator:
                    (value) =>
                        (value?.isEmpty ?? true)
                            ? "الرجاء إدخال رقم البطاقة"
                            : (value!.length != 16)
                            ? "رقم البطاقة يجب أن يكون 16 رقم"
                            : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: _buildInputDecoration(
                        "تاريخ الانتهاء",
                        Iconsax.calendar,
                        "MM/YY",
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        LengthLimitingTextInputFormatter(5),
                        _ExpiryDateInputFormatter(),
                      ],
                      validator: _validateExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: _buildInputDecoration(
                        "CVV",
                        Iconsax.lock,
                        "XXX",
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator:
                          (value) =>
                              (value?.isEmpty ?? true)
                                  ? "الرجاء إدخال CVV"
                                  : (value!.length != 3)
                                  ? "CVV يجب أن يكون 3 أرقام"
                                  : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveCreditCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "حفظ المعلومات",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCreditCard() {
    if (_formKey.currentState!.validate()) {
      widget.cubit.saveCreditCard(
        uid: widget.uid,
        creditCard: CreditCard(
          cardNumber: _cardNumberController.text,
          expiryDate: _expiryDateController.text,
          cvv: _cvvController.text,
        ),
      );
    }
  }

  Widget _buildCreditCardVisual() {
    String displayNumber = "XXXX XXXX XXXX XXXX";
    if (_cardNumberController.text.length >= 8) {
      final input = _cardNumberController.text;
      final visiblePart = input.substring(0, 8);
      displayNumber = "$visiblePart XXXXXXXX";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sanad Card",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                Iconsax.card,
                color: Colors.white.withOpacity(0.8),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            displayNumber,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CARDHOLDER",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    "####",
                    style: GoogleFonts.cairo(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EXPIRES",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    _expiryDateController.text.isEmpty
                        ? "MM/YY"
                        : _expiryDateController.text,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    IconData icon,
    String hint,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.cairo(color: Colors.grey[600]),
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال تاريخ الانتهاء";
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return "MM/YY يجب أن يكون بصيغة";
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiry = DateTime(year, month + 1);

    if (expiry.isBefore(now)) {
      return "البطاقة منتهية الصلاحية";
    }
    return null;
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (text.length == 2 && !text.contains('/')) {
      text = '$text/';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
