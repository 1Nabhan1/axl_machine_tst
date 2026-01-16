import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/auth/auth_event.dart';
import '../../../logic/auth/auth_state.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _profileImage;
  DateTime? _selectedDate;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------- IMAGE PICKER ----------------
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- DATE PICKER ----------------
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // ---------------- PASSWORD VALIDATION ----------------
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Minimum 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Add uppercase letter';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Add lowercase letter';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Add a number';
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Add special character';
    }
    return null;
  }

  // ---------------- SUBMIT ----------------
  void _handleSignUp() {
    if (!_formKey.currentState!.validate()) return;

    if (_profileImage == null) {
      _showError('Please add a profile picture');
      return;
    }

    if (_selectedDate == null) {
      _showError('Please select date of birth');
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(
        username: _usernameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        password: _passwordController.text.trim(),
        dob: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        profileImagePath: _profileImage!.path,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showError(state.message);
        }

        if (state is AuthUnauthenticated) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('Account Created'),
              content: const Text(
                'Your account has been created successfully. Please login.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your details to get started',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 32),

                // PROFILE IMAGE
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: _showImagePickerDialog,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: 'Username',
                        ),
                        validator: (v) =>
                        v == null || v.length < 3 ? 'Invalid username' : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: 'Full Name',
                        ),
                        validator: (v) =>
                        v == null || v.split(' ').length < 2
                            ? 'Enter full name'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              labelText: 'Date of Birth',
                            ),
                            controller: TextEditingController(
                              text: _selectedDate == null
                                  ? ''
                                  : DateFormat('dd MMM yyyy')
                                  .format(_selectedDate!),
                            ),
                            validator: (_) =>
                            _selectedDate == null ? 'Select DOB' : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            }),
                          ),
                        ),
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() {
                              _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                            }),
                          ),
                        ),
                        validator: (v) => v != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;

                            return ElevatedButton(
                              onPressed: isLoading ? null : _handleSignUp,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text('Create Account'),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Sign In'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
