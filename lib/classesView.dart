// classesView.dart
import 'package:attendify/Parts/appDrawer.dart';
import 'package:attendify/util/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';
import 'Parts/Custom_listCardClass.dart';

class ClassesViewPage extends StatelessWidget {
  const ClassesViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final btnTh = theme.elevatedButtonTheme.style;
    final user = FirebaseAuth.instance.currentUser;
    final classesRef = FirebaseFirestore.instance.collection('classes');

    return SafeArea(
      child: Scaffold(
        endDrawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text('Classes', style: theme.appBarTheme.titleTextStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: classesRef
                          .where('ownerUid', isEqualTo: user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Total Classes: 0', style: textTh.headlineMedium);
                        }
                        final count = snapshot.data!.docs.length;
                        return Text('Total Classes: $count', style: textTh.headlineMedium);
                      },
                    ),
                    ElevatedButton(
                      style: btnTh,
                      onPressed: () {
                        Navigator.pushNamed(context, appRoutes.addClassPage);
                      },
                      child: Text('Add Class'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: classesRef.where('ownerUid', isEqualTo: user?.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Center(child: Text('Error loading classes'));
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return listCardClass(
                          classes: Class(
                            id: docs[index].id,
                            courseName: data['courseName'] ?? '',
                            startingDate: data['startingDate'] ?? '',
                            endingDate: data['endingDate'] ?? '',
                          ),
                          
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}