import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sanad/Features/Donors%20Role%20Type/Donation/presenation/view/donation_view.dart';
import 'package:sanad/Features/Donors%20Role%20Type/Previous%20Donations/data/Transaction.dart';
import 'package:sanad/Features/Donors%20Role%20Type/Profile/presenation/view/Profile_view.dart';
import 'package:sanad/core/Utils/signoutMessage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../manger/previous_donations_cubit.dart';

class PreviousDonationsScreen extends StatelessWidget {

  final String uid;

  const PreviousDonationsScreen({super.key, required this.uid});

  // Function to launch URL in browser
  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح الرابط: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: BlocProvider(
            create: (context) => PreviousDonationsCubit()..fetchTransactions(uid),
            child: Column(
              children: [
                _buildAppBar(context),
                _buildToggleButtons(context),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            icon: Icon(Iconsax.menu, size: 26, color: Colors.green[700]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.green[700],
            elevation: 8,
            itemBuilder: (context) => [
              _buildMenuItem("الملف الشخصي", "profile", Iconsax.profile_circle),
              _buildMenuItem("حالة حساب المتبرع", "donor_status", Iconsax.wallet),
              _buildMenuItem("تقارير التبرعات", "donation_reports", Iconsax.document),
              _buildMenuItem("تسجيل الخروج", "logout", Iconsax.logout),
            ],
            onSelected: (value) => _handleMenuSelection(context, value),
          ),
          Image.asset("assets/images/logo.png", height: 60, fit: BoxFit.contain),
          IconButton(
            icon: Icon(Iconsax.notification, size: 26, color: Colors.green[700]),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: BlocBuilder<PreviousDonationsCubit, PreviousDonationsState>(
            builder: (context, state) {
              bool showBeneficiaries = state is BeneficiariesLoaded || state is BeneficiariesLoading || state is BeneficiariesError;
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PreviousDonationsCubit>().fetchTransactions(uid);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !showBeneficiaries ? Colors.green[700] : Colors.white,
                        foregroundColor: !showBeneficiaries ? Colors.white : Colors.grey[700],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.receipt, size: 18, color: !showBeneficiaries ? Colors.white : Colors.grey[700]),
                          const SizedBox(width: 8),
                          Text('سجل التبرعات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PreviousDonationsCubit>().fetchBeneficiaries();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showBeneficiaries ? Colors.green[700] : Colors.white,
                        foregroundColor: showBeneficiaries ? Colors.white : Colors.grey[700],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.people, size: 18, color: showBeneficiaries ? Colors.white : Colors.grey[700]),
                          const SizedBox(width: 8),
                          Text('الحالات المتاحة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<PreviousDonationsCubit, PreviousDonationsState>(
      builder: (context, state) {
        if (state is BeneficiariesLoading || state is BeneficiariesLoaded || state is BeneficiariesError) {
          return _buildBeneficiariesList(context);
        }
        return Column(
          children: [
            _buildDonationStats(context),
            const SizedBox(height: 16),
            _buildSectionHeader("التبرعات السابقة"),
            Expanded(child: _buildDonationsList(context)),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Text(title, style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBeneficiariesList(BuildContext context) {
    return BlocBuilder<PreviousDonationsCubit, PreviousDonationsState>(
      builder: (context, state) {
        if (state is BeneficiariesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BeneficiariesError) {
          return Center(child: Text(state.message));
        } else if (state is BeneficiariesLoaded) {
          final beneficiaries = state.beneficiaries;
          if (beneficiaries.isEmpty) {
            return const Center(child: Text('لا توجد حالات متاحة.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: beneficiaries.length,
            itemBuilder: (context, index) {
              final beneficiary = beneficiaries[index];
              return _buildBeneficiaryCard(context, {
                'id': beneficiary.id,
                'name': beneficiary.name ?? 'غير محدد',
                'category': 'مأوى',
                'urgency': beneficiary.status == 'new' ? 'عاجل' : 'عادي',
                'needed': beneficiary.monthlyAmount ?? 0,
                'raised': 0,
                'description': beneficiary.housingDescription ?? 'لا يوجد وصف',
                'deadline': DateTime.now().add(const Duration(days: 30)),
                'icon': Iconsax.home,
                'documents': beneficiary.documents,
              });
            },
          );
        }
        return const Center(child: Text('جارٍ تحميل الحالات...'));
      },
    );
  }

  Widget _buildBeneficiaryCard(BuildContext context, Map<String, dynamic> beneficiary) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
            child: Icon(beneficiary['icon'], color: Colors.green[700]),
          ),
          title: Row(
            children: [
              Text(beneficiary['name'], style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12)),
                child: Text(
                  beneficiary['urgency'],
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: beneficiary['urgency'] == 'عاجل' ? Colors.red[700] : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(beneficiary['description'], style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text("${beneficiary['needed']} ريال", style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600])),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Iconsax.calendar, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text("متبقي: ${_getRemainingDays(beneficiary['deadline'])} يوم", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المستندات الداعمة:', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...beneficiary['documents'].map<Widget>((doc) {
                    final docName = doc['typeFile'] ?? 'وثيقة';
                    final docUrl = doc['linkFile'] as String?;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: docUrl != null ? () => _launchUrl(context, docUrl) : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.document_text, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  docName,
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    color: docUrl != null ? Colors.blue[700] : Colors.grey[600],
                                    decoration: docUrl != null ? TextDecoration.underline : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getRemainingDays(DateTime deadline) {
    return deadline.difference(DateTime.now()).inDays.clamp(0, double.infinity).toInt();
  }

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    final routes = {
      "profile": () =>  ProfileDonorsScreen(uid: uid,),
      "donor_status": () =>  DonationScreen(uid: uid,),
      "donation_reports": () =>  PreviousDonationsScreen(uid: uid,),
    };
    if (routes.containsKey(value)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => routes[value]!()));
    } else if (value == "logout") {
      showSignOutDialog(context);
    }
  }

  Widget _buildDonationStats(BuildContext context) {
    return BlocBuilder<PreviousDonationsCubit, PreviousDonationsState>(
      builder: (context, state) {
        double totalAmount = 0;
        int totalCount = 0;
        int recurringCount = 0;

        if (state is TransactionLoaded) {
          final transactions = state.transactions;
          totalAmount = transactions.fold<double>(0, (sum, t) => sum + t.amount);
          totalCount = transactions.length;
          recurringCount = transactions.where((t) => t.type == 'recurring').length;
        }

        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.green[700]!, Colors.green[600]!]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ملخص التبرعات", style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem2("إجمالي التبرعات", "${totalAmount.toStringAsFixed(2)} ريال", Iconsax.money),
                    _buildStatItem2("عدد التبرعات", "$totalCount", Iconsax.chart),
                    _buildStatItem2("تبرعات متكررة", "$recurringCount", Iconsax.repeat),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem2(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 6),
          ],
        ),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.cairo(fontSize: 12, color: Colors.white.withOpacity(0.8))),
      ],
    );
  }

  Widget _buildDonationsList(BuildContext context) {
    return BlocBuilder<PreviousDonationsCubit, PreviousDonationsState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionError) {
          return Center(child: Text(state.message));
        } else if (state is TransactionLoaded) {
          final transactions = state.transactions;
          if (transactions.isEmpty) {
            return const Center(child: Text('لا توجد تبرعات سابقة.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) => _buildDonationCard(transactions[index]),
          );
        }
        return const Center(child: Text('جارٍ تحميل البيانات...'));
      },
    );
  }

  Widget _buildDonationCard(TransactionModel transaction) {
    Color iconColor = Colors.green;
    IconData icon = Iconsax.money;
    if (transaction.type == 'top-up') {
      iconColor = Colors.blue;
      icon = Iconsax.card;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${transaction.amount} ريال", style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                          child: Text('مكتمل', style: GoogleFonts.cairo(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Iconsax.calendar, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text("2025/3/18", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[500])), // Replace with transaction.date if available
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}