import 'package:flutter/material.dart';
import 'verify_email_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const purple = Color(0xFF5140EB);
  static const heading = Color(0xFF182237);
  static const muted = Color(0xFF7B879C);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _department;
  bool _hidePassword = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  final List<String> _departments = [
    'Software Engineering',
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Business Administration',
    'Other',
  ];

  void _createAccount() {
    FocusScope.of(context).unfocus();

    final validForm = _formKey.currentState!.validate();

    setState(() {
      _showTermsError = !_acceptedTerms;
    });

    if (!validForm || !_acceptedTerms) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerifyEmailScreen(
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  void _showPolicy(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: muted,
        fontSize: 14,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE3E8F1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: purple,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: heading,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your $label';
    }

    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          tooltip: 'Back to login',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: heading,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Join your campus',
                                  style: TextStyle(
                                    color: heading,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'A community that looks out '
                                      'for each other.',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    _label('Full name'),

                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      decoration: _decoration(
                        hint: 'Muhammad Hasnain Iftikhar',
                      ),
                      validator: (value) {
                        return _required(value, 'full name');
                      },
                    ),

                    const SizedBox(height: 18),

                    _label('University email'),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: _decoration(
                        hint: 'Enter your university email',
                        suffixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: muted,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'Enter your email address';
                        }

                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(email)) {
                          return 'Enter a valid email address';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    _label('Student / employee ID'),

                    TextFormField(
                      controller: _studentIdController,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: _decoration(
                        hint: 'FA24-BSE-118',
                      ),
                      validator: (value) {
                        return _required(
                          value,
                          'student or employee ID',
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    _label('Department'),

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: _decoration(
                        hint: 'Select your department',
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: muted,
                      ),
                      items: _departments.map((department) {
                        return DropdownMenuItem<String>(
                          value: department,
                          child: Text(
                            department,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _department = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select your department';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    _label('Phone number (optional)'),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.telephoneNumber,
                      ],
                      decoration: _decoration(
                        hint: '03XX XXXXXXX',
                      ),
                      validator: (value) {
                        final phone = value?.trim() ?? '';

                        if (phone.isEmpty) return null;

                        final normalized = phone.replaceAll(
                          RegExp(r'[\s()-]'),
                          '',
                        );

                        if (!RegExp(
                          r'^(03[0-9]{9}|\+923[0-9]{9})$',
                        ).hasMatch(normalized)) {
                          return 'Use 03XXXXXXXXX or +923XXXXXXXXX';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    _label('Password'),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [
                        AutofillHints.newPassword,
                      ],
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: _decoration(
                        hint: 'Create a password',
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: muted,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final password = value ?? '';

                        if (password.isEmpty) {
                          return 'Create a password';
                        }

                        if (password.length < 8) {
                          return 'Use at least 8 characters';
                        }

                        if (!RegExp(r'[0-9]').hasMatch(password)) {
                          return 'Include at least one number';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) => _createAccount(),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Use at least 8 characters, including a number.',
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Terms checkbox and links.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 40,
                          child: Checkbox(
                            value: _acceptedTerms,
                            activeColor: purple,
                            onChanged: (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                                _showTermsError = !_acceptedTerms;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'I agree to the Terms of Service '
                                      'and Privacy Policy.',
                                  style: TextStyle(
                                    color: heading,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Wrap(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _showPolicy(
                                        'Terms of Service',
                                        'Prototype notice: final terms '
                                            'have not been published yet. '
                                            'They must be added before '
                                            'public registration opens.',
                                      );
                                    },
                                    child: const Text(
                                      'View terms',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showPolicy(
                                        'Privacy Policy',
                                        'Prototype notice: a final '
                                            'privacy policy must explain '
                                            'what data is collected, '
                                            'who can access it, and how '
                                            'users can request deletion.',
                                      );
                                    },
                                    child: const Text(
                                      'View privacy policy',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (_showTermsError)
                      const Padding(
                        padding: EdgeInsets.only(left: 40, top: 4),
                        child: Text(
                          'Please accept the terms to continue.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _createAccount,
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: muted,
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: purple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}