import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // Link send hone ke baad confirmation box dikhane ke liye flag
  bool _isLinkSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  String _friendlyResetError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'Could not send reset email. Please try again.';
    }
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
      _isLinkSent = false;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      setState(() {
        _isLinkSent = true;
      });
    } on FirebaseAuthException catch (e) {
      _showMessage(_friendlyResetError(e));
    } catch (e) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);
    const background = Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF182237)),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Reset password',
          style: TextStyle(
            color: Color(0xFF182237),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    // Top Key Icon
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEDFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.vpn_key_outlined,
                          size: 36,
                          color: purple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title Text
                    const Text(
                      'Let’s get you back in.',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF182237),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle Text
                    const Text(
                      'We’ll email a secure link to reset your password.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // University Email Input Label
                    const Text(
                      'University email',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF182237),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'ahmed@campus.edu.pk',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.blueGrey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: purple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(email)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!_isLoading) _sendResetLink();
                      },
                    ),
                    const SizedBox(height: 20),

                    // Send Reset Link Button
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _sendResetLink,
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                            : const Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirmation Box (Shown when button is clicked)
                    if (_isLinkSent) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8F0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFB7E4C7)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Reset link sent',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF182237),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Check your university inbox. The link is valid for 15 minutes. Don’t see it? Check spam or resend.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withValues(alpha: 0.7),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Back to Login Button (Bottom)
                    SizedBox(
                      height: 52,
                      child: TextButton(
                        onPressed:
                        _isLoading ? null : () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFEEF0FA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(
                            color: purple,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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