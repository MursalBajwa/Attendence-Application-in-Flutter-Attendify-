attendify — Student Attendance Mobile App
Mobile app to manage students, classes, attendance and generate Excel reports (Flutter + Firebase).

Table of contents
Project overview

Key features

Screens / UX flow

Firestore data model (brief)

How it works (behavior & important rules)

Setup & run locally

Permissions

Architecture & diagram explanation

Support documentation mapping (UI → DB actions)

Known limitations & suggested improvements

Contributing

License

Project overview
Name: attendify — Mobile Application for Attendance Management

Purpose: Simplify attendance workflows for instructors and small schools: manage student records, create classes, enroll students, mark attendance (once per day), and export attendance reports to Excel.

Key features
Email/password authentication (signup & login).

Dashboard with quick access to Students, Classes, Reports, Profile.

CRUD for Students and Classes.

Enroll / unenroll students in classes.

Mark attendance for enrolled students (enforced once per day).

View / edit / delete attendance entries.

Export class attendance for a date range to Excel (saved to device downloads).

Edit user profile (first/last name).

Screens / UX flow
Signup — first name, last name, email, password, confirm password → creates user account.

Login — email + password → opens dashboard.

Dashboard — cards linking to Students, Classes, Reports, Profile.

Students — list, add, edit, delete students.

Classes — list, add, edit, delete classes; view enrolled students and attendance.

Enroll Student — choose from students not already enrolled and add to a class.

Mark Attendance — mark present/absent for enrolled students (only once per day).

Reports — select class + date range → generate Excel file, save to device downloads.

Profile — edit first and last name.

Firestore data model (brief)
Key collections and fields (example structures):

users (document id = <userUid>)
json
Copy
Edit
{
  "createdAt": "<Timestamp>",
  "email": "teacher@example.com",
  "firstName": "Jane",
  "lastName": "Doe"
}
Students (document id = <studentId>)
json
Copy
Edit
{
  "name": "John Student",
  "ownerUid": "<userUid>",
  "registrationNumber": "REG-001",
  "enrolledAt": "<Timestamp>"
}
classes (document id = <classId>)
json
Copy
Edit
{
  "courseName": "Math 101",
  "ownerUid": "<userUid>",
  "startingDate": "<Timestamp>",
  "endingDate": "<Timestamp>",
  "createdBy": "<userUid>"
}
Subcollection: /classes/{classId}/enrolledStudents/{studentId}

json
Copy
Edit
{
  "name": "John Student",
  "registrationNumber": "REG-001",
  "enrolledAt": "<Timestamp>"
}
Subcollection: /classes/{classId}/attendance/{YYYY-MM-DD}

Document id example: 2025-05-24 (ISO date string)

Document contents: map of student attendance entries plus metadata, or a structured object such as:

json
Copy
Edit
{
  "markedAt": "<Timestamp>",
  "entries": {
    "<studentId>": { "status": "P", "markedAt": "<Timestamp>" },
    "<studentId2>": { "status": "A", "markedAt": "<Timestamp>" }
  }
}
Common path examples

swift
Copy
Edit
/classes/{classId}/enrolledStudents/{studentId}
/classes/{classId}/attendance/{YYYY-MM-DD}
/users/{userUid}
/Students/{studentId}
How it works (behavior & important rules)
Authentication: Email/password accounts handled by Firebase Authentication; user metadata stored in users/{uid}.

Student enrollment: Students live as documents in Students. Enrolling copies a snapshot of student info into /classes/{classId}/enrolledStudents/{studentId} so class-level snapshots remain stable even if the original student document changes later.

Attendance marking rule: The app enforces one attendance mark per class per day by checking /classes/{classId}/attendance/{YYYY-MM-DD} — if a document for that date exists, marking is blocked and the user is notified.

Reporting: Selecting class + date range reads the relevant attendance documents and exports an Excel file to the device after required file-permission checks.

Profile updates: Editing profile fields updates users/{uid} accordingly.

Setup & run locally
Prerequisites
Flutter SDK (stable channel)

Android SDK / Xcode (for Android / iOS testing)

A Firebase project with:

Authentication enabled (Email/Password)

Cloud Firestore enabled

Steps
Install dependencies:

bash
Copy
Edit
flutter pub get
Configure Firebase:

Create a Firebase project in the Firebase Console.

Enable Email/Password sign-in under Authentication.

Enable Cloud Firestore.

Add Android and/or iOS apps in Firebase and download platform config files:

google-services.json → place in android/app/

GoogleService-Info.plist → place in ios/Runner/

If the project expects firebase_options.dart, generate it (e.g., with the flutterfire CLI) and include it in /lib.

Run the app:

bash
Copy
Edit
flutter run
Notes

During development, Firestore rules may be relaxed for convenience — tighten them before publishing to production.

Ensure firebase_options.dart (if used) is present and correctly configured.

Permissions
Android: Request runtime file storage access to save Excel reports to Downloads (or use scoped storage APIs on newer Android versions).

iOS: Configure file saving/document picker entitlements if saving to Files.

Runtime: App requests required permissions before saving/exporting files.

Architecture & diagram explanation
Components
Mobile client (Flutter UI): All screens and UX for authentication, managing students/classes, marking attendance, and report generation.

Firebase Authentication: Handles user sign-up and sign-in.

Cloud Firestore: Primary backend storing users, Students, classes, and subcollections enrolledStudents and attendance.

Local device storage: Used to save generated Excel files (Downloads or Files).

Data & control flows
Signup / Login: Client uses Firebase Auth; on successful signup, create users/{uid} document with firstName, lastName, email, and createdAt.

Student CRUD: Create/edit/delete operations update Students collection.

Class CRUD & Enrollment: Create classes/{classId}; enrolling creates a snapshot in /classes/{classId}/enrolledStudents/{studentId}.

Attendance: When marking attendance the client checks for /classes/{classId}/attendance/{YYYY-MM-DD}. If not found, it writes attendance data; if found, it prevents duplicate marking. Attendance entries include status and markedAt.

Report generation: Client reads attendance entries over a date range and assembles an Excel file for export.

Profile updates: Updates reflected in users/{uid}.

Design rationale
Storing enrolledStudents as a subcollection simplifies fetching class rosters and keeps class-specific student snapshots stable.

Using date-keyed documents for attendance makes it simple to check whether attendance has already been taken for a given day.

Copying student info into enrolledStudents ensures historical accuracy of class rosters.

Support documentation mapping (UI → DB actions)
Signup → create users/{uid}

Login → Firebase Auth → fetch users/{uid}

Add student → create document in Students

Edit student → update Students/{studentId}

Delete student → delete Students/{studentId} (consider cascade or flagging enrollments)

Add class → create classes/{classId}

Enroll student → create classes/{classId}/enrolledStudents/{studentId} (copy of student data)

Mark attendance → write to classes/{classId}/attendance/{YYYY-MM-DD} (entries + markedAt)

Generate report → read /classes/{classId}/attendance/* within date range → export to Excel

Known limitations & suggested improvements
Concurrency / race conditions: If multiple users mark attendance simultaneously for the same class, consider server-side transactions or Cloud Functions to avoid race conditions.

Multiple sessions per day: If multiple attendance sessions per day are required, extend the attendance key to include session id/time.

Search & filters: Add search by name or registration number and improved filtering on Students/Class lists.

Offline support: Add local caching + sync so teachers can mark attendance offline and sync later.

Security rules: Implement Firestore security rules that restrict access to owners or authorized users only.

Testing & logging: Add automated tests and structured logging for easier troubleshooting.

Contributing
Create a branch for your feature or fix.

Implement changes and add tests where appropriate.

Submit a pull request for review.

License
MIT License

sql
Copy
Edit
MIT License

Copyright (c) [year] [owner]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
