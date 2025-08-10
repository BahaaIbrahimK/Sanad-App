import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../Beneficiaries Role Type/Profile/data/userprofile_model.dart';
import '../manger/Orders/orders_cubit.dart';
import '../manger/Orders/orders_state.dart';

class OrderDetailsView extends StatelessWidget {
  final UserProfile orderModelData;

  const OrderDetailsView({super.key, required this.orderModelData});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: BlocConsumer<OrderCubit, OrderState>(
            listener: (context, state) => _handleState(context, state),
            builder: (context, state) => state is OrderDetailsLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(context, (state is OrderDetailsLoaded ? state.order : orderModelData)),
          ),
        ),
      ),
    );
  }

  void _handleState(BuildContext context, OrderState state) {
    final snackBar = state is OrderDetailsNotificationSent
        ? SnackBar(content: Text('تم إرسال الإشعار بنجاح', style: GoogleFonts.cairo()), backgroundColor: Colors.green)
        : state is OrderDetailsError || state is OrderDetailsNotificationError
        ? SnackBar(content: Text((state as dynamic).message, style: GoogleFonts.cairo()), backgroundColor: Colors.red)
        : null;
    if (snackBar != null) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildContent(BuildContext context, UserProfile user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildCard(_buildAppBar(context), elevation: 4),
          const SizedBox(height: 20),
          _buildCard(_buildHeader(), gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700])),
          const SizedBox(height: 25),
          _buildCard(_buildProfileImage()),
          const SizedBox(height: 25),
          ...[
            {'label': 'اسم المستفيد', 'value': user.name},
            {'label': 'تعداد الأسرة', 'value': user.familySize.toString()},
            {'label': 'الدخل الشهري', 'value': user.income},
            {'label': 'حالة السكن', 'value': user.housingDescription},
          ].map((e) => _buildInfoField(e['label']!, e['value']!)).toList(),
          const SizedBox(height: 25),
          _buildCard(_buildDocumentsSection(context, user)),
          const SizedBox(height: 30),
          _buildActionButtons(context, user),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child, {LinearGradient? gradient, double elevation = 2}) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: gradient,
      color: gradient == null ? Colors.white : null,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: Offset(0, elevation))],
    ),
    child: child,
  );

  Widget _buildAppBar(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: Icon(Icons.arrow_back, color: Colors.green[700]), onPressed: () => Navigator.pop(context)),
        Image.asset('assets/images/logo.png', height: 70),
      ],
    ),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(20),
    child: Text('تفاصيل الطلب', style: GoogleFonts.cairo(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
  );

  Widget _buildProfileImage() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.shade300, width: 3),
            image: const DecorationImage(image: AssetImage('assets/images/woman.png'), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Text('صورة المستفيد', style: GoogleFonts.cairo(color: Colors.grey[700], fontSize: 16)),
      ],
    ),
  );

  Widget _buildInfoField(String label, String value) => _buildCard(
    Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.green[600]),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: GoogleFonts.cairo(fontSize: 16))),
        ],
      ),
    ),
  );

  Widget _buildDocumentsSection(BuildContext context, UserProfile user) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('المستندات', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
        const SizedBox(height: 16),
        user.documents.isEmpty
            ? Center(child: Text('لا توجد مستندات', style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 16)))
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: user.documents.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _downloadDocument(context, user.documents[index]),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.green[600], size: 40),
                  const SizedBox(height: 8),
                  Text(user.documents[index]['typeFile'] ?? 'غير محدد',
                      style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Icon(Icons.download, color: Colors.green[600], size: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> _downloadDocument(BuildContext context, Map<String, dynamic> doc) async {
    if (!doc.containsKey('linkFile') || doc['linkFile'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('رابط الملف غير متوفر', style: GoogleFonts.cairo()), backgroundColor: Colors.red),
      );
      return;
    }

    final dio = Dio();
    final fileName = doc['typeFile'] ?? 'document_${DateTime.now().millisecondsSinceEpoch}';
    final dir = await getExternalStorageDirectory(); // For Android; use getApplicationDocumentsDirectory() for iOS if needed
    final filePath = '${dir!.path}/$fileName.pdf'; // Assuming PDF; adjust extension if needed

    try {
      await dio.download(
        doc['linkFile'],
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('جاري التحميل: $progress%', style: GoogleFonts.cairo()),
                backgroundColor: Colors.green,
                duration: const Duration(milliseconds: 500),
              ),
            );
          }
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحميل الملف: $fileName', style: GoogleFonts.cairo()), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التحميل: $e', style: GoogleFonts.cairo()), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, UserProfile user) => Row(
    children: [
      _buildButton(context, 'طلب مستندات', () => _showAddDocumentDialog(context, user)),
      const SizedBox(width: 15),
      _buildButton(context, 'إرسال إشعار', () => _showNotificationDialog(context, user)),
    ],
  );

  Widget _buildButton(BuildContext context, String label, VoidCallback onPressed) => Expanded(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
      ),
      child: Text(label, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16)),
    ),
  );

  void _showAddDocumentDialog(BuildContext ctx, UserProfile user) {
    final controller = TextEditingController();
    _showDialog(
      ctx,
      'إضافة مستند جديد',
      TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'أدخل نوع المستند (مثل: تقرير طبي)',
          hintStyle: GoogleFonts.cairo(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        textDirection: TextDirection.rtl,
      ),
          () => controller.text.isNotEmpty ? ctx.read<OrderCubit>().updateOrderDetails(user, controller.text) : null,
    );
  }

  void _showNotificationDialog(BuildContext ctx, UserProfile user) {
    final titleController = TextEditingController(text: 'تم طلب مستندات جديدة');
    _showDialog(
      ctx,
      'إرسال إشعار جديد',
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('إلى: ${user.name}', style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[700])),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'عنوان الإشعار',
              labelStyle: GoogleFonts.cairo(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
          () => titleController.text.isNotEmpty ? ctx.read<OrderCubit>().sendNotification(user.id, titleController.text) : null,
    );
  }

  void _showDialog(BuildContext ctx, String title, Widget content, VoidCallback? onConfirm) => showDialog(
    context: ctx,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: content,
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.red))),
          ElevatedButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text(onConfirm == null ? 'إضافة' : 'إرسال', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}