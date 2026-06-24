import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─── App Theme Colors ─────────────────────────────────────────────────────────
const Color kPrimary = Color(0xff1a3a6b);
const Color kAccent = Color(0xff3d7bd6);
const Color kBackground = Color(0xffF3F7FA);
const Color kCardBg = Colors.white;
const Color kDarkBg = Color(0xff111827);
const Color kTextBody = Color(0xff374151);
const Color kTextGrey = Color(0xff6b7280);

// ─── Section Title ────────────────────────────────────────────────────────────

Widget _sectionTitle(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ),
  );
}

// ─── Terms Section Card ───────────────────────────────────────────────────────

Widget _termsCard({
  required String number,
  required String title,
  required Widget content,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: kPrimary.withOpacity(.07),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: kAccent.withOpacity(.12),
          child: Text(
            number,
            style: const TextStyle(
              color: kAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: kPrimary,
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: kAccent),
        children: [
          const Divider(height: 1, color: Color(0xffE5E7EB)),
          const SizedBox(height: 14),
          content,
        ],
      ),
    ),
  ).animate().fade().slideY(begin: .1);
}

Widget _bodyText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 14, height: 1.8, color: kTextBody),
  );
}

Widget _bulletItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: kAccent, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.7, color: kTextBody),
          ),
        ),
      ],
    ),
  );
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: kPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=900&q=80",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: kPrimary),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kDarkBg.withOpacity(.8),
                          kPrimary.withOpacity(.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.gavel_rounded,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ).animate().fade().slideY(),
                      const SizedBox(height: 8),
                      const Text(
                        "Last Updated: January 2026",
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ).animate().fade().slideY(delay: 200.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── BODY ────────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Column(
                children: [
                  // ── INTRO CARD ───────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [kPrimary, kAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white70,
                          size: 28,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            "Welcome to Smart Guide Egypt. By accessing or using our application, you agree to comply with and be bound by the following terms and conditions.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 28),

                  // ── SECTION TITLE ────────────────────────────────────────────
                  _sectionTitle("Terms & Conditions"),
                  const SizedBox(height: 18),

                  // ── 1. ACCEPTANCE ────────────────────────────────────────────
                  _termsCard(
                    number: "01",
                    title: "Acceptance of Terms",
                    content: _bodyText(
                      "By creating an account or using Smart Guide Egypt, you acknowledge that you have read, understood, and agreed to these Terms of Service.",
                    ),
                  ),

                  // ── 2. USE ───────────────────────────────────────────────────
                  _termsCard(
                    number: "02",
                    title: "Use of the Application",
                    content: _bodyText(
                      "Users may use the application for lawful purposes only. Any misuse, fraudulent activity, or unauthorized access is strictly prohibited.",
                    ),
                  ),

                  // ── 3. ACCOUNTS ──────────────────────────────────────────────
                  _termsCard(
                    number: "03",
                    title: "User Accounts",
                    content: Column(
                      children: [
                        _bulletItem(
                          "Users are responsible for maintaining the confidentiality of their account credentials.",
                        ),
                        _bulletItem(
                          "Users must provide accurate and complete information during registration.",
                        ),
                        _bulletItem(
                          "Smart Guide Egypt reserves the right to suspend or terminate accounts that violate these terms.",
                        ),
                      ],
                    ),
                  ),

                  // ── 4. AI ────────────────────────────────────────────────────
                  _termsCard(
                    number: "04",
                    title: "AI Assistant Services",
                    content: _bodyText(
                      "The AI assistant is designed to provide historical and tourism-related information. While we strive for accuracy, Smart Guide Egypt does not guarantee that all information provided by the AI is complete or error-free.",
                    ),
                  ),

                  // ── 5. TOUR GUIDES ───────────────────────────────────────────
                  _termsCard(
                    number: "05",
                    title: "Tour Guide Services",
                    content: Column(
                      children: [
                        _bulletItem(
                          "Professional guides are responsible for the information and services they provide.",
                        ),
                        _bulletItem(
                          "Users should review guide profiles, ratings, and pricing before making reservations.",
                        ),
                        _bulletItem(
                          "Smart Guide Egypt acts as a platform connecting travelers with guides and is not responsible for disputes between users and guides.",
                        ),
                      ],
                    ),
                  ),

                  // ── 6. BOOKING ───────────────────────────────────────────────
                  _termsCard(
                    number: "06",
                    title: "Booking and Payments",
                    content: Column(
                      children: [
                        _bulletItem(
                          "Booking details must be reviewed carefully before confirmation.",
                        ),
                        _bulletItem(
                          "Additional fees may apply depending on selected services.",
                        ),
                        _bulletItem(
                          "Payment methods available through the platform are subject to change.",
                        ),
                      ],
                    ),
                  ),

                  // ── 7. PRIVACY ───────────────────────────────────────────────
                  _termsCard(
                    number: "07",
                    title: "Privacy and Data Protection",
                    content: _bodyText(
                      "We are committed to protecting users' personal information. Data collected through the application is used solely to improve services and enhance the user experience.",
                    ),
                  ),

                  // ── 8. IP ────────────────────────────────────────────────────
                  _termsCard(
                    number: "08",
                    title: "Intellectual Property",
                    content: _bodyText(
                      "All content, logos, designs, graphics, and software associated with Smart Guide Egypt are protected by intellectual property laws and may not be copied, modified, or distributed without permission.",
                    ),
                  ),

                  // ── 9. LIABILITY ─────────────────────────────────────────────
                  _termsCard(
                    number: "09",
                    title: "Limitation of Liability",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bodyText(
                          "Smart Guide Egypt shall not be held responsible for:",
                        ),
                        const SizedBox(height: 8),
                        _bulletItem(
                          "Inaccurate information provided by third parties.",
                        ),
                        _bulletItem(
                          "Service interruptions or technical failures.",
                        ),
                        _bulletItem(
                          "Losses resulting from misuse of the application.",
                        ),
                        _bulletItem("Events beyond our reasonable control."),
                      ],
                    ),
                  ),

                  // ── 10. UPDATES ──────────────────────────────────────────────
                  _termsCard(
                    number: "10",
                    title: "Updates to Terms",
                    content: _bodyText(
                      "Smart Guide Egypt reserves the right to modify these Terms of Service at any time. Continued use of the application after changes constitutes acceptance of the updated terms.",
                    ),
                  ),

                  // ── 11. CONTACT ──────────────────────────────────────────────
                  _termsCard(
                    number: "11",
                    title: "Contact Us",
                    content: Column(
                      children: [
                        _bodyText(
                          "For questions or support regarding these Terms of Service, please contact the Smart Guide Egypt team.",
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: kAccent.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kAccent.withOpacity(.3)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_rounded,
                                color: kAccent,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "support@smartguide.eg",
                                style: TextStyle(
                                  color: kAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── AGREE BUTTON ─────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "I Agree to the Terms",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ).animate().fade().slideY(begin: .2),

                  const SizedBox(height: 32),

                  // ── FOOTER ────────────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: kDarkBg,
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.travel_explore_rounded,
                          color: kAccent,
                          size: 52,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Smart Guide Egypt",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "AI-Powered Tourism Platform",
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        SizedBox(height: 18),
                        Divider(color: Colors.white12),
                        SizedBox(height: 12),
                        Text(
                          "© 2026 All Rights Reserved",
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
