import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/profile_view.dart';
import 'package:sanad/core/Utils/Core%20Components.dart';

import '../../../../../../core/Utils/Shared Methods.dart';
import '../../../../../../core/Utils/signoutMessage.dart';
import '../../../../Beneficiaries Role Type/Profile/data/userprofile_model.dart';
import '../../data/order_model.dart';
import '../manger/Orders/orders_cubit.dart';
import '../manger/Orders/orders_state.dart';
import 'ManageStoreScreen.dart';
import 'beneficiary_evaluation_view.dart';
import 'order_details_view.dart';

class ArrangeOrdersScreen extends StatelessWidget {
  const ArrangeOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      OrderCubit()
        ..fetchBeneficiaries(),
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
                        return const Center(child: LoadingWidget(
                          color: Colors.green,));
                      } else if (state is BeneficiariesError) {
                        return buildErrorState(context, state.message, () {
                          context.read<OrderCubit>().fetchBeneficiaries();
                        });
                      } else if (state is BeneficiariesLoaded) {
                        final acceptedBeneficiaries = state.beneficiaries
                            .where((value) => value.status == "Accept")
                            .toList();

                        if (acceptedBeneficiaries.isEmpty) {
                          return buildEmptyState(context, () {
                            context.read<OrderCubit>().fetchBeneficiaries();
                          },);
                        }

                        return CustomScrollView(
                          slivers: [
                            _buildSearchBar(),
                            _buildOrdersList(acceptedBeneficiaries),
                          ],
                        );
                      } else {
                        return buildEmptyState(context, () {
                          context.read<OrderCubit>().fetchBeneficiaries();
                        },);
                      }
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
          (BuildContext context) =>
      [
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
      "evaluate_accounts": () => const BeneficiaryEvaluationScreen(),
      "organize_shipments": () => const ArrangeOrdersScreen(),
      "profile": () => const ProfileScreenDetails(),
      "market": () => const StoresManageScreen(),
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

  PopupMenuItem<String> _buildMenuItem(String text,
      String value,
      IconData icon,) {
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
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
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

  Widget _buildOrdersList(List<UserProfile> beneficiaries) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return FadeInUp(
            duration: Duration(milliseconds: 400 + (index * 100)),
            child: _buildEnhancedOrderCard(context, beneficiaries[index]),
          );
        }, childCount: beneficiaries.length),
      ),
    );
  }

  Widget _buildEnhancedOrderCard(BuildContext context,
      UserProfile beneficiary,) {
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
                      child: Text(
                        'صاحب الطلب: ${beneficiary.name}',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    _buildStatusBadge(
                      beneficiary.status == "Accept" ? "مقبول" : "مرفوض",
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
                              child: OrderDetailsView(
                                  orderModelData: beneficiary),
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
                          'تفاصيل الطلب',
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