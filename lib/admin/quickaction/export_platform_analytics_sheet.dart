import 'package:flutter/material.dart';

/// Call this function from your Admin Dashboard or Subgroup Header:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => const ExportPlatformAnalyticsSheet(),
/// );
/// ```
class ExportPlatformAnalyticsSheet extends StatefulWidget {
  final String? filterProgram;

  const ExportPlatformAnalyticsSheet({super.key, this.filterProgram});

  @override
  State<ExportPlatformAnalyticsSheet> createState() =>
      _ExportPlatformAnalyticsSheetState();
}

class _ExportPlatformAnalyticsSheetState
    extends State<ExportPlatformAnalyticsSheet> {
  String _selectedTimeframe = 'This Cohort';
  String _selectedExportFormat = 'CSV';
  bool _isExporting = false;

  // Selected Metrics to include in export
  final Map<String, bool> _includedMetrics = {
    'Student Attendance & Activity': true,
    'Deliverable Submission Rates': true,
    'Subgroup Communication Velocity': true,
    'At-Risk Student Flag History': true,
    'Peer Review & Team Lead Scores': false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sheet Title & Subtitle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Color(0xFF6366F1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Export Analytics Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        widget.filterProgram ?? 'All Enrolled Cohorts & Subgroups',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section 1: Quick Metric Overview Summary
            const Text(
              'Cohort Overview Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryStat('88%', 'Completion Rate', const Color(0xFF16A34A)),
                  _buildDivider(),
                  _buildSummaryStat('142', 'Active Students', const Color(0xFF6366F1)),
                  _buildDivider(),
                  _buildSummaryStat('5', 'At-Risk Flags', const Color(0xFFDC2626)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section 2: Timeframe Filter
            const Text(
              'Select Timeframe',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Last 7 Days', 'Last 30 Days', 'This Cohort']
                  .map((timeframe) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                timeframe,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedTimeframe == timeframe
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            selected: _selectedTimeframe == timeframe,
                            selectedColor: const Color(0xFFEEF2FF),
                            onSelected: (_) =>
                                setState(() => _selectedTimeframe = timeframe),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Section 3: Data Categories Checkbox List
            const Text(
              'Include Metrics in Export',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            ..._includedMetrics.keys.map((metricKey) {
              final isChecked = _includedMetrics[metricKey]!;
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: const Color(0xFF6366F1),
                title: Text(
                  metricKey,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: isChecked,
                onChanged: (val) {
                  setState(() {
                    _includedMetrics[metricKey] = val ?? false;
                  });
                },
              );
            }),
            const SizedBox(height: 20),

            // Section 4: Export Format Options (CSV, Excel, PDF)
            const Text(
              'File Format',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFormatTile('CSV', Icons.table_chart_outlined),
                const SizedBox(width: 8),
                _buildFormatTile('Excel', Icons.grid_on_rounded),
                const SizedBox(width: 8),
                _buildFormatTile('PDF', Icons.picture_as_pdf_outlined),
              ],
            ),
            const SizedBox(height: 24),

            // Section 5: Trigger Export Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isExporting ? null : _handleExport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isExporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded, size: 20),
                label: Text(
                  _isExporting
                      ? 'Generating $_selectedExportFormat File...'
                      : 'Export Data ($_selectedExportFormat)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildFormatTile(String format, IconData icon) {
    final isSelected = _selectedExportFormat == format;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedExportFormat = format),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFFCBD5E1),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF64748B),
              ),
              const SizedBox(height: 4),
              Text(
                format,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleExport() async {
    setState(() => _isExporting = true);

    // Simulate export generation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isExporting = false);
    Navigator.pop(context);

    // Confirmation Toast / Snack
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
            const SizedBox(width: 10),
            Text(
              'Analytics exported as $_selectedExportFormat successfully!',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}