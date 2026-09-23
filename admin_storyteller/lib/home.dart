import 'package:admin_storyteller/app_theme.dart';
import 'package:admin_storyteller/category.dart';
import 'package:admin_storyteller/displayCategory.dart';
import 'package:admin_storyteller/displayStory.dart';
import 'package:admin_storyteller/story.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.add_box_rounded,        label: 'Add Category'),
    _NavItem(icon: Icons.auto_stories_rounded,   label: 'Add Story'),
    _NavItem(icon: Icons.category_rounded,       label: 'Categories'),
    _NavItem(icon: Icons.menu_book_rounded,      label: 'Stories'),
  ];

  final List<Widget> _pages = const [
    Category(),
    Story(),
    ShowCategory(),
    ShowStory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Row(
        children: [
          // ── Sidebar ───────────────────────────────────────────────────────
          Container(
            width: 240,
            decoration: const BoxDecoration(
              color: AppTheme.sidebar,
              border: Border(
                right: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo area
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_stories,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('StoryTeller',
                              style: AppTheme.heading(15)),
                          Text('Admin Panel',
                              style: AppTheme.label(11)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Section label
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Text('NAVIGATION',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.2,
                      )),
                ),

                // Nav Items
                ...List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final selected = _selectedIndex == i;
                  return _SidebarTile(
                    item: item,
                    selected: selected,
                    onTap: () => setState(() => _selectedIndex = i),
                  );
                }),

                const Spacer(),

                // Footer
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: AppTheme.cardDecoration(radius: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            AppTheme.accent.withOpacity(0.2),
                        child: const Icon(Icons.person_rounded,
                            color: AppTheme.accent, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin',
                              style: AppTheme.body(13)),
                          Text('Super User',
                              style: AppTheme.label(11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Main Content ─────────────────────────────────────────────────
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// ── Nav Item Model ─────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ── Sidebar Tile ───────────────────────────────────────────────────────────

class _SidebarTile extends StatefulWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.selected || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.accent.withOpacity(0.15)
                : _hovered
                    ? AppTheme.border.withOpacity(0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.selected
                ? Border.all(color: AppTheme.accent.withOpacity(0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.item.icon,
                size: 18,
                color: widget.selected
                    ? AppTheme.accent
                    : active
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                widget.item.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: widget.selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: widget.selected
                      ? AppTheme.accent
                      : active
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                ),
              ),
              if (widget.selected) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
