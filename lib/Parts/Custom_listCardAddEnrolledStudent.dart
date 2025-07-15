import 'package:flutter/material.dart';
import 'Custom_listCardStudent.dart';



class listCardAddEnrolledStudent extends StatelessWidget {
  final student Student;
  final bool isSelected;
  final VoidCallback onToggle;

  const listCardAddEnrolledStudent({
    super.key,
    required this.Student,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: colors.onSurface),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Student_Images/Student.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                    
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                                    
                        Text(
                          Student.studentName,
                          style: textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colors.primary,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Reg No: ${Student.studentRegistrationNumber}',
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.primary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onToggle,
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.surfaceContainerHighest,
                      elevation: 0,
                    ),
                    icon: Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank , color: colors.primary),
                    label: Text(
                      isSelected ? 'Selected' : 'Select',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
