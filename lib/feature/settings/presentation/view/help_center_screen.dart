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

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

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
          decoration: const BoxDecoration(
            color: kAccent,
            shape: BoxShape.circle,
          ),
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

// ─── FAQ Expansion Card ───────────────────────────────────────────────────────

Widget _faqCard(String question, Widget answer) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: kPrimary.withOpacity(.06),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: kAccent.withOpacity(.12),
          child: const Icon(
            Icons.question_mark_rounded,
            color: kAccent,
            size: 16,
          ),
        ),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: kPrimary,
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: kAccent),
        children: [
          const Divider(height: 1, color: Color(0xffE5E7EB)),
          const SizedBox(height: 12),
          answer,
        ],
      ),
    ),
  ).animate().fade().slideY(begin: .08);
}

Widget _answerText(String text) => Text(
  text,
  style: const TextStyle(fontSize: 14, height: 1.8, color: kTextBody),
);

// ─── Section Category Card ────────────────────────────────────────────────────

Widget _categoryCard({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
  required List<Widget> faqs,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(.15),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: kTextGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...faqs,
      ],
    ),
  );
}

// ─── Step Tip Widget ─────────────────────────────────────────────────────────

Widget _stepTip(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Color(0xff4ade80),
          size: 18,
        ),
        const SizedBox(width: 8),
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

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 270,
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
                          kDarkBg.withOpacity(.82),
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
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.help_center_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Help Center",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ).animate().fade().slideY(),
                      const SizedBox(height: 6),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          "We're here to help you make the most of your travel experience.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ).animate().fade().slideY(delay: 200.ms),
                      const SizedBox(height: 18),
                      // Search bar inside header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) =>
                              setState(() => _searchQuery = v.toLowerCase()),
                          style: const TextStyle(fontSize: 14, color: kPrimary),
                          decoration: InputDecoration(
                            hintText: "Search for help...",
                            hintStyle: TextStyle(
                              color: kTextGrey.withOpacity(.7),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: kAccent,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ).animate().fade().slideY(delay: 300.ms),
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
                  // ── QUICK STATS ──────────────────────────────────────────────
                  Row(
                    children: [
                      _quickStat(Icons.quiz_rounded, "11", "Topics"),
                      const SizedBox(width: 12),
                      _quickStat(
                        Icons.support_agent_rounded,
                        "24/7",
                        "Support",
                      ),
                      const SizedBox(width: 12),
                      _quickStat(Icons.bolt_rounded, "Fast", "Response"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ── GETTING STARTED ──────────────────────────────────────────
                  _sectionTitle("Getting Started"),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [kPrimary, kAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.rocket_launch_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "New to Smart Guide Egypt?",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _startStep(
                          "1",
                          "Create your account using email or social login.",
                        ),
                        _startStep(
                          "2",
                          "Choose your role: Traveler or Professional Guide.",
                        ),
                        _startStep(
                          "3",
                          "Explore Egypt's heritage with AI-powered assistance.",
                        ),
                        _startStep(
                          "4",
                          "Book a professional guide or use the AR feature.",
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 30),

                  // ── FAQ SECTIONS ─────────────────────────────────────────────
                  _sectionTitle("Frequently Asked Questions"),
                  const SizedBox(height: 20),

                  // Getting Started FAQs
                  _categoryCard(
                    icon: Icons.person_add_rounded,
                    color: kPrimary,
                    title: "Account & Registration",
                    subtitle: "2 questions",
                    faqs: [
                      _faqCard(
                        "How do I create an account?",
                        _answerText(
                          "You can register as a Traveler or a Professional Guide using your email or social accounts.",
                        ),
                      ),
                      _faqCard(
                        "How do I log in?",
                        _answerText(
                          "Enter your registered credentials and access your personalized dashboard.",
                        ),
                      ),
                    ],
                  ),

                  // AI Assistant
                  _categoryCard(
                    icon: Icons.smart_toy_rounded,
                    color: const Color(0xff7c3aed),
                    title: "AI Assistant Support",
                    subtitle: "2 questions",
                    faqs: [
                      _faqCard(
                        "How can I use the AI Guide?",
                        _answerText(
                          "Simply ask questions through the AI chat interface to receive information about historical sites, attractions, and travel recommendations.",
                        ),
                      ),
                      _faqCard(
                        "Can I upload images?",
                        _answerText(
                          "Yes. You can upload photos of landmarks to receive AI-powered recognition and information.",
                        ),
                      ),
                    ],
                  ),

                  // Tour Guide Booking
                  _categoryCard(
                    icon: Icons.badge_rounded,
                    color: const Color(0xfff59e0b),
                    title: "Tour Guide Booking",
                    subtitle: "3 questions",
                    faqs: [
                      _faqCard(
                        "How do I book a guide?",
                        _answerText(
                          "Browse verified guides, view profiles, choose a tour, and complete the booking process.",
                        ),
                      ),
                      _faqCard(
                        "Can I cancel a booking?",
                        _answerText(
                          "Yes. Booking cancellations are subject to the guide's cancellation policy.",
                        ),
                      ),
                      _faqCard(
                        "How do I contact my guide?",
                        _answerText(
                          "You can communicate with guides through the in-app messaging system.",
                        ),
                      ),
                    ],
                  ),

                  // AR
                  _categoryCard(
                    icon: Icons.view_in_ar_rounded,
                    color: const Color(0xff059669),
                    title: "Augmented Reality (AR)",
                    subtitle: "1 question",
                    faqs: [
                      _faqCard(
                        "Why isn't AR working?",
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _answerText("Please ensure the following:"),
                            const SizedBox(height: 8),
                            _bulletItem("Camera permission is enabled."),
                            _bulletItem("Location services are turned on."),
                            _bulletItem("Internet connection is stable."),
                            _bulletItem("Your device supports AR features."),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Maps
                  _categoryCard(
                    icon: Icons.map_rounded,
                    color: kAccent,
                    title: "Maps & Navigation",
                    subtitle: "2 questions",
                    faqs: [
                      _faqCard(
                        "How do I find nearby attractions?",
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _answerText(
                              "Use the Interactive Map to discover nearby:",
                            ),
                            const SizedBox(height: 8),
                            _bulletItem("Historical sites"),
                            _bulletItem("Museums"),
                            _bulletItem("Hotels"),
                            _bulletItem("Restaurants"),
                          ],
                        ),
                      ),
                      _faqCard(
                        "Does the app provide live navigation?",
                        _answerText(
                          "Yes. Smart Guide Egypt supports real-time trip tracking and navigation.",
                        ),
                      ),
                    ],
                  ),

                  // Account & Security
                  _categoryCard(
                    icon: Icons.security_rounded,
                    color: const Color(0xffdc2626),
                    title: "Account & Security",
                    subtitle: "3 questions",
                    faqs: [
                      _faqCard(
                        "I forgot my password.",
                        _answerText(
                          "Use the \"Forgot Password\" option on the login screen to reset your password.",
                        ),
                      ),
                      _faqCard(
                        "How do I update my profile?",
                        _answerText("Go to Profile → Settings → Edit Profile."),
                      ),
                      _faqCard(
                        "Is my information secure?",
                        _answerText(
                          "Yes. We use secure authentication and data protection mechanisms to safeguard your information.",
                        ),
                      ),
                    ],
                  ),

                  // Payments
                  _categoryCard(
                    icon: Icons.payment_rounded,
                    color: const Color(0xff0891b2),
                    title: "Payments & Reservations",
                    subtitle: "2 questions",
                    faqs: [
                      _faqCard(
                        "What payment methods are supported?",
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _bulletItem("Cash"),
                            _bulletItem("Visa Cards"),
                            _bulletItem("Digital Wallets"),
                          ],
                        ),
                      ),
                      _faqCard(
                        "How can I view my bookings?",
                        _answerText(
                          "Navigate to My Bookings from your dashboard.",
                        ),
                      ),
                    ],
                  ),

                  // Technical Issues
                  _categoryCard(
                    icon: Icons.build_rounded,
                    color: const Color(0xff6b7280),
                    title: "Technical Issues",
                    subtitle: "2 questions",
                    faqs: [
                      _faqCard(
                        "The application is slow or crashes.",
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _answerText("Try the following:"),
                            const SizedBox(height: 8),
                            _stepTip("Restarting the application."),
                            _stepTip("Updating to the latest version."),
                            _stepTip("Checking your internet connection."),
                          ],
                        ),
                      ),
                      _faqCard(
                        "The map or location service is not working.",
                        _answerText(
                          "Make sure location permission is enabled in your device settings.",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── CONTACT SUPPORT ──────────────────────────────────────────
                  _sectionTitle("Contact Support"),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: kCardBg,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimary.withOpacity(.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "If you need additional assistance, please contact our support team.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.7,
                            color: kTextBody,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _contactRow(
                          icon: Icons.email_rounded,
                          color: kAccent,
                          label: "Email",
                          value: "support@smartguideegypt.com",
                        ),
                        const SizedBox(height: 12),
                        _contactRow(
                          icon: Icons.access_time_rounded,
                          color: const Color(0xff059669),
                          label: "Working Hours",
                          value: "24/7 — Always Available",
                        ),
                      ],
                    ),
                  ).animate().fade().slideY(),

                  const SizedBox(height: 20),

                  // ── EMERGENCY ────────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xfffef2f2),
                      border: Border.all(color: const Color(0xfffca5a5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xffdc2626),
                          size: 28,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Emergency Assistance",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xffdc2626),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "For urgent travel-related issues, please contact local emergency services or the Smart Guide Egypt support team immediately.",
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.6,
                                  color: Color(0xff7f1d1d),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 40),

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

  Widget _quickStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(.07),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: kAccent, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kPrimary,
              ),
            ),
            Text(label, style: const TextStyle(fontSize: 11, color: kTextGrey)),
          ],
        ),
      ).animate().fade().slideY(begin: .1),
    );
  }

  Widget _startStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white.withOpacity(.2),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: kTextGrey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
