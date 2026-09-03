import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/subject_card.dart';
import '../widgets/progress_ring.dart';
import 'subject_screen.dart';

const _quotes = [
  'প্রতিদিনের ছোট প্রচেষ্টাই বড় সাফল্যের ভিত্তি।',
  'ধারাবাহিকতাই বিসিএস প্রস্তুতির আসল চাবিকাঠি।',
  'আজকের এক ঘণ্টা পড়া, আগামীকালের এক ধাপ এগিয়ে যাওয়া।',
  'রিভিশন ছাড়া প্রস্তুতি অসম্পূর্ণ — নিয়মিত রিভিশন করুন।',
  'নিজের সাথে প্রতিযোগিতা করুন, গতকালের চেয়ে আজ ভালো করুন।',
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    final quote = _quotes[DateTime.now().day % _quotes.length];
    final daysLeft = provider.daysUntilExam;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(provider.userName.isEmpty ? 'BCS Prep Tracker' : 'হ্যালো, ${provider.userName} 👋'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top summary card
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        ProgressRing(
                          progress: provider.overallProgress,
                          size: 100,
                          centerText: '${(provider.overallProgress * 100).round()}%',
                          subText: 'সম্পন্ন',
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${provider.completedTopics}/${provider.totalTopics} টপিক শেষ',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text('আনুমানিক নম্বর: ${provider.earnedMarks} / ${provider.totalMarks}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.local_fire_department, size: 18, color: Colors.deepOrange),
                                  const SizedBox(width: 4),
                                  Text('${provider.studyStreak} দিনের স্ট্রিক',
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (daysLeft != null)
                  Card(
                    color: daysLeft >= 0
                        ? Theme.of(context).colorScheme.tertiaryContainer
                        : Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.event_available),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              daysLeft >= 0
                                  ? 'পরীক্ষার আর মাত্র $daysLeft দিন বাকি!'
                                  : 'পরীক্ষার তারিখ পার হয়ে গেছে',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (daysLeft != null) const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(quote, style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('বিষয়সমূহ', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount: provider.subjects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final subject = provider.subjects[index];
              return SubjectCard(
                subject: subject,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SubjectScreen(subjectId: subject.id)),
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
