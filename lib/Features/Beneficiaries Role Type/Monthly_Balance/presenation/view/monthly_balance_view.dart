import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/Utils/signoutMessage.dart';
import '../../../../Moderator Role Type/Beneficiary Details/presenation/view/notifications_view.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Grocery/presenation/view/grocery_details_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Profile/presenation/view/Profile_view.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../../../Documents/presentation/view/upload_documents_view.dart';
import '../../data/Order_Model.dart';
import '../manger/balance_cubit.dart';

// Constants for reusable styles and values
const kPrimaryColor = Colors.green;
const kBackgroundColor = Color(0xFFF5F5F5);
const kCardShadow = BoxShadow(
  color: Colors.black12,
  blurRadius: 10,
  offset: Offset(0, 5),
);

class MonthlyBalanceScreen extends StatefulWidget {
  final String uid;

  const MonthlyBalanceScreen({super.key, required this.uid});

  @override
  State<MonthlyBalanceScreen> createState() => _MonthlyBalanceScreenState();
}

class _MonthlyBalanceScreenState extends State<MonthlyBalanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late BalanceCubit _balanceCubit;

  // Initialize all values to zero
  double _totalBalance = 0;
  double _remainingBalance = 0;
  double _paid = 0;
  double _animationValue = 0;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize animation with zero
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _balanceCubit = context.read<BalanceCubit>();
    _loadData();
  }

  void _loadData() async {
    await _balanceCubit.fetchOrders(widget.uid);
  }

  void _updateAnimation(double value) {
    setState(() {
      _animationValue = value;
      _animation = Tween<double>(begin: 0, end: _animationValue).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.cairo(color: Colors.white)),
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
        MaterialPageRoute(builder: (context) => routes[value]!()),
      );
    } else if (value == "signout") {
      showSignOutDialog(context);
    }
  }

  Widget _buildOrderItem(OrderModel order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [kCardShadow],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    color: kPrimaryColor[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.title,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('MM/dd/yyyy').format(order.date.toDate()),
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${order.amount} ريال",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _balanceCubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, size: 30, color: kPrimaryColor[700]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: kPrimaryColor[700],
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

  Widget _buildBody() {
    return BlocConsumer<BalanceCubit, BalanceState>(
      listener: (context, state) {
        if (state is OrdersLoaded) {
          if (_isFirstLoad) {
            _totalBalance = state.totalPrice + 1;
            _remainingBalance = _totalBalance - state.totalPrice;
            _paid = state.totalPrice;
            _updateAnimation(_totalBalance > 0 ? _paid / _totalBalance : 0);
            _isFirstLoad = false;
          }
        } else if (state is OrdersError) {
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
          child: state is OrdersLoading
              ? _buildLoadingState()
              : state is OrdersLoaded
              ? _buildSuccessState(state.totalPrice, state.orders)
              : state is OrdersError
              ? _buildErrorState(context, state.message)
              : const SizedBox(),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: _buildBalanceCardPlaceholder(),
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: _buildStatisticsRowPlaceholder(),
          ),
          const SizedBox(height: 32),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: _buildSectionTitle('طلباتك السابقة'),
          ),
          const SizedBox(height: 16),
          _buildOrdersListPlaceholder(),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'جاري التحميل...',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCardPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 150,
                    height: 28,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              Container(
                width: 70,
                height: 70,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 80, height: 14, color: Colors.grey[300]),
                  Container(width: 50, height: 14, color: Colors.grey[300]),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(width: 90, height: 14, color: Colors.grey[300]),
                        const SizedBox(height: 4),
                        Container(width: 60, height: 16, color: Colors.grey[300]),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  Expanded(
                    child: Column(
                      children: [
                        Container(width: 90, height: 14, color: Colors.grey[300]),
                        const SizedBox(height: 4),
                        Container(width: 60, height: 16, color: Colors.grey[300]),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRowPlaceholder() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Container(width: 48, height: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Container(width: 80, height: 14, color: Colors.grey[300]),
                const SizedBox(height: 4),
                Container(width: 60, height: 18, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Container(width: 48, height: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Container(width: 80, height: 14, color: Colors.grey[300]),
                const SizedBox(height: 4),
                Container(width: 60, height: 18, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersListPlaceholder() {
    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                Container(width: 48, height: 48, color: Colors.grey[300]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 100, height: 16, color: Colors.grey[300]),
                      const SizedBox(height: 4),
                      Container(width: 80, height: 14, color: Colors.grey[300]),
                    ],
                  ),
                ),
                Container(width: 60, height: 16, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    String detailedDescription;
    if (message.toLowerCase().contains('network')) {
      detailedDescription =
      'يبدو أن هناك مشكلة في الاتصال بالإنترنت. تأكد من اتصالك بالشبكة وحاول مرة أخرى.';
    } else if (message.toLowerCase().contains('server')) {
      detailedDescription =
      'عذراً، هناك مشكلة في الخادم حالياً. يرجى المحاولة مرة أخرى لاحقاً أو التواصل مع الدعم.';
    } else if (message.toLowerCase().contains('data')) {
      detailedDescription =
      'لم نتمكن من جلب البيانات المطلوبة. قد تكون هناك مشكلة في البيانات المطلوبة. حاول مرة أخرى.';
    } else {
      detailedDescription =
      'حدث خطأ غير متوقع أثناء جلب البيانات. يرجى المحاولة مرة أخرى أو التواصل مع فريق الدعم إذا استمرت المشكلة.';
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: Center(
          child: FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/error.json',
                  height: 200,
                  width: 200,
                  repeat: true,
                ),
                const SizedBox(height: 20),
                Text(
                  'عذراً، حدث خطأ!',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    detailedDescription,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<BalanceCubit>().fetchOrders(widget.uid);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: Text(
                    'إعادة المحاولة',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تواصلوا مع الدعم على: support@example.com'),
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  },
                  icon: const Icon(Icons.support_agent, color: Colors.grey),
                  label: Text(
                    'التواصل مع الدعم',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[600],
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

  Widget _buildSuccessState(double totalPrice, List<OrderModel> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        _isFirstLoad = true;
        context.read<BalanceCubit>().fetchOrders(widget.uid);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildContent(totalPrice, orders),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(double totalPrice, List<OrderModel> orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: _buildBalanceCard(totalPrice),
          ),
          const SizedBox(height: 24),
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: _buildStatisticsRow(),
          ),
          const SizedBox(height: 32),
          FadeInRight(
            duration: const Duration(milliseconds: 500),
            child: _buildSectionTitle('طلباتك السابقة'),
          ),
          const SizedBox(height: 16),
          _buildOrdersList(orders),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'لا توجد طلبات سابقة',
          style: GoogleFonts.cairo(),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return FadeInRight(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 100 * index),
          child: _buildOrderItem(orders[index]),
        );
      },
    );
  }

  Widget _buildBalanceCard(double totalPrice) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor[700]!, kPrimaryColor[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الرصيد المتبقي',
                      style: GoogleFonts.cairo(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_remainingBalance ريال',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      "assets/images/qr-code.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgressLabel(totalPrice),
                const SizedBox(height: 8),
                _buildProgressBar(),
                const SizedBox(height: 16),
                _buildBalanceDetails(totalPrice),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressLabel(double totalPrice) {
    double percentage = _totalBalance > 0 ? (_paid / _totalBalance) * 100 : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'نسبة الاستهلاك',
          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
        ),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                height: 12,
                width: MediaQuery.of(context).size.width * _animation.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceDetails(double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBalanceDetailItem('كافة ماتم ايداعه', '$_totalBalance ريال'),
        Container(width: 1, height: 40, color: Colors.white24),
        _buildBalanceDetailItem('الاستهلاك', '$totalPrice ريال'),
      ],
    );
  }

  Widget _buildBalanceDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        int orderCount = 0;
        double avgMonthly = 0;

        if (state is OrdersLoaded) {
          orderCount = state.orders.length;
          if (orderCount > 0) {
            avgMonthly = state.totalPrice / 3; // Assuming 3 months for this example
          }
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'عدد عمليات الشراء',
                '$orderCount',
                Icons.shopping_bag_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'المتوسط الشهري',
                '${avgMonthly.toStringAsFixed(0)} ريال',
                Icons.timeline,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [kCardShadow],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kPrimaryColor[700], size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kPrimaryColor[800],
        ),
      ),
    );
  }
}

class MonthlyBalanceWrapper extends StatelessWidget {
  final String uid;

  const MonthlyBalanceWrapper({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BalanceCubit(),
      child: MonthlyBalanceScreen(uid: uid),
    );
  }
}