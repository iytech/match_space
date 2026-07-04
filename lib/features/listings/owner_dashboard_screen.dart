import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/status_chip.dart';
import '../../models/property.dart';
import '../../providers/auth_provider.dart';
import '../../providers/currency_provider.dart';
import '../../services/property_service.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});
  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final _service = PropertyService();
  List<Property> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = context.read<AuthProvider>().profile?.id;
    if (uid != null) _items = await _service.fetchByOwner(uid);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(Property p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete listing?'),
        content: Text('"${p.title}" will be permanently removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ruby),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _service.delete(p.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My listings'),
        actions: [
          IconButton(
            tooltip: 'Analytics',
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, '/analytics'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-listing')
            .then((_) => _load()),
        backgroundColor: AppColors.terracotta,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New listing',
            style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(
                  icon: Icons.home_work_outlined,
                  title: 'No listings yet',
                  message: 'Create your first listing to start reaching buyers.',
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/create-listing')
                            .then((_) => _load()),
                    child: const Text('List a property'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final p = _items[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: p.coverUrl.isEmpty
                              ? Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.surfaceAlt)
                              : CachedNetworkImage(
                                  imageUrl: p.coverUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                  child: Text(p.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15)),
                                ),
                                StatusChip(status: p.status),
                              ]),
                              const SizedBox(height: 4),
                              Text(currency.price(p.price),
                                  style: const TextStyle(
                                      color: AppColors.terracotta,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Row(children: [
                                const Icon(Icons.visibility_outlined,
                                    size: 14, color: AppColors.inkSoft),
                                const SizedBox(width: 4),
                                Text('${p.viewCount} views',
                                    style: const TextStyle(
                                        color: AppColors.inkSoft,
                                        fontSize: 13)),
                                if (p.featured) ...[
                                  const SizedBox(width: 10),
                                  const Icon(Icons.star_rounded,
                                      size: 14, color: AppColors.ochre),
                                  const Text(' Featured',
                                      style: TextStyle(
                                          color: AppColors.ochre,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ]),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.ruby),
                          onPressed: () => _delete(p),
                        ),
                      ]),
                    );
                  },
                ),
    );
  }
}
