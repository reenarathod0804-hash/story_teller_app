import 'package:admin_storyteller/app_theme.dart';
import 'package:admin_storyteller/getCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Story extends StatefulWidget {
  const Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  var collection = FirebaseFirestore.instance.collection('Story');
  final TextEditingController storyDescController = TextEditingController();
  final TextEditingController storyNameController  = TextEditingController();
  final TextEditingController _urlController       = TextEditingController();
  String? category;

  void addData() {
    if (storyNameController.text.trim().isEmpty || category == null) return;
    collection.add({
      'story_name': storyNameController.text.trim(),
      'story_desc': storyDescController.text.trim(),
      'image':      _urlController.text.trim(),
      'category_id': category,
    }).then((_) => clearData());
  }

  void clearData() {
    storyDescController.clear();
    storyNameController.clear();
    _urlController.clear();
    setState(() => category = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page header ───────────────────────────────────────────────
            _PageHeader(
              title: 'Add Story',
              subtitle: 'Add a new story to a category',
              icon: Icons.auto_stories_rounded,
            ),
            const SizedBox(height: 32),

            // ── Form card ─────────────────────────────────────────────────
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: AppTheme.cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Story Details', style: AppTheme.heading(16)),
                      const SizedBox(height: 24),

                      _FieldLabel('Story Title'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: storyNameController,
                        style: AppTheme.body(14),
                        decoration: AppTheme.inputDecoration(
                            'Enter story title',
                            icon: Icons.title_rounded),
                      ),

                      const SizedBox(height: 20),

                      _FieldLabel('Story Description'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: storyDescController,
                        style: AppTheme.body(14),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: AppTheme.inputDecoration(
                            'Enter story description',
                            icon: Icons.description_rounded),
                      ),

                      const SizedBox(height: 20),

                      _FieldLabel('Image URL'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _urlController,
                        style: AppTheme.body(14),
                        decoration: AppTheme.inputDecoration(
                            'https://…',
                            icon: Icons.image_rounded),
                      ),

                      const SizedBox(height: 20),

                      _FieldLabel('Category'),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: GetCategory(
                          onCategorySelected: (id) =>
                              setState(() => category = id),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: _GradientButton(
                          label: 'Add Story',
                          icon: Icons.add_rounded,
                          onPressed: addData,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ──────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.accentGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.heading(22)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTheme.label(13)),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary,
        ));
  }
}

class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: AppTheme.accentGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.accent.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(widget.label,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
