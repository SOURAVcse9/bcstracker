import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/date_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('নাম'),
              subtitle: Text(provider.userName.isEmpty ? 'সেট করা হয়নি' : provider.userName),
              trailing: const Icon(Icons.edit, size: 18),
              onTap: () => _editName(context, provider),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_outlined),
              title: const Text('পরীক্ষার তারিখ'),
              subtitle: Text(provider.examDate == null ? 'সেট করা হয়নি' : formatDate(provider.examDate)),
              trailing: const Icon(Icons.edit_calendar, size: 18),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: provider.examDate ?? DateTime.now().add(const Duration(days: 90)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) provider.setExamDate(picked);
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('সিস্টেম থিম'),
                  value: ThemeMode.system,
                  groupValue: provider.themeMode,
                  onChanged: (v) => provider.setThemeMode(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('লাইট থিম'),
                  value: ThemeMode.light,
                  groupValue: provider.themeMode,
                  onChanged: (v) => provider.setThemeMode(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('ডার্ক থিম'),
                  value: ThemeMode.dark,
                  groupValue: provider.themeMode,
                  onChanged: (v) => provider.setThemeMode(v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.red),
              title: const Text('সব অগ্রগতি রিসেট করুন', style: TextStyle(color: Colors.red)),
              onTap: () => _confirmReset(context, provider),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/icon/app_icon.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'BCSTracker',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Developed by',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'SOURAV DEBNATH',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'সম্পূর্ণ অফলাইন অ্যাপ — কোনো ইন্টারনেট বা সার্ভার লাগে না।\nসকল তথ্য শুধু আপনার ফোনেই সংরক্ষিত থাকে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editName(BuildContext context, ProgressProvider provider) {
    final controller = TextEditingController(text: provider.userName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('আপনার নাম লিখুন'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          FilledButton(
            onPressed: () {
              provider.setUserName(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('সংরক্ষণ'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, ProgressProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('নিশ্চিত করুন'),
        content: const Text('আপনার সমস্ত পড়াশোনার অগ্রগতি মুছে যাবে। এটি ফিরিয়ে আনা যাবে না। আপনি কি নিশ্চিত?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.resetAllProgress();
              Navigator.pop(context);
            },
            child: const Text('রিসেট করুন'),
          ),
        ],
      ),
    );
  }
}
