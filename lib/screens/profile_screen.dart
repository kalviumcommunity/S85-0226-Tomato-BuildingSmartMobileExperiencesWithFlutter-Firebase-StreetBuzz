import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/section_card.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_sliver_delegate.dart';

class ProfileScreenModern extends StatelessWidget {
  const ProfileScreenModern({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Please login")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreService().listenToUserData(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData =
              snapshot.data?.data() as Map<String, dynamic>? ?? {};

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: const Color(0xFFFF6B35),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(userData['name'] ?? "User"),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: CustomSliverChildDelegate(
                    childCount: 3,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _profileInfo(userData);
                        case 1:
                          return _actions(context);
                        case 2:
                          return _logout(context);
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profileInfo(Map<String, dynamic> userData) {
    return SectionCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email: ${userData['email'] ?? 'NA'}"),
          Text("UserId: ${userData['userId'] ?? 'NA'}"),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return SectionCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: const Text("Orders"),
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          ListTile(
            title: const Text("Edit Profile"),
            onTap: () => Navigator.pushNamed(context, '/form'),
          ),
        ],
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return SectionCard(
      child: AppButton(
        text: "Logout",
        backgroundColor: Colors.red,
        onPressed: () async {
          await AuthService().logout();
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }
}