import 'package:admin_storyteller/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowCategory extends StatelessWidget {
  const ShowCategory({super.key});

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
                  child: const Icon(Icons.category_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: AppTheme.heading(22)),
                    Text('Manage all story categories',
                        style: AppTheme.label(13)),
                  ],
                ),
                const Spacer(),
                // Live count badge
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Category')
                      .snapshots(),
                  builder: (context, snap) {
                    final count = snap.data?.docs.length ?? 0;
                    return _CountBadge(count: count, label: 'Total');
                  },
                ),
              ],
            ),
          ),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Category').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.accent),
                  );
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return _EmptyState(
                    icon: Icons.category_outlined,
                    message: 'No categories yet',
                    sub: 'Add one from the sidebar',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(28),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return _CategoryCard(
                      docId: docs[i].id,
                      name: data['name'] ?? '',
                      desc: data['desc'] ?? '',
                      index: i,
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

// ── Category Card ───────────────────────────────────────────────────────────

class _CategoryCard extends StatefulWidget {
  final String docId;
  final String name;
  final String desc;
  final int index;

  const _CategoryCard({
    required this.docId,
    required this.name,
    required this.desc,
    required this.index,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
    ];
    final dot = colors[widget.index % colors.length];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hovered ? AppTheme.card : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                _hovered ? AppTheme.accent.withOpacity(0.4) : AppTheme.border,
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
            // Color dot
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: dot.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.folder_rounded, color: dot, size: 20),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: AppTheme.body(15)),
                  const SizedBox(height: 4),
                  Text(widget.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.body(13, color: AppTheme.textSecondary)),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.edit_rounded,
                  color: AppTheme.accent,
                  tooltip: 'Edit',
                  onTap: () => _showEditDialog(
                      context, widget.docId, widget.name, widget.desc),
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
}

// ── Action Button ───────────────────────────────────────────────────────────

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

// ── Count Badge ─────────────────────────────────────────────────────────────

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

// ── Empty State ─────────────────────────────────────────────────────────────

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

// ── Delete Confirm ──────────────────────────────────────────────────────────

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
          Text('Delete Category', style: AppTheme.heading(16)),
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
            deleteDocument(docId);
            Navigator.pop(ctx);
          },
          child: Text('Delete', style: GoogleFonts.inter(color: Colors.white)),
        ),
      ],
    ),
  );
}

// ── Edit Dialog ─────────────────────────────────────────────────────────────

void _showEditDialog(BuildContext context, String docId, String currentName,
    String currentDesc) {
  final nameCtrl = TextEditingController(text: currentName);
  final descCtrl = TextEditingController(text: currentDesc);

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
          Text('Edit Category', style: AppTheme.heading(16)),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DialogLabel('Category Name'),
            const SizedBox(height: 8),
            TextField(
              controller: nameCtrl,
              style: AppTheme.body(14),
              decoration: AppTheme.inputDecoration('Category name'),
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
          ],
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
            _updateCategory(docId, nameCtrl.text, descCtrl.text);
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

void deleteDocument(String docId) =>
    FirebaseFirestore.instance.collection('Category').doc(docId).delete();

void _updateCategory(String docId, String newName, String newDesc) =>
    FirebaseFirestore.instance.collection('Category').doc(docId).update({
      'name': newName,
      'desc': newDesc,
    });
