import 'package:flutter/material.dart';
import 'package:pashurakshak/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

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

class HomePage extends StatefulWidget {
  final String username;
  
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _reporterNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _landmarkController = TextEditingController();
  String _selectedAnimalType = 'Dog'; // Default value
  
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

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    
    if (photo != null && mounted) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(File(photo.path)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showReportForm(photo);
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showReportForm(XFile photo) async {
    // Get current location
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
    } catch (e) {
      position = Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Details'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _reporterNameController,
                    decoration: const InputDecoration(labelText: 'Your Name *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: const InputDecoration(labelText: 'Contact Number *'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter contact number';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedAnimalType,
                    decoration: const InputDecoration(labelText: 'Animal Type *'),
                    items: ['Dog', 'Cat', 'Cow', 'Bird', 'Other']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAnimalType = value!;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _landmarkController,
                    decoration: const InputDecoration(labelText: 'Landmark *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a landmark';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Location: ${position.latitude}, ${position.longitude}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Report Time: ${DateTime.now().toString()}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Submit the report
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report submitted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pashu Rakshak'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Heroes Carousel at top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      viewportFraction: 0.9,
                    ),
                    items: heroes.map((hero) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                    child: Icon(
                                      hero.icon,
                                      size: 35,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          hero.name,
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          hero.description,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: Colors.grey[600],
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
                      );
                    }).toList(),
                  ),
                ),
                
                // Spacer to push content to center
                const SizedBox(height: 80),
                
                // Centered Report Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: _takePicture,
                            icon: const Icon(Icons.camera_alt, size: 28),
                            label: const Text(
                              'Report Animal in Need',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take a photo to report',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom spacing
                const SizedBox(height: 80),
              ],
            ),
          ),
          
          // Emergency Call Button
          Positioned(
            left: 16,
            bottom: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () async {
                  final Uri phoneUri = Uri.parse('tel:139');
                  try {
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not launch emergency dialer'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error launching emergency dialer'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reporterNameController.dispose();
    _contactNumberController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }
} 