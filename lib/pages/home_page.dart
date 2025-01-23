import 'package:flutter/material.dart';
import 'package:pashurakshak/main.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HeroInfo {
  final String name;
  final String description;
  final String achievement;
  final IconData icon;

  const HeroInfo({
    required this.name,
    required this.description,
    required this.achievement,
    required this.icon,
  });
}

class HomePage extends StatelessWidget {
  final String username;
  
  HomePage({super.key, required this.username});

  static const List<HeroInfo> heroes = [
    HeroInfo(
      name: 'Dr. Rajesh Kumar',
      description: 'Veterinarian',
      achievement: 'Saved 200+ street animals in last year',
      icon: Icons.medical_services,
    ),
    HeroInfo(
      name: 'Priya Singh',
      description: 'Animal Welfare Activist',
      achievement: 'Runs shelter home for 100+ animals',
      icon: Icons.home,
    ),
    HeroInfo(
      name: 'NGO Paws & Care',
      description: 'Animal Welfare Organization',
      achievement: 'Conducted 50+ rescue operations this month',
      icon: Icons.pets,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pashu Rakshak'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pets, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Help Animals in Need',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Heroes Carousel
            CarouselSlider.builder(
              itemCount: heroes.length,
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
                initialPage: 0,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              itemBuilder: (context, index, realIndex) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            heroes[index].icon,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                heroes[index].name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                heroes[index].description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                heroes[index].achievement,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Emergency Contact Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contacts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Animal Helpline'),
                      subtitle: const Text('1800-XXX-XXXX'),
                      onTap: () {
                        // Add phone call functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Recent Cases Section
            const Text(
              'Recent Cases',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(Icons.pets),
                    ),
                    title: Text('Case #${index + 1}'),
                    subtitle: const Text('Injured street dog found in sector 12'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to case details
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 