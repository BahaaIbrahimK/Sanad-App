import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../../Documents/presentation/view/upload_documents_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Profile/data/userprofile_model.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../manger/beneficiary_cubit.dart';

const kPrimaryColor = Colors.green;
const kSecondaryColor = Color(0xFF388E3C); // Darker green
const kBackgroundColor = Color(0xFFF8F9FA);
const kCardColor = Colors.white;
const kCardShadow = BoxShadow(
  color: Colors.black12,
  blurRadius: 10,
  offset: Offset(0, 5),
);
const kPriceBorderColor = Color(0xFFFFD700); // Yellow color for price fields

class AssessmentScreen extends StatefulWidget {
  final String uid;

  const AssessmentScreen({super.key, required this.uid});

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeneficiaryCubit()..fetchUserData(widget.uid),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        boxShadow: [kCardShadow],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, size: 30, color: kPrimaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: kPrimaryColor,
            elevation: 8,
            itemBuilder: (BuildContext context) => [
              _buildMenuItem("الملف الشخصي", "profile", Icons.person),
              _buildMenuItem("تقييم الحالة", "assessment", Icons.assessment),
              _buildMenuItem("المحفظه الماليه", "balance", Icons.account_balance_wallet),
              _buildMenuItem("شركاء النجاح", "request_aid", Icons.help_outline),
              _buildMenuItem("الاشعارات", "notification", Icons.notifications),
              _buildMenuItem("الوثائق", "documents", Icons.file_copy_rounded),
              _buildMenuItem("تقارير المساعده الشهريه", "reports", Icons.monetization_on),
              _buildMenuItem("تسجيل الخروج", "signout", Icons.logout),
            ],
            onSelected: (value) => _handleMenuSelection(context, value),
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              Image.asset(
                "assets/images/logo.png",
                height: 60,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<BeneficiaryCubit, BeneficiaryState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state is UserLoading
              ? _buildLoadingState()
              : state is UserLoaded
              ? _buildSuccessState(context, state.user)
              : state is UserError
              ? _buildErrorState(context, state.message)
              : const SizedBox(),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(4, (_) => _buildShimmerField()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, UserProfile user) {
    // Check if user has all null/zero values for assessment fields
    final bool hasEmptyAssessment = _isEmptyOrZero(user.income) &&
        _isEmptyOrZero(user.familySize) &&
        _isEmptyOrZero(user.monthlyAmount) &&
        _isEmptyOrZero(user.housingDescription);

    if (hasEmptyAssessment) {
      return _buildEmptyAssessmentState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BeneficiaryCubit>().fetchUserData(widget.uid);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildStatusBanner(user.status ?? 'جديد'),
            const SizedBox(height: 16),
            _buildReadOnlyIndicator(),
            const SizedBox(height: 8),
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assessment, color: kSecondaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'تقييم الحالة',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      _buildModernField(
                        label: 'الاسم',
                        value: user.name,
                        icon: Icons.person_outline,
                        trailingInfo: 'معلومات شخصية',
                      ),
                      _buildModernField(
                        label: 'الدخل الشهري',
                        value: user.income,
                        icon: Icons.account_balance_wallet,
                        formatAsCurrency: true,
                        isPriceField: true,
                        trailingInfo: 'تم التحقق',
                      ),
                      _buildModernField(
                        label: 'حجم الأسرة',
                        value: user.familySize,
                        icon: Icons.group,
                        trailingInfo: 'عدد الأفراد',
                      ),
                      _buildModernField(
                        label: 'المبلغ الشهري',
                        value: user.monthlyAmount,
                        icon: Icons.money,
                        formatAsCurrency: true,
                        isPriceField: true,
                        trailingInfo: 'مبلغ المساعدة',
                      ),
                      _buildModernField(
                        label: 'وصف السكن',
                        value: user.housingDescription,
                        icon: Icons.home,
                        trailingInfo: 'معلومات السكن',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildLastUpdatedInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(String status) {
    Color bgColor;
    Color textColor;
    IconData statusIcon;
    String arabicStatus;

    // Convert English status to lowercase for case-insensitive comparison
    String statusLower = status.toLowerCase();

    // Translate English status to Arabic
    switch(statusLower) {
      case 'accept':
        arabicStatus = 'مقبول';
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        arabicStatus = 'معلق';
        bgColor = Colors.amber.shade50;
        textColor = Colors.amber.shade800;
        statusIcon = Icons.hourglass_top;
        break;
      case 'rejected':
        arabicStatus = 'مرفوض';
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        statusIcon = Icons.cancel;
        break;
      case 'new':
        arabicStatus = 'جديد';
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        statusIcon = Icons.new_releases;
        break;
      case 'processing':
        arabicStatus = 'قيد المعالجة';
        bgColor = Colors.purple.shade50;
        textColor = Colors.purple.shade800;
        statusIcon = Icons.sync;
        break;
      case 'approved':
        arabicStatus = 'تمت الموافقة';
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        statusIcon = Icons.check_circle;
        break;
      case 'on hold':
        arabicStatus = 'قيد الانتظار';
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        statusIcon = Icons.pause_circle_filled;
        break;
      default:
      // If it's already in Arabic or unknown status, use as is
        arabicStatus = status;
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        statusIcon = Icons.info;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: textColor),
          const SizedBox(width: 8),
          Text(
            'حالة الطلب: $arabicStatus',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.visibility, color: Colors.grey.shade700, size: 18),
          const SizedBox(width: 8),
          Text(
            'وضع القراءة فقط - لا يمكن التعديل',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedInfo() {
    return Center(
      child: Text(
        'آخر تحديث: ${DateTime.now().toString().substring(0, 16)}',
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: Colors.grey.shade600,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildEmptyAssessmentState(BuildContext context) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/assessment_empty.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'لم يتم تقييم الحالة بعد',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Text(
                  'سيتم تقييم حالتك قريباً من قبل فريق المختصين',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.amber.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<BeneficiaryCubit>().fetchUserData(widget.uid);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'تحديث البيانات',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/error.json',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                message,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Colors.red.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BeneficiaryCubit>().fetchUserData(widget.uid);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'إعادة المحاولة',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.cairo(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    final routes = {
      "profile": () => ProfileScreen(uid: widget.uid),
      "assessment": () => AssessmentScreen(uid: widget.uid),
      "balance": () => MonthlyBalanceWrapper(uid: widget.uid),
      "request_aid": () => NeedsOrdersScreen(uid: widget.uid),
      "notification": () => NotificationsScreen(uid: widget.uid),
      "reports": () => ReportsScreen(uid: widget.uid),
      "documents": () => UploadDocumentsScreen(uid: widget.uid),
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

  Widget _buildModernField({
    required String label,
    required dynamic value,
    required IconData icon,
    bool formatAsCurrency = false,
    bool isPriceField = false,
    required String trailingInfo,
  }) {
    final isNullOrEmpty = _isEmptyOrZero(value);
    final displayValue = isNullOrEmpty
        ? 'غير متوفر'
        : formatAsCurrency
        ? '${value.toString()} ريال سعودي'
        : value.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: kSecondaryColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isNullOrEmpty ? Colors.grey[50] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPriceField ? kPriceBorderColor : Colors.grey[300]!,
                width: isPriceField ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayValue,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: isNullOrEmpty ? Colors.grey[500] : Colors.black87,
                      fontStyle: isNullOrEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trailingInfo,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isEmptyOrZero(dynamic value) {
    if (value == null) return true;
    if (value is String && (value.isEmpty || value == '0')) return true;
    if (value is num && value == 0) return true;
    return false;
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'تسجيل الخروج',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            style: GoogleFonts.cairo(),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle sign out logic here
                Navigator.of(context).pop();
                // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تسجيل الخروج',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}