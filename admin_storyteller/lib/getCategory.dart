import 'package:admin_storyteller/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetCategory extends StatefulWidget {
  final Function(String) onCategorySelected;
  const GetCategory({super.key, required this.onCategorySelected});

  @override
  State<GetCategory> createState() => _GetCategoryState();
}

class _GetCategoryState extends State<GetCategory> {
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('Category').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppTheme.accent),
          );
        }
        final categories = snapshot.data!.docs
            .map((doc) => {'id': doc.id, 'name': doc['name'] as String})
            .toList();

        if (categories.isEmpty) {
          return Text('No categories available',
              style: AppTheme.body(13, color: AppTheme.textSecondary));
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedId,
            isExpanded: true,
            dropdownColor: AppTheme.card,
            iconEnabledColor: AppTheme.textSecondary,
            hint: Text('Select a category',
                style:
                    AppTheme.body(14, color: AppTheme.textSecondary)),
            style: GoogleFonts.inter(
                fontSize: 14, color: AppTheme.textPrimary),
            items: categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat['id'],
                child: Text(cat['name']!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    )),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedId = value);
              widget.onCategorySelected(value!);
            },
          ),
        );
      },
    );
  }
}
