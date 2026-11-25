import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'verify_email_screen.dart';

/// App colors in one place. Login screen mein bhi yehi colors hain, to
/// dono ko `lib/app_colors.dart` mein move karke share kar sakte hain.
class _Palette {
  static const purple = Color(0xFF5140EB);
  static const background = Color(0xFFF8F9FD);
  static const border = Color(0xFFE0E4EF);
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phonePattern = RegExp(r'^\+?[0-9\s-]{7,15}$');

  static const _departments = [
    'Software Engineering',
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Business Administration',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _department;
  bool _hidePassword = true;
  bool _accepted = false;
  bool _showTermsError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  String _friendlySignupError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'Could not create account. Please try again.';
    }
  }

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    final formIsValid = _formKey.currentState!.validate();
    setState(() => _showTermsError = !_accepted);

    if (!formIsValid || !_accepted || _isLoading) return;

    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final campusId = _idController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'campusId': campusId,
          'department': _department ?? '',
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      TextInput.finishAutofillContext();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            email: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(_friendlySignupError(e));
    } catch (e) {
      _showMessage('Something went wrong while creating account.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ---------- Validators ----------

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Required';
    if (!_emailPattern.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null; // optional field
    if (!_phonePattern.hasMatch(phone)) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Include a number';
    return null;
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.background,
      appBar: AppBar(
        title: const Text('Join your campus'),
        backgroundColor: _Palette.background,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          // Fixed width ki jagah maxWidth: chhoti screens par overflow nahi hoga.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'A community that looks out for each other.',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    const SizedBox(height: 30),

                    _textField(
                      controller: _nameController,
                      label: 'Full name',
                      keyboardType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      validator: _required,
                    ),
                    _textField(
                      controller: _emailController,
                      label: 'University email',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: _validateEmail,
                    ),
                    _textField(
                      controller: _idController,
                      label: 'Student / employee ID',
                      validator: _required,
                    ),

                    // Department
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: _inputStyle('Department'),
                        items: _departments
                            .map(
                              (name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ),
                        )
                            .toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                          setState(() => _department = value);
                        },
                        validator: (value) =>
                        value == null ? 'Select a department' : null,
                      ),
                    ),

                    _textField(
                      controller: _phoneController,
                      label: 'Phone number (optional)',
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      validator: _validatePhone,
                    ),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: _inputStyle(
                        'Password',
                        helper: 'At least 8 characters, including a number',
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                            setState(() => _hidePassword = !_hidePassword);
                          },
                        ),
                      ),
                      validator: _validatePassword,
                      onFieldSubmitted: (_) {
                        if (!_isLoading) _signup();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Terms
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: _Palette.purple,
                      title: const Text(
                        'I accept the Terms and Privacy Policy',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: _accepted,
                      onChanged: _isLoading
                          ? null
                          : (value) {
                        setState(() {
                          _accepted = value ?? false;
                          if (_accepted) _showTermsError = false;
                        });
                      },
                    ),
                    if (_showTermsError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Please accept the terms to continue',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 50,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _signup,
                        style: FilledButton.styleFrom(
                          backgroundColor: _Palette.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Create account'),
                      ),
                    ),
                    TextButton(
                      onPressed:
                      _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Already have an account? Log in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable text field (name, email, ID, phone).
  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
    Iterable<String>? autofillHints,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: !_isLoading,
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        textInputAction: TextInputAction.next,
        autofillHints: autofillHints,
        autocorrect: keyboardType != TextInputType.emailAddress,
        decoration: _inputStyle(label),
        validator: validator,
      ),
    );
  }

  /// Shared styling for all fields.
  InputDecoration _inputStyle(
      String label, {
        String? helper,
        Widget? suffixIcon,
      }) {
    OutlineInputBorder outline(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      labelText: label,
      helperText: helper,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: outline(_Palette.border),
      enabledBorder: outline(_Palette.border),
      focusedBorder: outline(_Palette.purple, 2),
    );
  }
}