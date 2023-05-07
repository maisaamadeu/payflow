import 'package:flutter/material.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/set_buttons/set_label_buttons.dart';

class BottomSheetWidget extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback primaryOnPressed;
  final String secondaryLabel;
  final VoidCallback secondaryOnPressed;
  final String title;
  final String subtitle;
  const BottomSheetWidget(
      {super.key,
      required this.primaryLabel,
      required this.primaryOnPressed,
      required this.secondaryLabel,
      required this.secondaryOnPressed,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppColors.shape,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text.rich(
                    TextSpan(
                      text: title,
                      style: AppTextStyles.buttonBoldHeading,
                      children: [
                        TextSpan(
                          text: "\n$subtitle",
                          style: AppTextStyles.buttonHeading,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 1,
                  width: double.maxFinite,
                  color: AppColors.stroke,
                ),
                SetLabelButtons(
                  enablePrimaryColor: true,
                  primaryLabel: 'Escanear novamente',
                  primaryOnPressed: () {},
                  secondaryLabel: 'Digitar código',
                  secondaryOnPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
