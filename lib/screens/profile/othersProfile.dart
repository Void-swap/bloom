import 'package:bloom/model/user.dart'; // Import your UserModel
import 'package:bloom/services/services.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For caching images
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart'; // For loading placeholders

class OthersProfileView extends StatelessWidget {
  final UserService _userService = UserService();
  final String userId; // The UID you want to fetch data for

  OthersProfileView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userService.getUserInfo(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user info'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('User not found'));
        }

        final userData = snapshot.data!;
        UserModel userModel =
            UserModel.fromMap(userData); // Convert the data to UserModel

        return Scaffold(
          appBar: AppBar(
            title: Text('User Profile'),
            actions: [
              IconButton(
                icon: const Icon(IconlyBroken.notification),
                onPressed: () {
                  // Handle notifications
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture and Basic Info
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle profile picture tap
                          },
                          child: Hero(
                            tag: "ProfilePic",
                            child: CachedNetworkImage(
                              imageUrl: userModel.profilePic.isEmpty
                                  ? 'placeholder_url' // Use a placeholder
                                  : userModel.profilePic,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 50,
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[500]!,
                                highlightColor: Colors.grey[100]!,
                                child: const CircleAvatar(
                                    radius: 50, backgroundColor: Colors.grey),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hey, ${userModel.name}',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w800)),
                            Text(userModel.role,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("A Peek Into Who I Am!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(userModel.description.isNotEmpty
                        ? userModel.description
                        : 'How would you like to describe yourself'),
                    const SizedBox(height: 20),
                    Text("I'm passionate about",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(userModel.interests.isNotEmpty
                        ? 'You have ${userModel.interests.length} interests!'
                        : 'Explore new interests to connect with others.'),
                    const SizedBox(height: 20),
                    Text("Events that shaped me",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Expanded(child: SizedBox()
                        // MyEventsHorizontal()
                        ), // Include your event widget
                    const SizedBox(height: 20),
                    Text("My Badges",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(userModel.badges.isNotEmpty
                        ? 'You’ve earned ${userModel.badges.length} badges for your achievements!'
                        : 'Participate in events to earn badges and showcase your skills!'),
                    const SizedBox(height: 20),
                    Text("I’m Just a Message Away!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text("Email: ${userModel.email}"),
                    const SizedBox(height: 20),
                    Text("Find me on socials",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(
                        'Lets connect at: ${userModel.socialMediaLinks.length}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
