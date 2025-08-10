// 1. First, let's create the PharmacyState classes
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Documents/presentation/view/upload_documents_view.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Pharmacy/presenation/view/pharmacy_details_view.dart';

import '../../../../../core/Utils/Shared Methods.dart';
import '../../../../../core/Utils/signoutMessage.dart';
import '../../../../Moderator Role Type/Beneficiary Details/presenation/view/notifications_view.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../../data/pharmacy_model.dart';
import '../cubit/pharmacy_cubit.dart';

class PharmacyScreen extends StatefulWidget {
  final String uid;
  const PharmacyScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _PharmacyScreenState createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PharmacyCubit()..getPharmacies(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            "الصيدليات القريبة",
                            style: GoogleFonts.cairo(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _buildPharmacyListWithBloc(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyListWithBloc() {
    return BlocConsumer<PharmacyCubit, PharmacyState>(
      listener: (context, state) {
        if (state is PharmacyErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PharmacyLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (state is PharmacyLoadedState) {
          return _buildPharmacyList(state.pharmacies);
        } else if (state is PharmacyErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.red[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<PharmacyCubit>().getPharmacies();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "إعادة المحاولة",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildPharmacyList(List<PharmacyModel> pharmacies) {
    return ListView.separated(
      itemCount: pharmacies.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pharmacy = pharmacies[index];
        return FadeInLeft(
          duration: Duration(milliseconds: 300 + (index * 50)),
          child: _buildPharmacyCard(pharmacy),
        );
      },
    );
  }

  Widget _buildPharmacyCard(PharmacyModel pharmacy) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                 "https://img.freepik.com/premium-vector/clean-green-pharmacy-logo-with-snake-pharmacist-tool-with-wing-symbol-drug-logo_588166-342.jpg",
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    // Fallback to asset image if network image fails
                    return Image.asset(
                      "assets/images/panadol.jpg",
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Iconsax.image, size: 70, color: Colors.grey);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    Text(
                      pharmacy.locationTitle,
                      style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.location_on_sharp, color: Colors.green, size: 32),
                onPressed: () {
                  navigateTo(
                    context,
                    PharmacyDetailsView(pharmacy: pharmacy),
                  );                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
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
    );
  }

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.cairo(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
