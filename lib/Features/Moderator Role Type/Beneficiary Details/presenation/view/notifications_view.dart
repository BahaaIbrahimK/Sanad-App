import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/data/Notification_Model.dart';
import '../../../../../Core/Utils/signoutMessage.dart';
import '../../../../Beneficiaries Role Type/Assessment/presenation/view/assessment_view.dart';
import '../../../../Beneficiaries Role Type/Documents/presentation/view/upload_documents_view.dart';
import '../../../../Beneficiaries Role Type/Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../../Beneficiaries Role Type/NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../../Beneficiaries Role Type/Notifications/presentation/view/Notification.dart';
import '../../../../Beneficiaries Role Type/Reports/presentation/view/Report.dart';
import '../manger/Notifications/notifications_cubit.dart';
import '../manger/Notifications/notifications_state.dart';
import '../../../../Beneficiaries Role Type/Profile/presenation/view/Profile_view.dart';


class NotificationsView extends StatelessWidget {
  final String uid;

  const NotificationsView({required this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..fetchNotifications(uid),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Column(
              children: [
                 _AppBar(uid),
                Expanded(
                  child: BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) => _buildContent(state, context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final String uid;
  const _AppBar(this.uid);

  @override
  Widget build(BuildContext context) {
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
           _Menu(uid),
          Row(
            children: [
              Text(
                'الإشعارات',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.notifications,
                size: 28,
                color: Colors.green[700],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  final String uiddata;
  const _Menu( this.uiddata);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, size: 28, color: Colors.green[700]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[700],
      elevation: 8,
      itemBuilder: (context) => [
        _buildMenuItem("الملف الشخصي", "profile", Icons.person),
        _buildMenuItem("إضافة حساب", "add_account", Icons.person_add),
        _buildMenuItem("تقييم حالات المستفيدين", "evaluate_accounts", Icons.account_balance_wallet),
        _buildMenuItem("قائمة الطلبات المقدمة", "organize_shipments", Icons.receipt_long),
        _buildMenuItem("الإشعارات", "notifications", Icons.notifications),
        const PopupMenuDivider(height: 1),
        _buildMenuItem("تسجيل الخروج", "logout", Icons.logout),
      ],
      onSelected: (value) => _handleMenuSelection(context, value ,uiddata ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildContent(NotificationsState state, BuildContext context) {
  if (state is NotificationsLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (state is NotificationsError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            style: GoogleFonts.cairo(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<NotificationsCubit>().fetchNotifications((context.widget as NotificationsView).uid),
            child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
  if (state is NotificationsEmpty || state is NotificationsInitial) {
    return _buildEmptyState();
  }
  if (state is NotificationsLoaded) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) => _buildNotificationCard(state.notifications[index], context),
    );
  }
  return const SizedBox.shrink();
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'لا توجد إشعارات جديدة',
          style: GoogleFonts.cairo(
            fontSize: 20,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _buildNotificationCard(NotificationModelData notification, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
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
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.notifications, color: Colors.green, size: 24),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              notification.message,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight:  FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            notification.message,
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(notification.timestamp),
            style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
  );
}

String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 60) {
    return 'منذ ${difference.inMinutes} دقيقة';
  }
  if (difference.inHours < 24) {
    return 'منذ ${difference.inHours} ساعة';
  }
  return 'منذ ${difference.inDays} يوم';
}

void _handleMenuSelection(BuildContext context, String value ,uid) {
  final routes = {
    "profile": () =>  ProfileScreen(uid: uid,),
    "assessment": () => AssessmentScreen(uid: uid,),
    "balance": () =>  MonthlyBalanceWrapper(uid: uid,),
    "request_aid": () =>  NeedsOrdersScreen(uid: uid,),
    "notification": () =>  NotificationsScreen(uid: uid,),
    "reports": () =>  ReportsScreen(uid: uid,),
    "documents": () =>  UploadDocumentsScreen(uid: uid,),
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

