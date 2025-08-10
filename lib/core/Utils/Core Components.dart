import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math show sin, pi;
import '../Utils/App Textstyle.dart';
import 'package:flutter/animation.dart';
import 'App Colors.dart';
import 'Responsive.dart';


Widget buildEmptyState(BuildContext context ,  void Function()? onPressed) {
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
              onPressed: onPressed,
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

// Enhanced Error State with Detailed Arabic Description
Widget buildErrorState(BuildContext context, String message ,void Function()? onPressed) {
  // Customize the description based on the error message
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
              // Lottie Animation for Error
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
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
                  // Add logic to navigate to a support page or show a contact dialog
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


class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomFilterChip({
  super.key,
  required this.label,
  required this.selected,
  required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: selected?
            BorderSide.none : const BorderSide(
              width: 1,
              color:  Colors.grey,

            )
        ),
        color:  selected ?AppColorsData.greenYellow  :Colors.white,

        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                    color:
                    selected ?Colors.white  : Colors.grey.shade500,
                    height: 0.9,
                    fontSize: selected ? 14 : 12,
                    fontWeight: selected ? null :FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  const CustomCard({
  super.key,
  required this.child,
  this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  this.color = Colors.grey,
  this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: padding,
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String svgAsset;
  final String? title;
  final String? body;

  const MessageCard({
  super.key,
  required this.svgAsset,
  this.title,
  this.body,
  }) : assert(title != null || body != null);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 24,
      ),
      color: Colors.grey.shade200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: CircleAvatar(
            backgroundColor: AppColorsData.primaryColor,
            radius: 28,
            child: Center(child: Icon(Icons.warning , color: AppColorsData.white, size: 25,)),
          )),
          const SizedBox(width: 16),

          Expanded(
            flex: 4,
            child: Column(
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (title != null && body != null) const SizedBox(height: 8),
                if (body != null)
                  Text(
                    body!,
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ShadowButton extends StatelessWidget {
  const ShadowButton(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.child,
      this.width,
      this.height,
      this.borderColor});

  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final double? height;
  final double? width;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: MediaQueryHelper.sizeFromHeight(context, 150),
            left: MediaQueryHelper.sizeFromWidth(context, 70),
          ),
          child: Container(
            height: height ?? MediaQueryHelper.sizeFromHeight(context, 16),
            width: width ?? MediaQueryHelper.sizeFromWidth(context, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
          ),
        ),
        MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: height,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side:
                  BorderSide(color: borderColor ?? AppColorsData.red, width: 2.5)),
          child: child,
        ),
      ],
    );
  }
}

class MyIconButton extends StatelessWidget {
  const MyIconButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.height,
      this.width});

  final Widget child;
  final VoidCallback onPressed;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
            BoxShadow(
                blurRadius: 6,
                spreadRadius: 1.5,
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(.25))
          ]),
          child: MaterialButton(
            onPressed: onPressed,
            elevation: 8,
            height: height,
            minWidth: width,
            padding: EdgeInsets.zero,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: child,
          ),
        ),
      ],
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .5,
      width: MediaQueryHelper.sizeFromWidth(context, 1),
      color: Colors.grey.withOpacity(.5),
    );
  }
}

class CloseComponent extends StatelessWidget {
  const CloseComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.close,
        size: 28,
        color: Colors.black,
      ),
    );
  }
}

////////////////////////
bool validatePassword(String value) {
  RegExp regex =
      RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()\-=+{};:,<.>]).*$');
  return regex.hasMatch(value);
}

bool containsOnlyDigits(String input) {
  RegExp digitRegExp = RegExp(r'^[0-9]+$');
  return digitRegExp.hasMatch(input);
}

// Define regular expressions for validation
final RegExp accountNameRegex = RegExp(r'^[A-Za-z\s]+$');
final RegExp bankNameRegex = RegExp(r'^[A-Za-z\s]+$');
final RegExp accountNumberRegex = RegExp(
    r'^\d{10}$'); // You can adjust the pattern to your specific account number format
final RegExp ibanRegex = RegExp(
    r'^[A-Z]{2}\d{2}[A-Z0-9]{4}\d{7}([A-Z0-9]?){0,16}$'); // You can adjust the IBAN pattern as needed

class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ButtonTemplate extends StatelessWidget {
  ButtonTemplate({
    Key? key,
    required this.color,
    this.isLoading = false,
    this.colorText = AppColorsData.primaryColor,
    required this.text1,
    required this.onPressed,
    this.icon,
    this.width = 318,
    this.minheight = 60,
    this.fontSize = 18,
    this.borderRadius = 15
  }) : super(key: key);
  Color color;
  Color colorText;
  String text1;
  final bool isLoading;
  double width;
  double borderRadius;
  double minheight;
  double fontSize;
  IconData? icon;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: minheight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? SizedBox()
                  : Center(
                      child: Icon(icon, size: 21, color: AppColorsData.white),
                    ),
              SizedBox(
                width: 5,
              ),
              isLoading
                  ? const LoadingWidget(
                      type: LoadingType.threeBounce,
                      color: AppColorsData.white,
                      size: 18,
                    )
                  : Center(
                      child: Text(text1,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w600
                              .copyWith(color: colorText, fontSize: fontSize ,
                          fontWeight: FontWeight.w700
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String img;
  final String txt1;
  final String txt2;
  final bool button;
  String? buttonText;
  dynamic function;
  bool? isBackground;
  IconData? iconData;
  EmptyWidget(
      {super.key,
        this.buttonText = "No Button Text",
        required this.img,
        required this.txt1,
        required this.txt2,
        required this.function,
        this.iconData,
        this.isBackground = false,
        required this.button});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom:MediaQueryHelper.sizeFromHeight(context, 28)),
      child: SizedBox(
        width: MediaQueryHelper.sizeFromWidth(context, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isBackground == true
                ? Container(
                padding: const EdgeInsets.all(20.0),

                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColorsData.primaryColor),
                child: Icon(
                  iconData ?? Icons.credit_card,
                  color: Colors.white,
                  size: 35,
                ))
                : Expanded(
              flex: 5,
              child: Image(
                  width: MediaQueryHelper.sizeFromWidth(context, 1.1),
                  image: AssetImage(img.toString()),
                  fit: BoxFit.contain),
            ),
            isBackground == true
                ? SizedBox(
              height: MediaQueryHelper.sizeFromHeight(context, 30),
            )
                : Container(),
            SizedBox(
        width: MediaQueryHelper.sizeFromWidth(context, 1),
              child: Center(
                child: Text(
                  txt1.toString(),
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: MediaQueryHelper.sizeFromHeight(context, 80),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQueryHelper.sizeFromHeight(context, 100),),
              child: SizedBox(
                width: MediaQueryHelper.sizeFromWidth(context, 1.1),
                child: Center(
                  child: Text(txt2.toString(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: AppTextStyles.lrTitles.copyWith(fontSize: 13)),
                ),
              ),
            ),
            button == true
                ? Expanded(
              flex: 2,
              child: Center(
                child: SizedBox(
                  height: MediaQueryHelper.sizeFromHeight(context, 17.5),
                  width: MediaQueryHelper.sizeFromWidth(context, 1.2),
                  child: ShadowButton(
                    onPressed: function,
                    color: AppColorsData.primaryColor,
                    width: MediaQueryHelper.sizeFromWidth(context, 1),
                    child: Text(
                      buttonText.toString(),
                      style: AppTextStyles.w700.copyWith(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}


enum LoadingType {
  threeBounce,
  doubleBounce,
}

class LoadingWidget extends StatelessWidget {
  final LoadingType type;
  final Color color;
  final double size;

  const LoadingWidget({
    super.key,
    this.type = LoadingType.doubleBounce,
    this.color = AppColorsData.greenYellow,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      LoadingType.threeBounce => SpinKitThreeBounce(
          color: color,
          size: size,
        ),
      LoadingType.doubleBounce => SpinKitDoubleBounce(
          color: color,
          size: size,
        ),
    };
  }
}

class SpinKitDoubleBounce extends StatefulWidget {
  const SpinKitDoubleBounce({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2000),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitDoubleBounce> createState() => _SpinKitDoubleBounceState();
}

class _SpinKitDoubleBounceState extends State<SpinKitDoubleBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat(reverse: true);
    _animation = Tween(begin: -1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: List.generate(2, (i) {
          return Transform.scale(
            scale: (1.0 - i - _animation.value.abs()).abs(),
            child: SizedBox.fromSize(
                size: Size.square(widget.size), child: _itemBuilder(i)),
          );
        }),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: widget.color!.withOpacity(0.6)));
}

class SpinKitThreeBounce extends StatefulWidget {
  const SpinKitThreeBounce({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitThreeBounce> createState() => _SpinKitThreeBounceState();
}

class _SpinKitThreeBounceState extends State<SpinKitThreeBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(begin: 0.0, end: 1.0, delay: i * .2)
                  .animate(_controller),
              child: SizedBox.fromSize(
                  size: Size.square(widget.size * 0.5), child: _itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class TextFieldTemplate extends StatefulWidget {
  final String name;
  final String titel;
  final String? initialValue;
  final String? label;
  TextEditingController? textEditingController;
  final IconData? leadingIcon;
  final TextInputType inputType;
  final bool enableFocusBorder;
  bool boolleadingIcon;

  final Color? leadingIconColor;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String?)? onChanged;

  TextFieldTemplate({
    super.key,
    required this.name,
    this.titel = "",
    this.initialValue,
    this.label,
    this.textEditingController,
    this.leadingIcon,
    this.inputType = TextInputType.text,
    this.enableFocusBorder = true,
    this.leadingIconColor,
    this.maxLines = 1,
    this.validator,
    this.enabled = true,
    this.onChanged,
    this.boolleadingIcon = false,
  });

  @override
  State<TextFieldTemplate> createState() => _TextFieldTemplateState();
}

class _TextFieldTemplateState extends State<TextFieldTemplate> {
  final focusNode = FocusNode();
  late bool _isObscure;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {});
    });

    _isObscure = widget.inputType == TextInputType.visiblePassword;
  }

  void _toggleObscure() => setState(() => _isObscure = !_isObscure);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titel,
          style: AppTextStyles.w600.copyWith(fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        FormBuilderField<String>(
          name: widget.name,
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          builder: (field) {
            final isEmpty = field.value?.isEmpty ?? true;
            return CustomInputDecorator(
              disableTapRippleEffect: true,
              onTap: () => focusNode.requestFocus(),

              focused: focusNode.hasFocus && widget.enableFocusBorder,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),

              // leadingIcon: widget.leadingIcon,
              leadingIconColor: widget.leadingIconColor ??
                  (isEmpty
                      ? AppColorsData.black.withOpacity(0.40)
                      : AppColorsData.black),
              body: TextFormField(
                enabled: widget.enabled,
                initialValue: widget.initialValue,
                focusNode: focusNode,
                onChanged: field.didChange,
                // validator: widget.validator,
                maxLines: widget.maxLines,
                keyboardType: widget.inputType,
                obscureText:
                    widget.inputType == TextInputType.visiblePassword &&
                        _isObscure,
                style: const TextStyle(
                  color: AppColorsData.black,
                  fontSize: 14,
                  height: 1,
                ),
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: widget.label,
                  hintStyle: const TextStyle(
                    color: AppColorsData.darkGrey,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
              trailing: widget.boolleadingIcon == true
                  ? Icon(
                      widget.leadingIcon,
                      size: 24,
                    )
                  : widget.inputType == TextInputType.visiblePassword
                      ? InkResponse(
                          onTap: _toggleObscure,
                          child: Icon(
                            _isObscure ? Iconsax.eye_slash : Iconsax.eye,
                            size: 24,
                          ),
                        )
                      : null,
            );
          },
        ),
      ],
    );
  }
}

class CustomInputDecorator extends StatelessWidget {
  final Widget body;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color leadingIconColor;
  final bool focused;
  final EdgeInsets padding;
  final bool disableTapRippleEffect;

  const CustomInputDecorator({
    super.key,
    required this.body,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.leadingIconColor = AppColorsData.black,
    this.focused = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.disableTapRippleEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: AppColorsData.white,
      child: InkWell(
        onTap: onTap,
        overlayColor: disableTapRippleEffect
            ? MaterialStateColor.resolveWith(
                (states) => Colors.transparent,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColorsData.mediumGrey,
                width: 1,
                strokeAlign: 1,
              )),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  color: leadingIconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(child: body),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TextInputd extends StatefulWidget {
  final String name;
  final String? initialValue;
  final String? label;
  TextEditingController? textEditingController;
  final IconData? leadingIcon;
  final TextInputType inputType;
  final bool enableFocusBorder;
  final Color? leadingIconColor;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String?)? onChanged;

  TextInputd({
    super.key,
    required this.name,
    this.initialValue,
    this.label,
    this.textEditingController,
    this.leadingIcon,
    this.inputType = TextInputType.text,
    this.enableFocusBorder = true,
    this.leadingIconColor,
    this.maxLines = 1,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<TextInputd> createState() => _TextInputdState();
}

class _TextInputdState extends State<TextInputd> {
  final focusNode = FocusNode();
  late bool _isObscure;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {});
    });

    _isObscure = widget.inputType == TextInputType.visiblePassword;
  }

  void _toggleObscure() => setState(() => _isObscure = !_isObscure);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      builder: (field) {
        final isEmpty = field.value?.isEmpty ?? true;
        return CustomInputDecorator(
          disableTapRippleEffect: true,
          onTap: () => focusNode.requestFocus(),
          focused: focusNode.hasFocus && widget.enableFocusBorder,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isEmpty ? 20 : 12.5,
          ),
          leadingIcon: widget.leadingIcon,
          leadingIconColor: widget.leadingIconColor ??
              (isEmpty ? AppColorsData.black.withOpacity(0.40) : AppColorsData.black),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEmpty && widget.label != null) ...[
                Text(
                  widget.label!,
                  style: const TextStyle(
                    color: AppColorsData.darkGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              TextFormField(
                enabled: widget.enabled,
                initialValue: widget.initialValue,
                focusNode: focusNode,
                onChanged: field.didChange,
                validator: widget.validator,
                maxLines: widget.maxLines,
                keyboardType: widget.inputType,
                obscureText:
                    widget.inputType == TextInputType.visiblePassword &&
                        _isObscure,
                style: const TextStyle(
                  color: AppColorsData.black,
                  fontSize: 14,
                  height: 1,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  border: InputBorder.none,
                  hintText: widget.label,
                  hintStyle: const TextStyle(
                    color: AppColorsData.darkGrey,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          trailing: widget.inputType == TextInputType.visiblePassword
              ? InkResponse(
                  onTap: _toggleObscure,
                  child: Icon(
                    _isObscure ? Iconsax.eye_slash : Iconsax.eye,
                    size: 24,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;
  final Color backgroundColor;
  final Color selectedColor;
  final bool disableShadow;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.backgroundColor = AppColorsData.white,
    this.selectedColor = AppColorsData.primaryColor,
    this.disableShadow = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 1),
    this.itemPadding = const EdgeInsets.all(9),
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      width: MediaQueryHelper.sizeFromWidth(context, 1),
      // height: MediaQueryHelper.sizeFromHeight(context, 13),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (!disableShadow)
            const BoxShadow(
              color: AppColorsData.grey,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < tabs.length; i++)
            CustomTabBarItem(
              padding: itemPadding,
              backgroundColor: backgroundColor,
              label: tabs[i],
              selectedColor: selectedColor,
              selected: selectedIndex == i,
              onTap: () => onTabChanged(i),
            )
        ],
      ),
    );
  }
}

class CustomTabBarItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color selectedColor;
  final EdgeInsets padding;

  const CustomTabBarItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.backgroundColor = AppColorsData.white,
    this.selectedColor = AppColorsData.primaryColor,
    this.padding = const EdgeInsets.all(2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:5, ),

      decoration: BoxDecoration(
        color: selected ? selectedColor: backgroundColor,
        borderRadius: BorderRadius.circular(15),

      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: padding,
            child: FittedBox(
              child: Text(
                label,
                maxLines: 1,
                style: AppTextStyles.boldtitles.copyWith(
                  color: selected ?  AppColorsData.white : AppColorsData.mediumGrey,
                  fontSize: 14,

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class CustomBottomNavigationBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData coloredIcon;
  final bool selected;

  const CustomBottomNavigationBarItem({
    super.key,
    required this.label,
    required this.icon,
    required this.coloredIcon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected)
            Stack(
              children: [
                Icon(
                  size: 30,
                  coloredIcon,
                  color: AppColorsData.white,
                ),
                Icon(
                  icon,
                  size: 30,
                  color: AppColorsData.primaryColor,
                ),
              ],
            )
          else
            Icon(
              icon,
              size: 30,
              color: AppColorsData.darkGrey.withOpacity(0.5),
            ),
          const SizedBox(height: 4),
          Text(label,
              style: selected
                  ? AppTextStyles.w700.copyWith(
                  color: Colors.grey.shade800,
                  fontSize: 11,
                  fontWeight: FontWeight.w200)
                  : AppTextStyles.w600.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onTap;
  final List<CustomBottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQueryHelper.sizeFromWidth(context, 1),
              height: 85,
              decoration: const BoxDecoration(
                color: AppColorsData.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColorsData.grey,
                    blurRadius: 20,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int index = 1; index < items.length; index++)
                    GestureDetector(
                      onTap: () => onTap(index),
                      child: items[index],
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 50,
            left: 50,
            top: 10,
            child: InkWell(
              onTap: () {
              },
              child: const CircleAvatar(
                radius: 27,
                backgroundColor: AppColorsData.primaryColor,
                child: Icon(
                  Iconsax.camera,
                  size: 30,
                  color: AppColorsData.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}