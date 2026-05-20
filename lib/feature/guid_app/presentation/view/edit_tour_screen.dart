import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';

class EditTourScreen extends StatefulWidget {
  const EditTourScreen({super.key});

  @override
  State<EditTourScreen> createState() => _EditTourScreenState();
}

class _EditTourScreenState extends State<EditTourScreen> {
  int currentStep = 1;

  // =========================
  // Controllers
  // =========================

  final titleController = TextEditingController(
    text: "Giza Pyramids & Sphinx Tour",
  );

  final descriptionController = TextEditingController(
    text:
        "Step back 4,500 years to explore the Great Pyramids and the majestic Sphinx. Discover ancient secrets, capture stunning desert views, and create memories that last a lifetime.",
  );

  final priceController = TextEditingController(text: "1500");

  int durationHours = 4;
  int maxGroupSize = 12;

  final List<Map<String, String>> tourStops = [
    {
      "title": "The Great Pyramid of Khufu",
      "description":
          "Start the journey at the last remaining wonder of the ancient world.",
    },
    {
      "title": "Panorama Plateau",
      "description":
          "Best spot in Giza for breathtaking panoramic views.",
    },
    {
      "title": "The Great Sphinx",
      "description":
          "Discover the iconic guardian with lion body and human head.",
    },
  ];

  final List<String> inclusions = [
    "Lunch included",
    "Entrance Fees",
    "Private Tour Guide",
    "Hotel Pickup",
  ];

  final List<Map<String, dynamic>> extras = [
    {"title": "Camel Ride", "price": 500},
    {"title": "Professional Photoshoot", "price": 300},
    {"title": "Entry: Great Pyramid", "price": 900},
  ];

  final List<String> galleryImages = [
    "assets/images/png/pyramids.jpg",
    "assets/images/png/pyramids.jpg",
    "assets/images/png/pyramids.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FF),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 10.h),

              // =========================
              // App Bar
              // =========================

              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _getStepTitle(),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          _getStepSubtitle(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 40.w),
                ],
              ),

              SizedBox(height: 20.h),

              // =========================
              // Stepper
              // =========================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => _buildStepItem(index + 1),
                ),
              ),

              SizedBox(height: 30.h),

              // =========================
              // Step Body
              // =========================

              if (currentStep == 1) _buildBasicInfoStep(),

              if (currentStep == 2) _buildTourStopsStep(),

              if (currentStep == 3) _buildInclusionsStep(),

              if (currentStep == 4) _buildExtrasStep(),

              if (currentStep == 5) _buildGalleryStep(),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // STEP 1
  // =========================

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _buildLabel("Tour title"),

        SizedBox(height: 8.h),

        _buildTextField(controller: titleController),

        SizedBox(height: 20.h),

        _buildLabel("Description"),

        SizedBox(height: 8.h),

        TextField(
          controller: descriptionController,
          maxLines: 5,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        SizedBox(height: 20.h),

        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildLabel("Duration (Hours)"),

                  SizedBox(height: 10.h),

                  _counterWidget(
                    value: durationHours,
                    onAdd: () =>
                        setState(() => durationHours++),
                    onRemove: () {
                      if (durationHours > 1) {
                        setState(() => durationHours--);
                      }
                    },
                  ),
                ],
              ),
            ),

            SizedBox(width: 15.w),

            Expanded(
              child: Column(
                children: [
                  _buildLabel("Max Group Size"),

                  SizedBox(height: 10.h),

                  _counterWidget(
                    value: maxGroupSize,
                    onAdd: () =>
                        setState(() => maxGroupSize++),
                    onRemove: () {
                      if (maxGroupSize > 1) {
                        setState(() => maxGroupSize--);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        _buildLabel("Price Per Person"),

        SizedBox(height: 8.h),

        TextField(
          controller: priceController,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            suffixText: "EGP",

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        SizedBox(height: 35.h),

        Align(
          alignment: Alignment.centerRight,
          child: _nextButton(),
        ),
      ],
    );
  }

  // =========================
  // STEP 2
  // =========================

  Widget _buildTourStopsStep() {
    return Column(
      children: [
        ...tourStops.asMap().entries.map((entry) {
          final index = entry.key;
          final stop = entry.value;

          return Container(
            margin: EdgeInsets.only(bottom: 15.h),

            padding: EdgeInsets.all(14.sp),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Text(
                      "Stop #${index + 1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const Spacer(),

                    _smallButton("Delete", Colors.red),
                  ],
                ),

                SizedBox(height: 8.h),

                Text(
                  stop["title"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  stop["description"]!,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }),

        SizedBox(height: 10.h),

        Column(
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundColor: AppColors.primaryColor,

              child: Icon(Icons.add, color: Colors.white, size: 30.sp),
            ),

            SizedBox(height: 10.h),

            Text(
              "Add Another Stop",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              "Expand your tour with more locations",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),

        SizedBox(height: 30.h),

        Row(
          children: [
            _backButton(),

            const Spacer(),

            _nextButton(),
          ],
        ),
      ],
    );
  }

  // =========================
  // STEP 3
  // =========================

  Widget _buildInclusionsStep() {
    return Column(
      children: [
        ...inclusions.asMap().entries.map((entry) {
          final index = entry.key;

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),

            child: Row(
              children: [
                Container(
                  width: 35.w,
                  height: 45.h,

                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),

                  alignment: Alignment.center,

                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Container(
                    height: 45.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),

                    alignment: Alignment.centerLeft,

                    child: Text(inclusions[index]),
                  ),
                ),
              ],
            ),
          );
        }),

        SizedBox(height: 10.h),

        TextField(
          decoration: InputDecoration(
            hintText: "e.g. Lunch, Tickets",
            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        SizedBox(height: 30.h),

        Row(
          children: [
            _backButton(),

            const Spacer(),

            _nextButton(),
          ],
        ),
      ],
    );
  }

  // =========================
  // STEP 4
  // =========================

  Widget _buildExtrasStep() {
    return Column(
      children: [
        ...extras.map(
          (extra) => Container(
            margin: EdgeInsets.only(bottom: 12.h),

            padding: EdgeInsets.all(14.sp),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    extra["title"],
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),

                  child: Text(
                    "+ ${extra["price"]} EGP",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 30.h),

        Row(
          children: [
            _backButton(),

            const Spacer(),

            _nextButton(),
          ],
        ),
      ],
    );
  }

  // =========================
  // STEP 5
  // =========================

  Widget _buildGalleryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.r),

          child: Image.asset(
            "assets/images/png/pyramids.jpg",
            width: double.infinity,
            height: 220.h,
            fit: BoxFit.cover,
          ),
        ),

        SizedBox(height: 20.h),

        Text(
          "Recently uploaded",
          style: TextStyle(color: Colors.grey),
        ),

        SizedBox(height: 12.h),

        Row(
          children: galleryImages.map((image) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),

                  child: Image.asset(
                    image,
                    height: 90.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 30.h),

        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),

            onPressed: () {
              _showSuccessDialog();
            },

            child: const Text("Save"),
          ),
        ),
      ],
    );
  }

  // =========================
  // SUCCESS DIALOG
  // =========================

  void _showSuccessDialog() {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            CircleAvatar(
              radius: 45.r,
              backgroundColor: Colors.green,

              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 50.sp,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              "Changes Saved",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              "Your tour details have been updated successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 25.h),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),

                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },

                child: const Text("Back To Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Widgets
  // =========================

  Widget _buildStepItem(int step) {
    final isActive = currentStep == step;
    final isDone = currentStep > step;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),

      child: Column(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: isActive || isDone
                ? AppColors.primaryColor
                : Colors.white,

            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    "$step",
                    style: TextStyle(
                      color:
                          isActive ? Colors.white : AppColors.primaryColor,
                    ),
                  ),
          ),

          SizedBox(height: 8.h),

          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 4.h,
              ),

              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),

              child: Text(
                _getStepName(step),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _counterWidget({
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Row(
      children: [
        Expanded(
          child: _counterButton(
            icon: Icons.add,
            onTap: onAdd,
          ),
        ),

        Container(
          width: 60.w,
          height: 45.h,
          alignment: Alignment.center,

          color: Colors.white,

          child: Text(
            "$value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),

        Expanded(
          child: _counterButton(
            icon: Icons.remove,
            onTap: onRemove,
          ),
        ),
      ],
    );
  }

  Widget _counterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 45.h,

        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),

        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _nextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),

      onPressed: () {
        if (currentStep < 5) {
          setState(() => currentStep++);
        }
      },

      child: const Text("Next"),
    );
  }

  Widget _backButton() {
    return TextButton.icon(
      onPressed: () {
        if (currentStep > 1) {
          setState(() => currentStep--);
        }
      },

      icon: const Icon(Icons.arrow_back_ios, size: 16),
      label: const Text("Back"),
    );
  }

  Widget _smallButton(String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 4.h,
      ),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),

      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 1:
        return "General Details";
      case 2:
        return "Tour Stops";
      case 3:
        return "Inclusions";
      case 4:
        return "Extra Add-ons";
      case 5:
        return "Gallery";
      default:
        return "";
    }
  }

  String _getStepSubtitle() {
    switch (currentStep) {
      case 1:
        return "Start by adjusting the basic info to keep your tour listing accurate.";
      case 2:
        return "Add all places tourists will visit during the trip.";
      case 3:
        return "Add everything included in the tour price.";
      case 4:
        return "Offer optional upgrades and experiences.";
      case 5:
        return "Manage and upload your tour photos.";
      default:
        return "";
    }
  }

  String _getStepName(int step) {
    switch (step) {
      case 1:
        return "Basic Info";
      case 2:
        return "Tour Stops";
      case 3:
        return "Inclusions";
      case 4:
        return "Add-ons";
      case 5:
        return "Gallery";
      default:
        return "";
    }
  }
}