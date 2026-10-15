import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const purple = Color(0xFF5140EB);
  static const heading = Color(0xFF182237);
  static const muted = Color(0xFF7B879C);

  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  String? _error;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  void _verify() {
    final code = _controllers.map((c) => c.text).join();

    if (code.length != 6) {
      setState(() {
        _error = 'Enter all 6 digits to continue.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _error = null);

    _showMessage(
      'Code entered. Real verification is not connected yet.',
    );
  }

  void _onDigitChanged(String value, int index) {
    if (_error != null) {
      setState(() => _error = null);
    }

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight > 48
                          ? constraints.maxHeight - 48
                          : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header.
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Go back',
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: heading,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Verify your email',
                                  style: TextStyle(
                                    color: heading,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 36),

                            Center(
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFEDFF),
                                  borderRadius:
                                  BorderRadius.circular(26),
                                ),
                                child: const Icon(
                                  Icons.mark_email_read_outlined,
                                  color: purple,
                                  size: 44,
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            const Text(
                              'Check your inbox',
                              style: TextStyle(
                                color: heading,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Enter your 6-digit verification code for',
                              style: TextStyle(
                                color: muted,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              widget.email,
                              style: const TextStyle(
                                color: heading,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Six input boxes.
                            Row(
                              children: List.generate(6, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: index == 5 ? 0 : 8,
                                    ),
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      keyboardType:
                                      TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      textInputAction: index == 5
                                          ? TextInputAction.done
                                          : TextInputAction.next,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      style: const TextStyle(
                                        color: heading,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        enabledBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: _error == null
                                                ? const Color(
                                              0xFFE3E8F1,
                                            )
                                                : Colors.red,
                                          ),
                                        ),
                                        focusedBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: purple,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        _onDigitChanged(value, index);
                                      },
                                      onSubmitted: (_) {
                                        if (index == 5) {
                                          _verify();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),

                            if (_error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 12),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  _showMessage(
                                    'Resending will work after '
                                        'email authentication is connected.',
                                  );
                                },
                                child: const Text(
                                  'Resend code',
                                  style: TextStyle(
                                    color: purple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFEDFF),
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                              child: const Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: purple,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'One step closer',
                                          style: TextStyle(
                                            color: heading,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Email verification helps '
                                              'protect your account. Your '
                                              'email will not appear on '
                                              'public item reports.',
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 12,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: _verify,
                              style: FilledButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Verify & continue',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}