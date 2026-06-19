import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_detail_model.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

/// Pass [tourData] for instant pre-fill (e.g. from detail screen).
/// Pass only [tourId] to fetch from API first (e.g. from tours list).
/// Pass nothing for create flow.
class EditTourScreen extends StatefulWidget {
  final GuideTourDetailModel? tourData;
  final String? tourId;

  const EditTourScreen({super.key, this.tourData, this.tourId});

  @override
  State<EditTourScreen> createState() => _EditTourScreenState();
}

class _EditTourScreenState extends State<EditTourScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _maxGroupCtrl;

  // Stops: [{Title, Description, orderIndex, PlaceId}]
  List<Map<String, dynamic>> _stops = [];
  // Inclusions: [{Description, Type}]
  List<Map<String, dynamic>> _inclusions = [];
  // Add-ons: [{Title, Price}]
  List<Map<String, dynamic>> _addOns = [];
  // Slots (create mode only): [{date, startTime, endTime, capacity}]
  List<Map<String, dynamic>> _slots = [];
  // New images selected from device
  List<File> _selectedImages = [];

  bool _isLoading = false;
  bool _loadingDetails = false;

  // Tracks pending slot creation after tour is created
  String? _pendingTourId;
  int _pendingSlotIndex = 0;

  bool get _isEditMode => widget.tourId != null || widget.tourData != null;

  // ─── Init / Dispose ───────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _titleCtrl    = TextEditingController();
    _descCtrl     = TextEditingController();
    _priceCtrl    = TextEditingController();
    _durationCtrl = TextEditingController();
    _maxGroupCtrl = TextEditingController();

    if (widget.tourData != null) {
      _fillFromModel(widget.tourData!);
    } else if (widget.tourId != null) {
      _loadingDetails = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<GuideDashboardCubit>().fetchTourDetails(
            id: widget.tourId!,
          );
        }
      });
    }
  }

  void _fillFromModel(GuideTourDetailModel m) {
    _titleCtrl.text    = m.title;
    _descCtrl.text     = m.description;
    _priceCtrl.text    = m.price > 0 ? m.price.toStringAsFixed(0) : '';
    _durationCtrl.text = m.durationHours > 0 ? m.durationHours.toString() : '';
    _maxGroupCtrl.text = '';
    // Use backend-matching shapes for all sub-lists
    _inclusions = m.inclusions
        .map((e) => {'Description': e.description, 'Type': e.type})
        .toList();
    _stops = m.stops
        .map((s) => {
              'Title':       s.title,
              'Description': s.description,
              'orderIndex':  s.orderIndex,
              'PlaceId':     s.placeId,
            })
        .toList();
    _addOns = m.addOns
        .map((a) => {'Title': a.title, 'Price': a.price})
        .toList();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    _maxGroupCtrl.dispose();
    super.dispose();
  }

  // ─── Images ───────────────────────────────────────────────────────────────

  Future<void> _pickImages(ImageSource source) async {
    try {
      final picker = ImagePicker();
      if (source == ImageSource.gallery) {
        final files = await picker.pickMultiImage();
        if (files.isNotEmpty) {
          setState(() => _selectedImages.addAll(files.map((f) => File(f.path))));
        }
      } else {
        final file = await picker.pickImage(source: source);
        if (file != null) setState(() => _selectedImages.add(File(file.path)));
      }
    } catch (e) {
      _showError('Could not pick image: $e');
    }
  }

  // ─── Payload — exact Swagger casing ──────────────────────────────────────

  Map<String, dynamic> _buildPayload() {
    // Filter out entries with empty required fields before sending
    final cleanStops = _stops
        .where((s) => (s['Title']?.toString().trim() ?? '').isNotEmpty)
        .toList();
    final cleanInclusions = _inclusions
        .where((i) => (i['Description']?.toString().trim() ?? '').isNotEmpty)
        .toList();
    final cleanAddOns = _addOns
        .where((a) => (a['Title']?.toString().trim() ?? '').isNotEmpty)
        .toList();

    return {
      'Title':         _titleCtrl.text.trim(),
      'Description':   _descCtrl.text.trim(),
      'Price':         double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      'DurationHours': int.tryParse(_durationCtrl.text.trim()) ?? 0,
      'MaxGroupSize':  int.tryParse(_maxGroupCtrl.text.trim()) ?? 0,
      'Inclusions':    cleanInclusions,   // [{Description, Type}]
      'StopsJson':     cleanStops,        // [{Title, Description, orderIndex, PlaceId}]
      'AddOnsJson':    cleanAddOns,       // [{Title, Price}]
      'Images':        _selectedImages.map((f) => f.path).toList(),
    };
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final payload = _buildPayload();
    if (_isEditMode && widget.tourId != null) {
      context.read<GuideDashboardCubit>().editTour(
            id: widget.tourId!,
            tourData: payload,
          );
    } else {
      context.read<GuideDashboardCubit>().createTour(tourData: payload);
    }
  }

  // ─── Dialogs ──────────────────────────────────────────────────────────────

  // Inclusion: {Description, Type: "Included"|"Excluded"}
  void _showInclusionDialog() {
    final descCtrl = TextEditingController();
    String selectedType = 'Included';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Add Inclusion', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DialogTextField(ctrl: descCtrl, hint: 'e.g. Lunch included'),
              SizedBox(height: 12.h),
              Text('Type', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 6.h),
              Row(
                children: ['Included', 'Excluded'].map((t) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setD(() => selectedType = t),
                      child: Container(
                        margin: EdgeInsets.only(right: t == 'Included' ? 6.w : 0),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: selectedType == t
                              ? (t == 'Included' ? AppColors.primaryColor : AppColors.redAppColor)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: selectedType == t
                                ? Colors.transparent
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: selectedType == t ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () {
                if (descCtrl.text.trim().isNotEmpty) {
                  setState(() => _inclusions.add({
                        'Description': descCtrl.text.trim(),
                        'Type': selectedType,
                      }));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Stop: {Title, Description, orderIndex (auto), PlaceId (required, >= 1)}
  void _showStopDialog() {
    final nameCtrl    = TextEditingController();
    final descCtrl    = TextEditingController();
    final placeIdCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Add Tour Stop',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogTextField(ctrl: nameCtrl, hint: 'Stop name (e.g. Sphinx)'),
            SizedBox(height: 10.h),
            _DialogTextField(
                ctrl: descCtrl, hint: 'Short description (optional)'),
            SizedBox(height: 10.h),
            _DialogTextField(
              ctrl: placeIdCtrl,
              hint: 'Place ID (number, e.g. 1)',
              isNumber: true,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final placeId = int.tryParse(placeIdCtrl.text.trim()) ?? 0;
              if (name.isEmpty) return;
              if (placeId < 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Place ID must be a valid number (≥ 1)'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              setState(() => _stops.add({
                    'Title':       name,
                    'Description': descCtrl.text.trim(),
                    'orderIndex':  _stops.length + 1,
                    'PlaceId':     placeId,
                  }));
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // AddOn: {Title, Price}  — backend uses capital T and P
  void _showAddOnDialog() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    _showDialog(
      title: 'Add Add-on',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DialogTextField(ctrl: titleCtrl, hint: 'e.g. Photography Session'),
          SizedBox(height: 10.h),
          _DialogTextField(ctrl: priceCtrl, hint: 'Price (EGP)', isNumber: true),
        ],
      ),
      onConfirm: () {
        if (titleCtrl.text.trim().isNotEmpty) {
          setState(() => _addOns.add({
                'Title': titleCtrl.text.trim(),
                'Price': double.tryParse(priceCtrl.text.trim()) ?? 0.0,
              }));
        }
      },
    );
  }

  void _showDialog({
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () {
              onConfirm();
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _createNextSlot(BuildContext context) {
    if (_pendingTourId == null ||
        _pendingTourId!.isEmpty ||
        _pendingSlotIndex >= _slots.length) return;
    final slot = _slots[_pendingSlotIndex];
    debugPrint(
      '══ createSlot [$_pendingSlotIndex/${_slots.length}] '
      'tourId="$_pendingTourId" date="${slot['date']}" '
      'start="${slot['startTime']}" end="${slot['endTime']}" cap="${slot['capacity']}"',
    );
    context.read<GuideDashboardCubit>().createSlot(
          tourId: _pendingTourId!,
          date: slot['date'] as String,
          startTime: slot['startTime'] as String,
          endTime: slot['endTime'] as String,
          capacity: slot['capacity'] as int,
        );
  }

  Future<void> _showSlotDialog() async {
    DateTime? pickedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    final capacityCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title:
              Text('Add Booking Slot', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text('Date', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setDialogState(() => pickedDate = d);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      pickedDate != null
                          ? '${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}'
                          : 'Select date...',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: pickedDate != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Start Time
                Text('Start Time', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (t != null) setDialogState(() => startTime = t);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      startTime != null
                          ? '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00'
                          : 'Select start time...',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: startTime != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // End Time
                Text('End Time', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: const TimeOfDay(hour: 17, minute: 0),
                    );
                    if (t != null) setDialogState(() => endTime = t);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      endTime != null
                          ? '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00'
                          : 'Select end time...',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: endTime != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Capacity
                Text('Capacity', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                TextField(
                  controller: capacityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'e.g. 30',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () {
                if (pickedDate == null || startTime == null || endTime == null) return;
                final cap = int.tryParse(capacityCtrl.text.trim()) ?? 0;
                if (cap <= 0) return;
                setState(() {
                  _slots.add({
                    'date': '${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}',
                    'startTime': '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00',
                    'endTime': '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00',
                    'capacity': cap,
                  });
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditMode
              ? LocaleKeys.edit_tour.tr()
              : LocaleKeys.createTour.tr(),
          style: AppTextStyle.primaryPoppinsTextW600S18
              .copyWith(color: Colors.black),
        ),
      ),
      body: BlocListener<GuideDashboardCubit, GuideDashboardState>(
        listener: (context, state) {
          if (state is GetTourDetailsSuccess) {
            setState(() {
              _loadingDetails = false;
              _fillFromModel(state.tourDetailModel);
            });
            return;
          }
          if (state is GetTourDetailsFailure) {
            setState(() => _loadingDetails = false);
            _showError(state.errorMessage);
            return;
          }
          if (state is CreateTourSuccess) {
            if (_slots.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.tour_created.tr()),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else {
              // Start creating slots one by one
              _pendingTourId = state.tourId;
              _pendingSlotIndex = 0;
              _createNextSlot(context);
            }
            return;
          }
          if (state is EditTourSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.tour_updated.tr()),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
            return;
          }
          if (state is CreateSlotSuccess) {
            _pendingSlotIndex++;
            if (_pendingSlotIndex < _slots.length) {
              _createNextSlot(context);
            } else {
              // All slots created
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.tour_created.tr()),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            }
            return;
          }
          if (state is CreateSlotFailure) {
            setState(() => _isLoading = false);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r)),
                title: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 22.sp),
                    SizedBox(width: 8.w),
                    const Text('Slot Creation Failed'),
                  ],
                ),
                content: Text(
                  'Tour was created, but slot #${_pendingSlotIndex + 1} failed:\n\n${state.errorMessage}',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx); // close dialog
                      Navigator.pop(context, true); // go back
                    },
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _createNextSlot(context); // retry same slot
                    },
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
            return;
          }
          if (state is CreateTourFailure) _showError(state.errorMessage);
          if (state is EditTourFailure)   _showError(state.errorMessage);
        },
        child: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
          buildWhen: (_, s) =>
              s is CreateTourLoading ||
              s is CreateTourSuccess ||
              s is CreateTourFailure ||
              s is EditTourLoading ||
              s is EditTourSuccess ||
              s is EditTourFailure ||
              s is CreateSlotLoading ||
              s is CreateSlotSuccess ||
              s is CreateSlotFailure ||
              s is GetTourDetailsLoading ||
              s is GetTourDetailsSuccess ||
              s is GetTourDetailsFailure,
          builder: (context, state) {
            _isLoading = state is CreateTourLoading ||
                state is EditTourLoading ||
                state is CreateSlotLoading;

            if (_loadingDetails || state is GetTourDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── 1. Basic Info ──────────────────────────────────────
                    _SectionCard(
                      title: 'Basic Information',
                      icon: Icons.info_outline_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel(LocaleKeys.tour_title.tr()),
                          _Field(
                            controller: _titleCtrl,
                            hint: 'e.g. Pyramids Luxury Day Tour',
                          ),
                          SizedBox(height: 14.h),
                          _FieldLabel(LocaleKeys.tour_desc.tr()),
                          _Field(
                            controller: _descCtrl,
                            hint:
                                'Describe the trip schedule and experience...',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ── 2. Pricing & Capacity ──────────────────────────────
                    _SectionCard(
                      title: 'Pricing & Capacity',
                      icon: Icons.attach_money_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(
                                        LocaleKeys.duration_hours.tr()),
                                    _Field(
                                      controller: _durationCtrl,
                                      hint: '4',
                                      isNumber: true,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(
                                        LocaleKeys.max_group_size.tr()),
                                    _Field(
                                      controller: _maxGroupCtrl,
                                      hint: '10',
                                      isNumber: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          _FieldLabel('Price Per Person (EGP)'),
                          _Field(
                            controller: _priceCtrl,
                            hint: '1200',
                            isNumber: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ── 3. Stops ───────────────────────────────────────────
                    _SectionCard(
                      title: LocaleKeys.stops.tr(),
                      icon: Icons.place_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._stops.asMap().entries.map(
                                (e) => ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Text(
                                      '${e.key + 1}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    e.value['Title']?.toString() ?? '',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  subtitle: e.value['Description']?.toString().isNotEmpty == true
                                      ? Text(
                                          e.value['Description'].toString(),
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.grey400Color),
                                        )
                                      : null,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red, size: 18),
                                    onPressed: () => setState(
                                        () => _stops.removeAt(e.key)),
                                  ),
                                ),
                              ),
                          TextButton.icon(
                            onPressed: _showStopDialog,
                            icon: const Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.primaryColor),
                            label: Text(
                              LocaleKeys.add_stop.tr(),
                              style: const TextStyle(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ── 4. Inclusions ──────────────────────────────────────
                    _SectionCard(
                      title: LocaleKeys.inclusions.tr(),
                      icon: Icons.check_circle_outline_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: _inclusions.asMap().entries
                                .map(
                                  (e) {
                                    final desc = e.value['Description']?.toString() ?? '';
                                    final type = e.value['Type']?.toString() ?? 'Included';
                                    final isExcluded = type == 'Excluded';
                                    return Chip(
                                      avatar: Icon(
                                        isExcluded ? Icons.remove_circle_outline : Icons.check_circle_outline,
                                        size: 14.sp,
                                        color: isExcluded ? Colors.red : AppColors.primaryColor,
                                      ),
                                      label: Text(desc, style: TextStyle(fontSize: 12.sp)),
                                      backgroundColor: isExcluded
                                          ? Colors.red.withOpacity(0.07)
                                          : AppColors.primaryColor.withOpacity(0.08),
                                      deleteIconColor: Colors.red,
                                      onDeleted: () => setState(() => _inclusions.removeAt(e.key)),
                                    );
                                  },
                                )
                                .toList(),
                          ),
                          if (_inclusions.isNotEmpty) SizedBox(height: 4.h),
                          TextButton.icon(
                            onPressed: _showInclusionDialog,
                            icon: const Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.primaryColor),
                            label: Text(
                              LocaleKeys.add_inclusion.tr(),
                              style: const TextStyle(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ── 5. Add-Ons ─────────────────────────────────────────
                    _SectionCard(
                      title: LocaleKeys.addons.tr(),
                      icon: Icons.extension_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._addOns.asMap().entries.map(
                            (e) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                e.value['Title']?.toString() ?? '',
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${e.value['Price']} EGP',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red, size: 18),
                                    onPressed: () =>
                                        setState(() => _addOns.removeAt(e.key)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _showAddOnDialog,
                            icon: const Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.primaryColor),
                            label: Text(
                              LocaleKeys.add_addon.tr(),
                              style: const TextStyle(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ── 6. Booking Slots (Create mode only) ───────────────
                    if (!_isEditMode) ...[
                      _SectionCard(
                        title: 'Booking Slots',
                        icon: Icons.calendar_month_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._slots.asMap().entries.map(
                                  (e) => Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.primaryColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color:
                                            AppColors.primaryColor.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.event,
                                            size: 16.sp,
                                            color: AppColors.primaryColor),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.value['date'] as String,
                                                style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                '${e.value['startTime']} → ${e.value['endTime']}  •  ${e.value['capacity']} seats',
                                                style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: AppColors.grey400Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red, size: 18),
                                          onPressed: () => setState(
                                              () => _slots.removeAt(e.key)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            TextButton.icon(
                              onPressed: _showSlotDialog,
                              icon: const Icon(Icons.add_circle_outline_rounded,
                                  color: AppColors.primaryColor),
                              label: const Text(
                                'Add Slot',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                    ],

                    // ── 7. Media Gallery ───────────────────────────────────
                    _SectionCard(
                      title: 'Tour Media Gallery',
                      icon: Icons.collections_rounded,
                      child: Column(
                        children: [
                          if (_selectedImages.isNotEmpty) ...[
                            _ImageGrid(
                              images: _selectedImages,
                              onRemove: (i) =>
                                  setState(() => _selectedImages.removeAt(i)),
                            ),
                            SizedBox(height: 8.h),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: _MediaButton(
                                  label:
                                      LocaleKeys.upload_from_camera.tr(),
                                  icon: Icons.camera_alt_outlined,
                                  onTap: () =>
                                      _pickImages(ImageSource.camera),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _MediaButton(
                                  label:
                                      LocaleKeys.upload_from_gallery.tr(),
                                  icon: Icons.photo_library_outlined,
                                  onTap: () =>
                                      _pickImages(ImageSource.gallery),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // ── Submit ─────────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          disabledBackgroundColor:
                              AppColors.primaryColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? SizedBox(
                                height: 22.h,
                                width: 22.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                _isEditMode
                                    ? LocaleKeys.edit_tour.tr()
                                    : LocaleKeys.createTour.tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Reusable private sub-widgets ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyle.primaryPoppinsTextW600S18
                    .copyWith(fontSize: 15.sp),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.8),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.isNumber = false,
  });
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'This field is required' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
        filled: true,
        fillColor: const Color(0xfff9f9fc),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
              BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    required this.ctrl,
    required this.hint,
    this.isNumber = false,
  });
  final TextEditingController ctrl;
  final String hint;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      autofocus: !isNumber,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.images, required this.onRemove});
  final List<File> images;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
      ),
      itemCount: images.length,
      itemBuilder: (_, i) => Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.file(images[i], fit: BoxFit.cover),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => onRemove(i),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  const _MediaButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
