import 'package:auth_flutter_firebase/firebase_service.dart';
import 'package:flutter/material.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final FirebaseService service = FirebaseService();
  final TextEditingController surName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  @override
  void initState() {
    // вход анонимный
    service.sigin();
    super.initState();
    service.loadUserData().then((userData) {
      if (userData != null) {
        lastName.text = userData['lastName'] ?? '';
        firstName.text = userData['firstName'] ?? '';
        surName.text = userData['surName'] ?? '';
      }
    });
    // загрузка данных из firestore
  }

  @override
  void dispose() {
    surName.dispose();
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  // сохраняем данных на база firestore
  void saveData() async {
    service
        .saveData(
      lastName.text,
      surName.text,
      firstName.text,
    )
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные успешно сохранены')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TextField(
                  controller: lastName,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: firstName,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: surName,
                  decoration: const InputDecoration(
                    labelText: 'Отчество',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: saveData,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
