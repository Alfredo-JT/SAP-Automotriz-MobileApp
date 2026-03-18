import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

class QuoteLineItemsPreview extends StatefulWidget {
  final List<QuoteLineItem> lineItems;
  final double total;

  const QuoteLineItemsPreview({
    super.key,
    required this.lineItems,
    required this.total,
  });

  @override
  State<QuoteLineItemsPreview> createState() => _QuoteLineItemsPreviewState();
}

class _QuoteLineItemsPreviewState extends State<QuoteLineItemsPreview> {
  bool _expanded = false;

  Color _itemTypeColor(String type) {
    switch (type) {
      case 'spare_part':
        return const Color(0xFF2563EB);
      case 'labor':
        return AppColors.crimsonRed;
      case 'additional_expense':
        return AppColors.golden;
      case 'external_service':
        return const Color(0xFF7C3AED);
      default:
        return AppColors.warmGray;
    }
  }

  String _itemTypeLabel(String type) {
    switch (type) {
      case 'spare_part':
        return 'Refacción';
      case 'labor':
        return 'Mano de obra';
      case 'additional_expense':
        return 'Gasto adicional';
      case 'external_service':
        return 'Servicio externo';
      default:
        return 'Otro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header — siempre visible, toca para expandir
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2563EB).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 14,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.lineItems.length} concepto${widget.lineItems.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${widget.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable list
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEDE5DC)),
            ),
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5EDE4),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(7),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmGray,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Tipo',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmGray,
                          ),
                        ),
                      ),
                      Text(
                        'Cant.',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warmGray,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Total',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Items
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.lineItems.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFEDE5DC)),
                  itemBuilder: (_, i) {
                    final item = widget.lineItems[i];
                    final type = item.itemType.value;
                    final color = _itemTypeColor(type);
                    final qty = item.quantity ?? 1;
                    final total = (item.totalAmount as num?)?.toDouble() ?? 0.0;
                    final unit = item.unit;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Row(
                        children: [
                          // Descripción
                          Expanded(
                            flex: 4,
                            child: Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ),
                          // Tipo badge
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _itemTypeLabel(type),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Cantidad
                          Text(
                            '$qty${unit != null ? ' $unit' : ''}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.warmGray,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Total
                          Expanded(
                            child: Text(
                              '\$${total.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Footer con IVA si aplica
                if (widget.lineItems.any((i) => i.taxable == true)) ...[
                  const Divider(height: 1, color: Color(0xFFEDE5DC)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Incluye IVA en algunos conceptos',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.warmGray,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
