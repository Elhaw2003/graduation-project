import 'dart:ui';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

// ─── App Theme Colors ─────────────────────────────────────────────────────────
const Color kPrimary = Color(0xff1a3a6b); // deep navy blue  (matches app theme)
const Color kAccent = Color(0xff3d7bd6); // bright blue accent
const Color kBackground = Color(0xffF3F7FA); // light grey background
const Color kCardBg = Colors.white;
const Color kDarkBg = Color(0xff111827); // near-black for footer/nav

// ─── Helper widgets / functions (top-level) ───────────────────────────────────

Widget featureCard(IconData icon, String title, String subtitle) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
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
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: kAccent.withOpacity(.12),
        child: Icon(icon, color: kAccent, size: 26),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: kPrimary,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(height: 1.5, fontSize: 13),
        ),
      ),
    ),
  ).animate().fade().slideX();
}

Widget techChip(String title) {
  return Chip(
    backgroundColor: kAccent.withOpacity(.1),
    side: BorderSide(color: kAccent.withOpacity(.3)),
    label: Text(
      title,
      style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w600),
    ),
    avatar: const Icon(Icons.check_circle, color: kAccent, size: 18),
  ).animate().scale();
}

Widget roleCard({
  required Color color,
  required IconData icon,
  required String title,
  required List<String> items,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(.12),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(.13),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: kPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Expanded(child: Text(e, style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── WhyItem widget ───────────────────────────────────────────────────────────

class WhyItem extends StatelessWidget {
  final String text;
  const WhyItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xff4ade80),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Title helper ─────────────────────────────────────────────────────

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

// ─── Main Screen ──────────────────────────────────────────────────────────────

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
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
                          kDarkBg.withOpacity(.75),
                          kPrimary.withOpacity(.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hero(
                      //   tag: "logo",
                      //   // child: Container(
                      //   //   height: 90,
                      //   //   width: 90,
                      //   //   decoration: BoxDecoration(
                      //   //     color: Colors.white,
                      //   //     borderRadius: BorderRadius.circular(24),
                      //   //     boxShadow: [
                      //   //       BoxShadow(
                      //   //         color: Colors.black.withOpacity(.2),
                      //   //         blurRadius: 16,
                      //   //         offset: const Offset(0, 6),
                      //   //       ),
                      //   //     ],
                      //   //   ),
                      //   //   child: const Icon(
                      //   //     Icons.travel_explore,
                      //   //     size: 52,
                      //   //     color: kAccent,
                      //   //   ),
                      //   // ),

                      // ),
                      const SizedBox(height: 18),
                      const Text(
                        "Smart Guide Egypt",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ).animate().fade().slideY(),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "AI-Powered Tourism Platform for Exploring Egypt's Heritage",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5,
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
                  // ── STATISTICS ──────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: statCard(
                          Icons.people_alt_rounded,
                          1000,
                          "Travelers",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: statCard(
                          Icons.location_city_rounded,
                          500,
                          "Sites",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: statCard(Icons.badge_rounded, 100, "Guides"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: statCard(
                          Icons.smart_toy_rounded,
                          24,
                          "AI Support",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── ABOUT ───────────────────────────────────────────────────
                  _sectionTitle("About Smart Guide Egypt"),
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
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: kAccent.withOpacity(.12),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: kAccent,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Smart Guide Egypt is an AI-powered tourism platform designed to enhance travel experiences across Egypt by combining modern technologies with rich cultural heritage.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.8,
                            fontSize: 14,
                            color: Color(0xff374151),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "The application helps tourists discover historical landmarks, interact with intelligent AI assistance, and connect with certified professional tour guides.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.8,
                            fontSize: 14,
                            color: Color(0xff374151),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 32),

                  // ── FEATURES ────────────────────────────────────────────────
                  _sectionTitle("Key Features"),
                  const SizedBox(height: 16),
                  featureCard(
                    Icons.camera_alt_rounded,
                    "AI Landmark Recognition",
                    "Identify monuments and artifacts and receive detailed historical information.",
                  ),
                  featureCard(
                    Icons.smart_toy_rounded,
                    "AI Travel Assistant",
                    "Ask questions and get instant responses about attractions, routes and ticket prices.",
                  ),
                  featureCard(
                    Icons.person_pin_circle_rounded,
                    "Professional Guide Booking",
                    "Browse verified guides and schedule personalized tours.",
                  ),
                  featureCard(
                    Icons.view_in_ar_rounded,
                    "Augmented Reality Experience",
                    "Explore historical places through immersive AR experiences.",
                  ),
                  featureCard(
                    Icons.map_rounded,
                    "Interactive Maps",
                    "Discover nearby attractions, museums, hotels and restaurants.",
                  ),
                  featureCard(
                    Icons.location_searching,
                    "Real-Time Trip Tracking",
                    "Navigate routes and monitor your trip with live location services.",
                  ),

                  const SizedBox(height: 32),

                  // ── MISSION ─────────────────────────────────────────────────
                  _sectionTitle("Our Mission"),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [kPrimary, kAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "To bridge the gap between traditional tourism and modern artificial intelligence, providing visitors with a smarter and more interactive experience while promoting Egypt's historical heritage.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.8,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 32),

                  // ── TECHNOLOGIES ─────────────────────────────────────────────
                  _sectionTitle("Technologies & Architecture"),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      techChip("Flutter"),
                      techChip("REST API"),
                      techChip("JWT"),
                      techChip("AI Chatbot"),
                      techChip("Image Recognition"),
                      techChip("AR"),
                      techChip("Location Services"),
                      techChip("Responsive UI"),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── USER ROLES ───────────────────────────────────────────────
                  _sectionTitle("User Roles"),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: roleCard(
                          color: kAccent,
                          icon: Icons.flight_takeoff_rounded,
                          title: "Travelers",
                          items: [
                            "Discover attractions",
                            "AI assistance",
                            "Book tours",
                            "Track trips",
                            "Save destinations",
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: roleCard(
                          color: const Color(0xfff59e0b),
                          icon: Icons.badge_rounded,
                          title: "Professional Guides",
                          items: [
                            "Manage profiles",
                            "Create tours",
                            "Receive bookings",
                            "Track ratings",
                            "Availability",
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── WHY US ───────────────────────────────────────────────────
                  _sectionTitle("Why Smart Guide Egypt?"),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kPrimary,
                    ),
                    child: const Column(
                      children: [
                        WhyItem("Smart AI Assistance"),
                        WhyItem("Verified Professional Guides"),
                        WhyItem("Rich Historical Information"),
                        WhyItem("Augmented Reality Experiences"),
                        WhyItem("Personalized Travel Planning"),
                        WhyItem("Interactive Maps & Navigation"),
                        WhyItem("Secure Authentication & Booking"),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 32),

                  // ── TEAM ─────────────────────────────────────────────────────
                  _sectionTitle("Development Team"),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kCardBg,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimary.withOpacity(.08),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: kAccent.withOpacity(.12),
                          child: const Icon(
                            Icons.groups_rounded,
                            size: 42,
                            color: kAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Smart Guide Egypt",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Graduation Project 2026",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 10),
                        const Text(
                          "Developed by Tanta University Team.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.8,
                            fontSize: 13,
                            color: Color(0xff374151),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().slideY(),

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

  // ── statCard ──────────────────────────────────────────────────────────────
  Widget statCard(IconData icon, int number, String title) {
    return Container(
      height: 130,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: kAccent.withOpacity(.12),
            child: Icon(icon, size: 24, color: kAccent),
          ),
          const SizedBox(height: 10),
          AnimatedFlipCounter(
            value: number,
            suffix: "+",
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    ).animate().fade().slideY();
  }
}
