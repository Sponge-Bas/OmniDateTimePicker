import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
    required this.onCancelPressed,
    required this.onSavePressed,
  });

  final void Function() onCancelPressed;
  final void Function() onSavePressed;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(18),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onCancelPressed,
              child: RichText(
                text: const TextSpan(
                  text: "CANCEL",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.55,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFAA47),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onSavePressed,
              child: RichText(
                text: const TextSpan(
                  text: "CONFIRM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.55,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
