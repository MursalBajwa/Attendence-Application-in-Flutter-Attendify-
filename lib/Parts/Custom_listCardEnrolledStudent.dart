// Custom_listCardEnrolledStudent.dart
import 'package:flutter/material.dart';
import 'Custom_listCardStudent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class listCardEnrolledStudent extends StatelessWidget {
  final student Student;
  final String classId;

  const listCardEnrolledStudent({
    super.key,
    required this.Student,
    required this.classId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;
    final enrolledRef = FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('enrolledStudents');

    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Student_Images/Student.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
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
                  Container(
                    margin: EdgeInsets.only(right: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            // delete this enrolled-student doc
                            await enrolledRef.doc(Student.id).delete();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: colors.primary,
                          ),
                          label: Text(
                            'Delete',
                            style: textTheme.labelLarge!.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.surfaceContainerHighest,
                            elevation: 0,
                          ),
                        ),
                      ],
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
