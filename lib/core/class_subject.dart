

import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedInitialData() async {
    await _seedClasses();
    await _seedSubjects();
  }

  static Future<void> _seedClasses() async {
    final snapshot = await _firestore.collection('classes').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      print("Classes already exist.");
      return;
    }

    final batch = _firestore.batch();

    final classes = [
      {
        "id": "class10",
        "name": "Class 10",
        "order": 1,
        "isActive": true,
      },
      {
        "id": "class11",
        "name": "Class 11",
        "order": 2,
        "isActive": true,
      },
      {
        "id": "class12",
        "name": "Class 12",
        "order": 3,
        "isActive": true,
      },
    ];

    for (final item in classes) {
      final doc = _firestore.collection('classes').doc(item['id'] as String);

      batch.set(doc, {
        ...item,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    print("Classes seeded successfully.");
  }

  static Future<void> _seedSubjects() async {
    final snapshot = await _firestore.collection('subjects').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      print("Subjects already exist.");
      return;
    }

    final batch = _firestore.batch();

    final subjects = [
      {
        "id": "maths",
        "name": "Mathematics",
        "order": 1,
        "isActive": true,
      },
      {
        "id": "physics",
        "name": "Physics",
        "order": 2,
        "isActive": true,
      },
      {
        "id": "chemistry",
        "name": "Chemistry",
        "order": 3,
        "isActive": true,
      },
      {
        "id": "biology",
        "name": "Biology",
        "order": 4,
        "isActive": true,
      },
      // {
      //   "id": "english",
      //   "name": "English",
      //   "order": 5,
      //   "isActive": true,
      // },
      // {
      //   "id": "aptitude",
      //   "name": "Competitive Aptitude",
      //   "order": 6,
      //   "isActive": true,
      // },
      // {
      //   "id": "reasoning",
      //   "name": "Reasoning",
      //   "order": 7,
      //   "isActive": true,
      // },
      // {
      //   "id": "gk",
      //   "name": "General Knowledge",
      //   "order": 8,
      //   "isActive": true,
      // },
    ];

    for (final item in subjects) {
      final doc = _firestore.collection('subjects').doc(item['id'] as String);

      batch.set(doc, {
        ...item,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    print("Subjects seeded successfully.");
  }
}