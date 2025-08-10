import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Documents/presentation/view/upload_documents_view.dart';
import 'package:sanad/core/Utils/Shared%20Methods.dart';
import '../../../../../core/Utils/signoutMessage.dart';
import '../../../../Moderator Role Type/Beneficiary Details/presenation/view/notifications_view.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../../data/grocery_model.dart';
import '../manger/grocery_cubit.dart';
import 'grocery_details_view.dart';

class GroceryScreen extends StatefulWidget {
  final String uid;
  const GroceryScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _GroceryScreenState createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen>
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
    // Wrap the Scaffold with BlocProvider
    return BlocProvider(
      create: (context) => GroceryCubit()..fetchGroceries(), // Create and immediately fetch data
      child: _buildGroceryScreenContent(),
    );
  }

  Widget _buildGroceryScreenContent() {
    return Directionality(
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
                          "الأسواق و البقالات القريبة",
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildGroceryListWithBloc(),
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
            icon: Icon(Iconsax.menu, size: 30, color: Colors.green[700]),
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

  Widget _buildGroceryListWithBloc() {
    return BlocBuilder<GroceryCubit, GroceryState>(
      builder: (context, state) {
        if (state is GroceryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (state is GroceryLoaded) {
          final groceries = state.groceries;
          return _buildGroceryList(groceries);
        } else if (state is GroceryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  "حدث خطأ أثناء تحميل البيانات",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<GroceryCubit>().fetchGroceries();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    "إعادة المحاولة",
                    style: GoogleFonts.cairo(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text("لا توجد بيانات متاحة"),
        );
      },
    );
  }

  Widget _buildGroceryList(List<GroceryModel> groceries) {
    if (groceries.isEmpty) {
      return Center(
        child: Text(
          "لا توجد أسواق متاحة حالياً",
          style: GoogleFonts.cairo(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: groceries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final grocery = groceries[index];
        return FadeInLeft(
          duration: Duration(milliseconds: 300 + (index * 50)),
          child: _buildGroceryCard(grocery),
        );
      },
    );
  }

  Widget _buildGroceryCard(GroceryModel grocery) {
    return GestureDetector(
      onTap: () {
        // Handle tap action
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
                  "data:image/jpeg;base64,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",
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    // Handle image loading errors
                    return const Icon(Iconsax.image, size: 70, color: Colors.grey);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grocery.title,
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    Text(
                      grocery.locationTitle,
                      style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.location_on_sharp, color: Colors.green, size: 32),
                onPressed: () {
                  navigateTo(context, GroceryDetailsView(grocery: grocery,));
                },
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