import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:mebel_shop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class UserProfileEditPage extends StatefulWidget {
  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email_user');
    // Load user data here and populate controllers if you want to show existing values
  }

  Future<void> updateUserProfile() async {
    if (!_formKey.currentState!.validate() || userEmail == null) return;

    String fileName = _imageFile != null ? basename(_imageFile!.path) : '';
    Map<String, dynamic> data = {
      "first_name_user": firstNameController.text,
      "second_name_user": lastNameController.text,
      "phone_number_client": phoneNumberController.text,
    };

    // Добавляем пароль и роль пользователя, если они предоставлены
    if (passwordController.text.isNotEmpty) {
      data["password_user"] = passwordController.text;
    }
    if (roleController.text.isNotEmpty) {
      data["role_user"] = roleController.text;
    }

    // Если выбран файл изображения, добавляем его в данные формы
    if (_imageFile != null) {
      data["image_user_profile"] = await MultipartFile.fromFile(_imageFile!.path, filename: fileName);
    }

    FormData formData = FormData.fromMap(data);

    Dio dio = Dio();
    try {
      var response = await dio.put(
        '$api/api/user_profile/$userEmail',
        data: formData,
        options: Options(
          headers: {
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {

      } else {

      }
    } catch (e) {
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (_imageFile != null)
                Image.file(File(_imageFile!.path), height: 200),
              TextButton(
                onPressed: pickImage,
                child: Text("Change Photo"),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? "Please enter your first name" : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? "Please enter your last name" : null,
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? "Please enter your phone number" : null,
              ),
              TextFormField(
                controller: roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: updateUserProfile,
                child: Text("Update Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
