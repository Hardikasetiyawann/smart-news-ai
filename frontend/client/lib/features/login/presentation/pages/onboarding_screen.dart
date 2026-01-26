import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/img/onboard.png",
      "title": "Berita terkini",
      "subtitle":
          "Tetap terhubung dengan berita terbaru dari berbagai penjuru setiap hari.",
    },
    {
      "image": "assets/img/onboard2.png",
      "title": "Personalisasi konten",
      "subtitle":
          "Pilih topik favoritmu dan nikmati pengalaman membaca yang lebih relevan.",
    },
    {
      "image": "assets/img/onboard3.png",
      "title": "In-depth context",
      "subtitle":
          "Dapatkan perspektif mendalam dari analisis berbagai sumber dunia.",
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ================= PAGE VIEW =================
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: data.length,
                onPageChanged: (i) => setState(() => currentPage = i),
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // IMAGE
                        Container(
                          height: isTablet
                              ? size.height * 0.45
                              : size.height * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: AssetImage(data[i]["image"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.05),

                        // TITLE
                        Text(
                          data[i]["title"]!,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // SUBTITLE
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 80 : 16,
                          ),
                          child: Text(
                            data[i]["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ================= INDICATOR =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                data.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentPage == index ? 22 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= BUTTONS =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Lewati"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentPage == data.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        currentPage == data.length - 1
                            ? "Mulai"
                            : "Lanjut",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
