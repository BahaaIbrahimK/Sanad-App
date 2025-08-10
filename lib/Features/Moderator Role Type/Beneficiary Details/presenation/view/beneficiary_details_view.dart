import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Profile/data/userprofile_model.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/view/profile_view.dart';
import '../../../../../core/Utils/signoutMessage.dart';
import '../manger/Orders/orders_cubit.dart';
import '../manger/Orders/orders_state.dart';
import 'ManageStoreScreen.dart';
import 'arrange_orders_view.dart';
import 'beneficiary_evaluation_view.dart';

class BeneficiaryDetailsScreen extends StatefulWidget {
  final UserProfile orderModelData;
  const BeneficiaryDetailsScreen({super.key, required this.orderModelData});

  @override
  State<BeneficiaryDetailsScreen> createState() => _BeneficiaryDetailsScreenState();
}

class _BeneficiaryDetailsScreenState extends State<BeneficiaryDetailsScreen> {
  late List<Map<String, dynamic>> documents;
  bool _isEditing = false, _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(text: widget.orderModelData.name);
  late final TextEditingController _familyCountController = TextEditingController(text: widget.orderModelData.familySize.toString());
  late final TextEditingController _incomeController = TextEditingController(text: widget.orderModelData.income);
  late final TextEditingController _housingController = TextEditingController(text: widget.orderModelData.housingDescription);

  @override
  void initState() {
    super.initState();
    documents = widget.orderModelData.documents.toList();
  }

  @override
  void dispose() {
    _nameController.dispose(); _familyCountController.dispose(); _incomeController.dispose(); _housingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<OrderCubit, OrderState>(
    listener: (context, state) {
      if (state is BeneficiaryLoaded) {
        _showSnackBar(context, 'تم تحديث الطلب بنجاح', Colors.green);
      } else if (state is BeneficiaryError) _showSnackBar(context, 'حدث خطأ: ${state.message}', Colors.red);
    },
    builder: (context, state) => Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAppBar(context),
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 25),
                      _buildProfileImage(),
                      const SizedBox(height: 25),
                      _buildEditableFields(),
                      const SizedBox(height: 25),
                      _buildDocumentsSection(),
                      const SizedBox(height: 16),
                      _buildActionButtons(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (_isLoading || state is BeneficiaryLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildHeader() => FadeInDown(
    duration: const Duration(milliseconds: 500),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Text('تفاصيل الطلب', style: GoogleFonts.cairo(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
    ),
  );

  Widget _buildProfileImage() => FadeInUp(
    duration: const Duration(milliseconds: 600),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  image: const DecorationImage(image: AssetImage('assets/images/woman.png'), fit: BoxFit.cover),
                ),
              ),
              if (_isEditing) IconButton(icon: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20), onPressed: () {}, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green[600]))),
            ],
          ),
          const SizedBox(height: 16),
          Text('صورة المستفيد', style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    ),
  );

  Widget _buildEditableFields() => Column(
    children: [
      _buildEditableField('اسم المستفيد', Icons.person_rounded, _nameController, 'الرجاء إدخال الاسم', 700),
      _buildEditableField('تعداد الأسرة', Icons.family_restroom_rounded, _familyCountController, 'الرجاء إدخال تعداد الأسرة', 800),
      _buildEditableField('الدخل الشهري', Icons.account_balance_wallet_rounded, _incomeController, 'الرجاء إدخال الدخل الشهري', 900),
      _buildEditableField('حالة السكن', Icons.home_rounded, _housingController, 'الرجاء إدخال وصف حالة السكن', 1000),
    ],
  );

  Widget _buildEditableField(String label, IconData icon, TextEditingController controller, String errorMsg, int duration) => FadeInUp(
    duration: Duration(milliseconds: duration),
    child: Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.green[600], size: 22), const SizedBox(width: 12), Text(label, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]))]),
          const SizedBox(height: 12),
          _isEditing
              ? TextFormField(controller: controller, validator: (value) => value!.isEmpty ? errorMsg : null, style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[700]), decoration: _inputDecoration())
              : Padding(padding: const EdgeInsets.only(right: 8.0), child: Text(controller.text, style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[700]))),
        ],
      ),
    ),
  );

  Widget _buildDocumentsSection() => FadeInUp(
    duration: const Duration(milliseconds: 1100),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تحميل المستندات', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: documents.map((doc) => _buildDocumentButton(context, doc["typeFile"], doc["linkFile"])).toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildDocumentButton(BuildContext context, String title, String linkFile) => GestureDetector(
    onTap: () => _downloadFile(context, title, linkFile),
    child: Container(
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[300]!, width: 1.5)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.download, color: Colors.green[600], size: 30), const SizedBox(height: 10), Text(title, style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.bold))]),
    ),
  );

  Widget _buildActionButtons(BuildContext context) => FadeInUp(
    duration: const Duration(milliseconds: 1200),
    child: Row(
      children: [
        Expanded(child: _buildActionButton('قبول الطلب', Colors.green.shade500, Icons.check_circle_rounded, () => _showApprovalDialog(context))),
        const SizedBox(width: 15),
        Expanded(child: _buildActionButton('رفض الطلب', Colors.red.shade500, Icons.cancel_rounded, () => _showRejectReasonDialog(context))),
      ],
    ),
  );

  Widget _buildActionButton(String text, Color color, IconData icon, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 22), const SizedBox(width: 10), Text(text, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
  );

  Widget _buildAppBar(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, size: 28, color: Colors.green[700]),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.green[700],
          elevation: 8,
          offset: const Offset(0, 40),
          itemBuilder: (context) => [
            _buildMenuItem("الملف الشخصي", "profile", Icons.person),
            _buildMenuItem("تقييم الطلبات الجديده", "evaluate_accounts", Icons.account_balance_wallet),
            _buildMenuItem("طلبات المستفيدين المقبوله", "organize_shipments", Icons.receipt_long),
            _buildMenuItem("ادارة المتاجر", "market", Icons.shopping_cart),
            _buildMenuItem("تسجيل الخروج", "logout", Icons.logout),
          ],
          onSelected: (value) => _handleMenuSelection(context, value),
        ),
        Image.asset("assets/images/logo.png", height: 70, fit: BoxFit.contain),
      ],
    ),
  );

  PopupMenuItem<String> _buildMenuItem(String text, String value, IconData icon) => PopupMenuItem<String>(
    value: value,
    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(text, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)), const SizedBox(width: 12), Icon(icon, color: Colors.white, size: 20)]),
  );

  void _handleMenuSelection(BuildContext context, String value) {
    final routes = {"evaluate_accounts": () => BeneficiaryEvaluationScreen(), "organize_shipments": () => ArrangeOrdersScreen(), "profile": () => ProfileScreenDetails(), "market": () => StoresManageScreen()};
    if (routes.containsKey(value)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => routes[value]!()));
    } else if (value == "logout") showSignOutDialog(context);
  }

  void _acceptOrder({required UserProfile user, required String userId, required String monthlyAmount, required String status}) {
    setState(() => _isLoading = true);
    user.status = status; user.income = monthlyAmount;
    context.read<OrderCubit>().updateBeneficiaryStatus(userId, status , monthlyAmount).then((_) => setState(() => _isLoading = false));
  }

  void _showApprovalDialog(BuildContext context) {
    final amountController = TextEditingController();
    showDialog(context: context, builder: (context) => _buildDialog(title: 'قبول الطلب', hintText: '2000 ر.س', controller: amountController, onConfirm: () {
      if (amountController.text.isNotEmpty) { Navigator.pop(context); _acceptOrder(user: widget.orderModelData, userId: widget.orderModelData.id, monthlyAmount: amountController.text, status: 'Accept'); }
      else _showSnackBar(context, 'يرجى ملء جميع الحقول', Colors.red);
    }));
  }

  void _showRejectReasonDialog(BuildContext context) {
    final notificationController = TextEditingController();
    showDialog(context: context, builder: (context) => _buildDialog(title: 'سبب رفض الطلب', hintText: 'حالة الطالب المادية لا تستدعي أي دخل اضافي!', controller: notificationController, onConfirm: () {
      if (notificationController.text.isNotEmpty) { Navigator.pop(context); _acceptOrder(user: widget.orderModelData, userId: widget.orderModelData.id, monthlyAmount: "", status: 'Reject'); }
      else _showSnackBar(context, 'يرجى ملء جميع الحقول', Colors.red);
    }));
  }

  Widget _buildDialog({required String title, required String hintText, required TextEditingController controller, required VoidCallback onConfirm}) => Directionality(
    textDirection: TextDirection.rtl,
    child: Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(title, style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]))),
            const SizedBox(height: 16),
            TextFormField(controller: controller, textAlign: TextAlign.right, style: GoogleFonts.cairo(fontSize: 16), decoration: _inputDecoration(hintText: hintText)),
            const SizedBox(height: 20),
            Row(children: [Expanded(child: _buildDialogButton('تأكيد', Colors.green.shade500, onConfirm)), const SizedBox(width: 10), Expanded(child: _buildDialogButton('إلغاء', Colors.red.shade500, () => Navigator.pop(context)))]),
          ],
        ),
      ),
    ),
  );

  Widget _buildDialogButton(String text, Color color, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    child: Text(text, style: GoogleFonts.cairo(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
  );

  Future<void> _downloadFile(BuildContext context, String title, String linkFile) async {
    setState(() => _isLoading = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$title.pdf';
      await Dio().download(linkFile, savePath);
      _showSnackBar(context, 'تم التنزيل إلى $savePath', Colors.green);
    } catch (e) {
      _showSnackBar(context, 'فشل التنزيل: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: GoogleFonts.cairo(), textAlign: TextAlign.right),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(10),
  ));

  BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]);

  InputDecoration _inputDecoration({String? hintText}) => InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.green.shade400)),
    contentPadding: const EdgeInsets.all(16),
  );
}