import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/ManageStoreScreen.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/arrange_orders_view.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/profile_view.dart';
import 'package:sanad/core/Utils/Shared%20Methods.dart';
import 'package:sanad/core/Utils/signoutMessage.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/beneficiary_details_view.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/data/order_model.dart';
import '../../../../../core/Utils/Core Components.dart';
import '../../../../Beneficiaries Role Type/Profile/data/userprofile_model.dart';
import '../manger/Orders/orders_cubit.dart';
import '../manger/Orders/orders_state.dart';

class BeneficiaryEvaluationScreen extends StatelessWidget {
  const BeneficiaryEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..fetchBeneficiaries(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      if (state is BeneficiariesLoading) {
                        return Center(child: LoadingWidget(color: Colors.green,));
                      } else if (state is BeneficiariesError) {
                        return buildErrorState(context, state.message, () {
                          context.read<OrderCubit>().fetchBeneficiaries();
                        });
                      } else if (state is OrderEmpty) {
                        return _buildEmptyState(context);
                      } else if (state is BeneficiariesLoaded) {
                        final newBeneficiaries = state.beneficiaries
                            .where((beneficiary) => beneficiary.status == "new")
                            .toList();

                        if (newBeneficiaries.isEmpty) {
                          return buildEmptyState(context ,  () {
                            context.read<OrderCubit>().fetchBeneficiaries();
                          },);                        }

                        return CustomScrollView(
                          slivers: [
                            _buildSearchBar(),
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    final beneficiary = newBeneficiaries[index];
                                    return FadeInUp(
                                      duration: Duration(
                                        milliseconds: 400 + (index * 100),
                                      ),
                                      child: _buildEnhancedBeneficiaryCard(
                                        context,
                                        beneficiary,
                                      ),
                                    );
                                  },
                                  childCount: newBeneficiaries.length,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(child: Text('Unknown state.'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  "assets/animations/no_orders.json",
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'لا يوجد طلبات حالياً',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'لم يتم العثور على طلبات مستفيدين مقبولة في النظام حالياً',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<OrderCubit>().fetchBeneficiaries();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'تحديث',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
          _buildMenu(context),
          Image.asset(
            "assets/images/logo.png",
            height: 70,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, size: 28, color: Colors.green[700]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[700],
      elevation: 8,
      offset: const Offset(0, 40),
      itemBuilder:
          (BuildContext context) => [
        _buildMenuItem("الملف الشخصي", "profile", Icons.person),
        _buildMenuItem(
          "تقييم الطلبات الجديده",
          "evaluate_accounts",
          Icons.account_balance_wallet,
        ),
        _buildMenuItem(
          "طلبات المستفيدين المقبوله",
          "organize_shipments",
          Icons.receipt_long,
        ),
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

  PopupMenuItem<String> _buildMenuItem(
      String text,
      String value,
      IconData icon,
      ) {
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

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'البحث عن طلب...',
                hintStyle: GoogleFonts.cairo(color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedBeneficiaryCard(
      BuildContext context,
      UserProfile beneficiary,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            beneficiary.name,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'عدد أفراد العائلة: ${beneficiary.familySize} أشخاص',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(
                      beneficiary.status == "new" ? "جديد" : "مقبول",
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          navigateTo(
                            context,
                            BlocProvider.value(
                              value: context.read<OrderCubit>(),
                              child: BeneficiaryDetailsScreen(
                                orderModelData: beneficiary,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'تفاصيل الحالة',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Text(
        status,
        style: GoogleFonts.cairo(
          color: Colors.green[700],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}