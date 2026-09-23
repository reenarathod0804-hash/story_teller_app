import 'package:admin_storyteller/app_theme.dart';
import 'package:admin_storyteller/getCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowStory extends StatefulWidget {
  const ShowStory({super.key});

  @override
  State<ShowStory> createState() => _ShowStoryState();
}

class _ShowStoryState extends State<ShowStory> {
  Map<String, String> categoryMap = {};

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final snap =
        await FirebaseFirestore.instance.collection('Category').get();
    final map = <String, String>{};
    for (final doc in snap.docs) {
      map[doc.id] = doc['name'] as String;
    }
    setState(() => categoryMap = map);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(36, 32, 36, 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stories', style: AppTheme.heading(22)),
                    Text('Browse and manage all stories',
                        style: AppTheme.label(13)),
                  ],
                ),
                const Spacer(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Story')
                      .snapshots(),
                  builder: (context, snap) {
                    final count = snap.data?.docs.length ?? 0;
                    return _CountBadge(count: count, label: 'Total');
                  },
                ),
              ],
            ),
          ),

          // ── Story list ────────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Story').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.accent),
                  );
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return _EmptyState(
                    icon: Icons.menu_book_outlined,
                    message: 'No stories yet',
                    sub: 'Add one from the sidebar',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(28),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data =
                        docs[i].data() as Map<String, dynamic>;
                    final catId = data['category_id'] as String? ?? '';
                    final catName =
                        categoryMap[catId] ?? 'Unknown Category';
                    return _StoryCard(
                      docId: docs[i].id,
                      data: data,
                      categoryName: catName,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Story Card ──────────────────────────────────────────────────────────────

class _StoryCard extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;
  final String categoryName;

  const _StoryCard({
    required this.docId,
    required this.data,
    required this.categoryName,
  });

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.data['image'] as String? ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered ? AppTheme.card : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? AppTheme.accent.withOpacity(0.4)
                : AppTheme.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // ── Thumbnail ─────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),
            const SizedBox(width: 16),

            // ── Text ──────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(widget.categoryName,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accent,
                        )),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.data['story_name'] ?? '',
                    style: AppTheme.body(15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.data['story_desc'] ?? '',
                    style: AppTheme.body(13,
                        color: AppTheme.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Actions ───────────────────────────────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.edit_rounded,
                  color: AppTheme.accent,
                  tooltip: 'Edit',
                  onTap: () => _showEditDialog(
                    context,
                    widget.docId,
                    widget.data['story_name'] ?? '',
                    widget.data['story_desc'] ?? '',
                    widget.data['image'] ?? '',
                  ),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.delete_rounded,
                  color: AppTheme.danger,
                  tooltip: 'Delete',
                  onTap: () => _confirmDelete(context, widget.docId),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        color: AppTheme.card,
        child: const Icon(Icons.broken_image_rounded,
            color: AppTheme.border, size: 28),
      );
}

// ── Reused widgets ──────────────────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withOpacity(0.18)
                  : widget.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, color: widget.color, size: 16),
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final String label;
  const _CountBadge({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count',
              style: GoogleFonts.inter(
                color: AppTheme.accent,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              )),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.inter(
                color: AppTheme.accent.withOpacity(0.8),
                fontSize: 12,
              )),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;
  const _EmptyState(
      {required this.icon, required this.message, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppTheme.border),
          const SizedBox(height: 16),
          Text(message, style: AppTheme.heading(18)),
          const SizedBox(height: 6),
          Text(sub, style: AppTheme.label(13)),
        ],
      ),
    );
  }
}

// ── Dialogs ─────────────────────────────────────────────────────────────────

void _confirmDelete(BuildContext context, String docId) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.border),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.danger.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete_rounded,
                color: AppTheme.danger, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Delete Story', style: AppTheme.heading(16)),
        ],
      ),
      content: Text('Are you sure? This cannot be undone.',
          style: AppTheme.body(14, color: AppTheme.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel',
              style: GoogleFonts.inter(color: AppTheme.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
          onPressed: () {
            _deleteDocument(docId);
            Navigator.pop(ctx);
          },
          child: Text('Delete',
              style: GoogleFonts.inter(color: Colors.white)),
        ),
      ],
    ),
  );
}

void _showEditDialog(BuildContext context, String docId, String name,
    String desc, String image) {
  String? category;
  final nameCtrl  = TextEditingController(text: name);
  final descCtrl  = TextEditingController(text: desc);
  final imageCtrl = TextEditingController(text: image);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.border),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit_rounded,
                color: AppTheme.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Edit Story', style: AppTheme.heading(16)),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DialogLabel('Category'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: GetCategory(
                  onCategorySelected: (id) => category = id,
                ),
              ),
              const SizedBox(height: 16),
              _DialogLabel('Story Title'),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                style: AppTheme.body(14),
                decoration: AppTheme.inputDecoration('Story title'),
              ),
              const SizedBox(height: 16),
              _DialogLabel('Description'),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                style: AppTheme.body(14),
                maxLines: 4,
                decoration: AppTheme.inputDecoration('Description'),
              ),
              const SizedBox(height: 16),
              _DialogLabel('Image URL'),
              const SizedBox(height: 8),
              TextField(
                controller: imageCtrl,
                style: AppTheme.body(14),
                decoration:
                    AppTheme.inputDecoration('https://…'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel',
              style: GoogleFonts.inter(color: AppTheme.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            _updateStory(docId, nameCtrl.text, descCtrl.text, imageCtrl.text);
            if (category != null) _updateCategory(docId, category!);
            Navigator.pop(ctx);
          },
          child: Text('Save Changes',
              style: GoogleFonts.inter(color: Colors.white)),
        ),
      ],
    ),
  );
}

class _DialogLabel extends StatelessWidget {
  final String text;
  const _DialogLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary));
}

// ── Firestore helpers ────────────────────────────────────────────────────────

void _deleteDocument(String docId) =>
    FirebaseFirestore.instance.collection('Story').doc(docId).delete();

void _updateStory(
    String docId, String name, String desc, String image) =>
    FirebaseFirestore.instance.collection('Story').doc(docId).update({
      'story_name': name,
      'story_desc': desc,
      'image': image,
    });

void _updateCategory(String docId, String categoryId) =>
    FirebaseFirestore.instance.collection('Story').doc(docId).update({
      'category_id': categoryId,
    });
