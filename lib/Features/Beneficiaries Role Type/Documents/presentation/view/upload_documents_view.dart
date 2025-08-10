import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../Core/Utils/App Colors.dart';
import '../../../../../core/Utils/top_snackbars.dart';
import '../../../Assessment/presenation/view/assessment_view.dart';
import '../../../Monthly_Balance/presenation/view/monthly_balance_view.dart';
import '../../../NeedsOrders/presenation/view/needs_orders_view.dart';
import '../../../Notifications/presentation/view/Notification.dart';
import '../../../Reports/presentation/view/Report.dart';
import '../../../Profile/data/userprofile_model.dart';
import '../../../Profile/presenation/manger/profile_cubit.dart';
import '../../../Profile/presenation/view/Profile_view.dart';

enum DocumentStatus { notUploaded, uploaded, verified, rejected }

class DocumentItem {
  final String title;
  final String description;
  final IconData icon;
  DocumentStatus status;

  DocumentItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
  });
}

class UploadDocumentsScreen extends StatelessWidget {
  final String uid;

  const UploadDocumentsScreen({super.key, required this.uid});

  static const double _defaultPadding = 16.0;
  static const double _defaultSpacing = 16.0;
  static const double _cardBorderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchUserProfile(uid),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            TopSnackbars().error(context: context, message: state.message);
          } else if (state is ProfileUpdateSuccess) {
            TopSnackbars().success(
              context: context,
              message: "تم رفع المستند بنجاح",
            );
            context.read<ProfileCubit>().fetchUserProfile(uid);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              body: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(child: _buildBody(context, state)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DocumentStatus _getDocumentStatus(String documentKey, UserProfile? userProfile) {
    if (userProfile?.documents == null) return DocumentStatus.notUploaded;

    final documents = userProfile!.documents as List<dynamic>;
    for (final document in documents) {
      if (document is Map<String, dynamic> &&
          document.containsKey("typeFile") &&
          document["typeFile"] == documentKey &&
          document["linkFile"] != null &&
          document["linkFile"].toString().isNotEmpty) {
        return DocumentStatus.uploaded;
      }
    }
    return DocumentStatus.notUploaded;
  }

  List<DocumentItem> _buildDocumentTypes(UserProfile? userProfile) {
    return [
      DocumentItem(
        title: "إثبات الدخل",
        description: "مثل كشف الراتب، إثبات معاش تقاعدي، أو أي مستند يثبت دخلك الشهري",
        icon: Iconsax.money,
        status: _getDocumentStatus("إثبات الدخل", userProfile),
      ),
      DocumentItem(
        title: "الهوية الوطنية",
        description: "صورة واضحة من الهوية الوطنية أو بطاقة الأحوال المدنية",
        icon: Iconsax.user,
        status: _getDocumentStatus("الهوية الوطنية", userProfile),
      ),
      DocumentItem(
        title: "عقد الإيجار",
        description: "نسخة من عقد الإيجار الخاص بالسكن الحالي (إن وجد)",
        icon: Iconsax.house,
        status: _getDocumentStatus("عقد الإيجار", userProfile),
      ),
      DocumentItem(
        title: "فواتير الخدمات",
        description: "فواتير الكهرباء والماء وغيرها من الخدمات الأساسية",
        icon: Iconsax.receipt,
        status: _getDocumentStatus("فواتير الخدمات", userProfile),
      ),
      DocumentItem(
        title: "تقارير طبية",
        description: "تقارير طبية تثبت وجود حالات مرضية لأحد أفراد الأسرة (إن وجدت)",
        icon: Iconsax.health,
        status: _getDocumentStatus("تقارير طبية", userProfile),
      ),
      DocumentItem(
        title: "شهادات التعليم",
        description: "شهادات دراسية للأبناء أو المعالين",
        icon: Iconsax.teacher,
        status: _getDocumentStatus("شهادات التعليم", userProfile),
      ),
      DocumentItem(
        title: "مستندات أخرى",
        description: "أي مستندات إضافية تدعم طلبك",
        icon: Iconsax.folder,
        status: _getDocumentStatus("مستندات أخرى", userProfile),
      ),
    ];
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: _defaultSpacing),
            Text(
              "جاري تحميل بيانات المستندات...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: _defaultSpacing),
            Text(
              "حدث خطأ: ${state.message}",
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _defaultSpacing),
            ElevatedButton(
              onPressed: () => context.read<ProfileCubit>().fetchUserProfile(uid),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsData.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "إعادة المحاولة",
                style: GoogleFonts.cairo(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    final userProfile = state is ProfileLoaded ? state.profile : null;
    final documentTypes = _buildDocumentTypes(userProfile);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _defaultPadding),
      child: ListView(
        children: [
          const SizedBox(height: _defaultSpacing),
          _buildInfoCard(),
          const SizedBox(height: _defaultSpacing),
          if (state is ProfileUpdating)
            const LinearProgressIndicator(color: AppColorsData.green),
          _buildDocumentsSection(context, documentTypes),
          const SizedBox(height: _defaultSpacing * 1.5),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, size: 28, color: AppColorsData.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_cardBorderRadius),
            ),
            color: AppColorsData.green,
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
            onSelected: (value) => _handleMenuSelection(context, value),
          ),
          Image.asset(
            "assets/images/logo.png",
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Iconsax.image, size: 60),
          ),
          IconButton(
            icon: Icon(Iconsax.arrow_left_2, color: AppColorsData.green),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    const routes = {
      "profile": ProfileScreen.new,
      "assessment": AssessmentScreen.new,
      "balance": MonthlyBalanceWrapper.new,
      "request_aid": NeedsOrdersScreen.new,
      "notification": NotificationsScreen.new,
      "reports": ReportsScreen.new,
      "documents": UploadDocumentsScreen.new,
    };

    if (routes.containsKey(value)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => routes[value]!(uid: uid),
        ),
      );
    } else if (value == "signout") {
      _showSignOutDialog(context);
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "تسجيل الخروج",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "هل أنت متأكد من تسجيل الخروج؟",
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "إلغاء",
              style: GoogleFonts.cairo(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text(
              "تسجيل الخروج",
              style: GoogleFonts.cairo(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(_defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColorsData.green.withOpacity(0.1),
                radius: 24,
                child: Icon(
                  Iconsax.document,
                  color: AppColorsData.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "رفع المستندات",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  Text(
                    "يمكنك رفع المستندات المطلوبة لتوثيق حالتك",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: _defaultSpacing),
          Text(
            "الرجاء رفع المستندات التالية لتوثيق حالتك والتحقق من صحة البيانات المقدمة. يمكنك رفع صور واضحة أو ملفات PDF للمستندات المطلوبة.",
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(BuildContext ctx, List<DocumentItem> documentTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            "المستندات المطلوبة",
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...documentTypes.map((doc) => _buildDocumentItem(ctx, doc)),
      ],
    );
  }

  Widget _buildDocumentItem(BuildContext ctx, DocumentItem document) {
    final (statusColor, statusIcon, statusText) = _getDocumentStatusDetails(document.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColorsData.green.withOpacity(0.1),
          child: Icon(document.icon, color: AppColorsData.green, size: 20),
        ),
        title: Text(
          document.title,
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              document.description,
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showUploadOptions(ctx, document),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsData.green,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            document.status == DocumentStatus.notUploaded ? "رفع" : "تعديل",
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  (Color, IconData, String) _getDocumentStatusDetails(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.notUploaded:
        return (Colors.grey, Icons.upload, "لم يتم الرفع");
      case DocumentStatus.uploaded:
        return (Colors.blue, Iconsax.tick_circle, "تم الرفع");
      case DocumentStatus.verified:
        return (Colors.green, Iconsax.verify, "تم التحقق");
      case DocumentStatus.rejected:
        return (Colors.red, Iconsax.close_circle, "مرفوض");
    }
  }

  void _showUploadOptions(BuildContext ctx, DocumentItem document) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final profileCubit = BlocProvider.of<ProfileCubit>(ctx); // Use parent context
        return Container(
          padding: const EdgeInsets.all(_defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "اختر طريقة رفع ${document.title}",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: _defaultSpacing),
              _buildUploadOptionTile(
                context: ctx,
                title: "التقاط صورة",
                icon: Iconsax.camera,
                isUploading: profileCubit.state is ProfileUpdating,
                onTap: () => profileCubit.pickImageFromCamera().then((_) {
                  if (profileCubit.state is ProfileFilePicked) {
                    final state = profileCubit.state as ProfileFilePicked;
                    profileCubit.uploadDocument(state.file, document.title , uid);
                  }
                }),
              ),
              _buildUploadOptionTile(
                context: ctx,
                title: "اختيار من المعرض",
                icon: Iconsax.gallery,
                isUploading: profileCubit.state is ProfileUpdating,
                onTap: () => profileCubit.pickImageFromGallery().then((_) {
                  if (profileCubit.state is ProfileFilePicked) {
                    final state = profileCubit.state as ProfileFilePicked;
                    profileCubit.uploadDocument(state.file, document.title , uid);
                  }
                }),
              ),
              _buildUploadOptionTile(
                context: ctx,
                title: "اختيار ملف",
                icon: Iconsax.document_upload,
                isUploading: profileCubit.state is ProfileUpdating,
                onTap: () {
                  Navigator.pop(context);
                  profileCubit.pickFile().then((_) {
                    if (profileCubit.state is ProfileFilePicked) {
                      final state = profileCubit.state as ProfileFilePicked;
                      profileCubit.uploadDocument(state.file, document.title , uid);
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadOptionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isUploading,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: GoogleFonts.cairo(fontSize: 14),
      ),
      trailing: isUploading ? const CircularProgressIndicator() : null,
      onTap: isUploading ? null : onTap,
    );
  }
}