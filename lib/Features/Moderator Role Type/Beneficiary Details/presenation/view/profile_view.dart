import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sanad/core/Utils/signoutMessage.dart';

import '../../../../../core/Utils/Core Components.dart';
import '../../../../../core/Utils/top_snackbars.dart';
import '../../../../Moderator Role Type/Beneficiary Details/presenation/manger/profile/profile_cubit.dart';
import '../../../../Moderator Role Type/Beneficiary Details/presenation/manger/profile/profile_state.dart';
import '../../data/user_model.dart';
import 'ManageStoreScreen.dart';
import 'arrange_orders_view.dart';
import 'beneficiary_evaluation_view.dart';

class ProfileScreenDetails extends StatefulWidget {
  const ProfileScreenDetails({super.key});

  @override
  _ProfileScreenDetailsState createState() => _ProfileScreenDetailsState();
}

class _ProfileScreenDetailsState extends State<ProfileScreenDetails> {
  // Editing controllers
  final Map<String, TextEditingController> _controllers = {};
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();
  final String _userId = "niSy9QiK4OPL3EQRzaxwKLtHZu53"; // Extract fixed user ID

  @override
  void initState() {
    super.initState();
    _initControllers();
    _fetchUserData();
  }

  void _initControllers() {
    // Initialize controllers
    final fieldKeys = [
      'name',
      'email',
      'phoneNumber',
      'region',
      'userType',
      'joinDate',
    ];

    for (final key in fieldKeys) {
      _controllers[key] = TextEditingController();
    }
  }

  void _fetchUserData() {
    // Fetch user data when the screen initializes
    context.read<ProfileCubit>().fetchUserData();
  }

  @override
  void dispose() {
    // Dispose controllers
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditMode) {
        _saveUserData();
      } else {
        _isEditMode = true;
      }
    });
  }

  void _saveUserData() {
    // Validate and save changes
    if (_formKey.currentState!.validate()) {
      // Get the updated data from controllers
      final updatedUser = UserModel(
        name: _controllers['name']!.text,
        email: _controllers['email']!.text,
        phoneNumber: _controllers['phoneNumber']!.text,
        region: _controllers['region']!.text,
        userType: _controllers['userType']!.text,
        joinDate: _controllers['joinDate']!.text,
        image: 'https://static.vecteezy.com/system/resources/previews/007/296/447/non_2x/user-icon-in-flat-style-person-icon-client-symbol-vector.jpg',
      );

      // Call the update method from ProfileCubit
      context.read<ProfileCubit>().updateUserData(_userId, updatedUser);
      _isEditMode = false;
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditMode = false;
      // Reset controllers to original values
      _fetchUserData();
    });
  }

  void _updateControllers(UserModel user) {
    _controllers['name']?.text = user.name;
    _controllers['email']?.text = user.email;
    _controllers['phoneNumber']?.text = user.phoneNumber;
    _controllers['region']?.text = user.region;
    _controllers['userType']?.text = user.userType;
    _controllers['joinDate']?.text = user.joinDate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          TopSnackbars().error(context: context, message: state.message);
        } else if (state is ProfileLoaded) {
          TopSnackbars().success(
            context: context,
            message: "تم تحديث الملف الشخصي بنجاح",
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          _updateControllers(state.user);
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _buildBody(state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProfileError) {
      return buildErrorState(context, state.message , (){
        context
            .read<ProfileCubit>()
            .fetchUserData();
      });
    } else {
      return _isEditMode
          ? _buildEditProfileContent()
          : _buildProfileContent(state);
    }
  }

  Widget _buildAppBar() {
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
      itemBuilder: (BuildContext context) => [
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
      "profile": () => const ProfileScreenDetails(),
      "evaluate_accounts": () => BeneficiaryEvaluationScreen(),
      "organize_shipments": () => ArrangeOrdersScreen(),
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

  Widget _buildEditProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildEditableProfileInformation(),
            const SizedBox(height: 24),
            _buildEditActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(ProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileInformation(state),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green[50],
            border: Border.all(color: Colors.green[700]!, width: 3),
          ),
          child: Center(
            child: Text(
              "Admin",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _controllers['name']?.text ?? '',
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInformation(ProfileState state) {
    if (state is ProfileLoaded) {
      return Container(
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
        child: Column(
          children: [
            _buildInfoItem('الاسم', state.user.name),
            _buildInfoItem('البريد الإلكتروني', state.user.email),
            _buildInfoItem('رقم الهاتف', state.user.phoneNumber),
            _buildInfoItem('المنطقة', state.user.region),
            _buildInfoItem('نوع المستخدم', state.user.userType),
            _buildInfoItem('تاريخ الانضمام', state.user.joinDate),
          ],
        ),
      );
    } else {
      return Container(
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
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  Widget _buildEditableProfileInformation() {
    return Container(
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
      child: Column(
        children: [
          _buildEditableField(label: 'الاسم', icon: Icons.person),
          _buildEditableField(label: 'البريد الإلكتروني', icon: Icons.email),
          _buildEditableField(label: 'رقم الهاتف', icon: Icons.phone),
          _buildEditableField(label: 'المنطقة', icon: Icons.location_on),
          _buildEditableField(label: 'نوع المستخدم', icon: Icons.people, enabled: false),
          _buildEditableField(label: 'تاريخ الانضمام', icon: Icons.calendar_today, enabled: false),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Icon(_getIconForLabel(label), color: Colors.green[700], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.cairo(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required IconData icon,
    bool enabled = true,
  }) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: TextFormField(
        controller: _controllers[_getControllerKey(label)],
    enabled: enabled,
    decoration: InputDecoration(
    prefixIcon: Icon(icon, color: Colors.green[700], size: 24),
    labelText: label,
    labelStyle: GoogleFonts.cairo(
    fontSize: 14,
    color: Colors.grey[600],
    ),
    border: InputBorder.none,
    ),
          style: GoogleFonts.cairo(fontSize: 16, color: Colors.black87),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال $label';
            }
            return null;
          },
        ),
    );
  }

  String _getControllerKey(String label) {
    final labelMap = {
      'الاسم': 'name',
      'البريد الإلكتروني': 'email',
      'رقم الهاتف': 'phoneNumber',
      'المنطقة': 'region',
      'نوع المستخدم': 'userType',
      'تاريخ الانضمام': 'joinDate',
    };
    return labelMap[label] ?? '';
  }

  IconData _getIconForLabel(String label) {
    final iconMap = {
      'الاسم': Icons.person,
      'البريد الإلكتروني': Icons.email,
      'رقم الهاتف': Icons.phone,
      'المنطقة': Icons.location_on,
      'نوع المستخدم': Icons.people,
      'تاريخ الانضمام': Icons.calendar_today,
    };
    return iconMap[label] ?? Icons.info;
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: _buildButton(
        'تعديل الملف الشخصي',
        Icons.edit,
        _toggleEditMode,
      ),
    );
  }

  Widget _buildEditActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            'حفظ التعديلات',
            Icons.save,
            _saveUserData,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            'إلغاء',
            Icons.cancel,
            _cancelEdit,
            isOutlined: true,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      String text,
      IconData icon,
      VoidCallback onPressed, {
        bool isOutlined = false,
      }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.white : Colors.green[700],
        foregroundColor: isOutlined ? Colors.green[700] : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOutlined
              ? BorderSide(color: Colors.green[700]!)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}