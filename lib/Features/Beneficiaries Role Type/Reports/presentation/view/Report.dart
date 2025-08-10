import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Documents/presentation/view/upload_documents_view.dart';
import '../../../../../core/Utils/signoutMessage.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Profile/presenation/view/Profile_view.dart';


class ReportsScreen extends StatefulWidget {
  final String uid;

  const ReportsScreen({super.key, required this.uid});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
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
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.menu, size: 30, color: Colors.green[700]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.green[700],
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
                      onSelected: _handleMenuSelection,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 24),

                      // Documentation Cards
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: _buildDocumentationCard(
                            Colors.green,
                            '16 فبراير ٢٠٢٥'
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  void _handleMenuSelection(String value) {
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
        MaterialPageRoute(
          builder: (context) => routes[value]!(),
        ),
      );
    } else if (value == "signout") {
      showSignOutDialog(context);
    }
  }

  Widget _buildDocumentationCard(Color color, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.money_off, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "لا توجد أموال مودعة حالياً",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}