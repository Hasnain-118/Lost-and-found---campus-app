import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  String friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showMessage(friendlyAuthError(e));
    } catch (e) {
      showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 390,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Color(0xFFEFEDFF),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 36,
                        color: purple,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Welcome back.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF182237),
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Your campus community is here to help.',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    TextFormField(
                      controller: emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: inputStyle(
                        'University email',
                        Icons.email_outlined,
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(email)) {
                          return 'Enter a valid email address';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    TextFormField(
                      controller: passwordController,
                      enabled: !isLoading,
                      obscureText: hidePassword,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: inputStyle(
                        'Password',
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          tooltip: hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!isLoading) {
                          login();
                        }
                      },
                    ),

                    // Forgot password navigation
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          Navigator.pushNamed(context, '/reset-password');
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: purple),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: isLoading ? null : login,
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Community card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEDFF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: purple,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Help lost belongings find their way home.',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign up link
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          const Text('New to Lost & Found?'),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: purple,
                                fontWeight: FontWeight.bold,
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

  // Input fields style helper method
  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE0E4EF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF5140EB),
          width: 2,
        ),
      ),
    );
  }
}