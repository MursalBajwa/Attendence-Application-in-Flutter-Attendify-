// Custom_listCardClass.dart
import 'package:flutter/material.dart';
import '../util/appRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  final String id;
  final String courseName;
  final String startingDate;
  final String endingDate;

  const Class({
    required this.id,
    required this.courseName,
    required this.startingDate,
    required this.endingDate,
  });
}

class listCardClass extends StatelessWidget {
  final Class classes;

  const listCardClass({
    super.key,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: theme.colorScheme.onSurface,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classes.courseName, style: theme.textTheme.titleLarge),
                    Text('Start: ' + classes.startingDate, style: theme.textTheme.bodySmall),
                    Text('End: ' + classes.endingDate, style: theme.textTheme.bodySmall),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      appRoutes.enrollStudentPage,
                      arguments: classes.id,
                    );
                  },
                  icon: Icon(Icons.school, color: theme.colorScheme.primary),
                  label: Text('Students', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface)),
                  style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, elevation: 0),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    appRoutes.attendancePage,
                    arguments: classes.id,
                  );
                },
                icon: Icon(Icons.check_box, color: theme.colorScheme.primary),
                label: Text('Attnd', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface, fontSize: 12)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, elevation: 0),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    appRoutes.editClassPage,
                    arguments: classes.id,
                  );
                },
                icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                label: Text('Edit', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface, fontSize: 12)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, elevation: 0),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('classes').doc(classes.id).delete();
                },
                icon: Icon(Icons.delete, color: theme.colorScheme.primary),
                label: Text('Del', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface, fontSize: 12)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, elevation: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
