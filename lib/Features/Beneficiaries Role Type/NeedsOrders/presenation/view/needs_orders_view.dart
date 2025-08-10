import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/Utils/signoutMessage.dart';
import '../../../../Moderator Role Type/Beneficiary Details/presenation/view/notifications_view.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Documents/presentation/view/upload_documents_view.dart';
import '../../../Grocery/presenation/view/grocery_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Pharmacy/presenation/view/pharmacy_view.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../../../Reports/presentation/view/Report.dart';

class NeedsOrdersScreen extends StatefulWidget {
  final String uid ;

  const NeedsOrdersScreen({super.key, required this.uid});

  @override
  _NeedsOrdersScreenState createState() => _NeedsOrdersScreenState();
}

class _NeedsOrdersScreenState extends State<NeedsOrdersScreen>
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
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
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
                      height: 70,
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

                      // Main Content Card
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
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
                            children: [
                              Text(
                                'طلب الإحتياجات',
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Options Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // Pharmacy Option
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PharmacyScreen(uid: widget.uid,),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Iconsax.hospital,
                                            size: 40,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'صيدلية',
                                          style: GoogleFonts.cairo(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Grocery Option
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GroceryScreen(uid: widget.uid,),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.store,
                                            size: 40,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'بقالة',
                                          style: GoogleFonts.cairo(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
        MaterialPageRoute(
          builder: (context) => routes[value]!(),
        ),
      );
    } else if (value == "signout") {
      showSignOutDialog(context); // Call the reusable dialog function
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}