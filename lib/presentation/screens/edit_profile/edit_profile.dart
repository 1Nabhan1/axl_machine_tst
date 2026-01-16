import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/account_repo.dart';
import '../../../logic/profile/profile_bloc.dart';
import '../../../logic/profile/profile_event.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  File? _profileImage;
  late UserModel _originalUser;

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    _originalUser = AccountRepository().getUser()!;
    _usernameController.text = _originalUser.username;
    _fullNameController.text = _originalUser.fullName;
    _dobController.text = _originalUser.dob;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
        _isChanged = true;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = _originalUser.copyWith(
      username: _usernameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      dob: _dobController.text.trim(),
      profileImagePath: _profileImage?.path ?? _originalUser.profileImagePath,
    );

    // ✅ Use AccountBloc instead of saving directly
    context.read<AccountBloc>().add(UpdateProfile(updatedUser));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    Navigator.pop(context, updatedUser);
  }

  Future<bool> _onWillPop() async {
    if (!_isChanged &&
        _usernameController.text == _originalUser.username &&
        _fullNameController.text == _originalUser.fullName &&
        _dobController.text == _originalUser.dob &&
        _profileImage == null) {
      return true;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved changes'),
        content: const Text('You have unsaved changes. Discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue),
              ),
              onPressed: _saveProfile,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            onChanged: () => _isChanged = true,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_originalUser.profileImagePath != null &&
                                          _originalUser
                                              .profileImagePath!
                                              .isNotEmpty
                                      ? FileImage(
                                          File(_originalUser.profileImagePath!),
                                        )
                                      : null)
                                  as ImageProvider?,
                        child:
                            (_profileImage == null &&
                                (_originalUser.profileImagePath == null ||
                                    _originalUser.profileImagePath!.isEmpty))
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter full name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.tryParse(_dobController.text) ??
                          DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _dobController.text = picked.toIso8601String().split(
                          'T',
                        )[0];
                      });
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Select date of birth'
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
