import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Notifications/presentation/manger/notification_cubit.dart';

import '../../../../../core/Utils/signoutMessage.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Documents/presentation/view/upload_documents_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../../data/Notification_Model.dart';
import '../manger/notification_state.dart';

class NotificationsScreen extends StatefulWidget {
  final String uid;

  const NotificationsScreen({super.key, required this.uid});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late NotificationsCubit _notificationsCubit;
  bool _isRefreshing = false;

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

    // Initialize the notifications cubit
    _notificationsCubit = NotificationsCubit();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    _notificationsCubit.fetchNotifications(widget.uid);
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _isRefreshing = true;
    });

    await _notificationsCubit.fetchNotifications(widget.uid);

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationsCubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),

                // Title Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الإشعارات",
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.green[700]),
                        onPressed: _refreshNotifications,
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshNotifications,
                    color: Colors.green[700],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BlocConsumer<NotificationsCubit, NotificationsState>(
                        listener: (context, state) {
                          if (state is NotificationsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "حدث خطأ: ${state.message}",
                                  style: GoogleFonts.cairo(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is NotificationsLoading) {
                            return _buildLoadingState();
                          } else if (state is NotificationsLoaded) {
                            return _buildNotificationsList(state.notifications);
                          } else if (state is NotificationsError) {
                            return _buildErrorState(state.message);
                          } else {
                            return _buildInitialState();
                          }
                        },
                      ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
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
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green[700]),
          const SizedBox(height: 24),
          Text(
            "جاري تحميل الإشعارات...",
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            "عذراً، لم نتمكن من تحميل الإشعارات",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchNotifications,
            icon: const Icon(Icons.refresh),
            label: Text(
              "إعادة المحاولة",
              style: GoogleFonts.cairo(),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "جاري تحميل الإشعارات...",
            style: GoogleFonts.cairo(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Icon(
                Icons.notifications_off,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Text(
                "لا توجد إشعارات حالياً",
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Text(
                "سيتم إشعارك عند وجود تحديثات جديدة",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Sort by date descending to show newest first
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      itemCount: notifications.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return FadeInDown(
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: _buildSimplifiedNotificationCard(
            notification.message,
            index,
          ),
        );
      },
    );
  }

  String _formatDateSimple(DateTime date) {
    final formatter = DateFormat('d/M/yyyy', 'ar');
    return formatter.format(date);
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

  // Super simplified notification card
  Widget _buildSimplifiedNotificationCard(
      String title,
      int index,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.notifications, color: Colors.green[700], size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showNotificationFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تصفية الإشعارات",
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterOption("جميع الإشعارات", Icons.all_inbox, true),
                _buildFilterOption("الإشعارات غير المقروءة", Icons.mark_email_unread, false),
                _buildFilterOption("الوثائق", Icons.file_copy, false),
                _buildFilterOption("المدفوعات", Icons.payment, false),
                _buildFilterOption("التنبيهات", Icons.warning_amber, false),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "إلغاء",
                        style: GoogleFonts.cairo(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "تطبيق",
                        style: GoogleFonts.cairo(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.green[700] : Colors.grey[600],
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            color: isSelected ? Colors.green[700] : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.green[700])
            : null,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}