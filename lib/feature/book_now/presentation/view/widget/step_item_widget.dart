import 'package:flutter/material.dart';

class StepItemWidget extends StatelessWidget {
  const StepItemWidget({
    super.key,
    required this.index,
    required this.label,
    required this.active,
    this.done = false,
  });

  final int index;
  final String label;
  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {

    Color circleColor =
        active || done
            ? const Color(0xff1C3F95)
            : Colors.white;

    Color textColor =
        active || done
            ? Colors.white
            : Colors.grey;

    return Column(
      children: [

        CircleAvatar(
          radius: 20,

          backgroundColor: circleColor,

          child: done
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Text(
                  '$index',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),

          decoration: BoxDecoration(
            color: active || done
                ? const Color(0xff1C3F95)
                : const Color(0xff6D84C2),

            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            label,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}