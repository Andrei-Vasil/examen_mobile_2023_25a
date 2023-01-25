import 'package:flutter/material.dart';
import 'package:my_albums_flutter/repo/entity_repo.dart';

import '../../../models/entity.dart';
import '../../../theme/app_colors.dart';

class EntityListTile extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onInc;
  final Item entity;

  const EntityListTile({
    Key? key,
    required this.entity,
    this.onEdit,
    this.onDelete,
    this.onInc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        minVerticalPadding: 7,
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: AppColors.primaryColor.withOpacity(0.25),
        title: Text(
          entity.name ?? "",
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (onInc != null)
            IconButton(
              onPressed: onInc,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          if (onDelete != null && !EntityRepo.useLocal)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          const Icon(
            Icons.info_outline,
            color: Colors.white70,
          ),
        ]),
        onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(entity.name ?? ""),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entity.description ?? ""),
                      Text(entity.image ?? ""),
                      Text(entity.category ?? ""),
                      Text(entity.units.toString()),
                      Text(entity.price.toString()),
                    ],
                  ),
                )),
      ),
    );
  }
}
