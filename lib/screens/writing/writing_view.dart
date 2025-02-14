import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/services/firebase_service.dart';
import 'package:skriftes_project_2/services/models/user.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'writing_letter.dart';

class WritingView extends StatefulWidget {
  const WritingView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  static const routeName = '/';

  @override
  State<WritingView> createState() => _WritingViewState();
}

class _WritingViewState extends State<WritingView> {
  int step = 0;
  late Future<UserData> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = FirebaseService().getMyUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRepository.getColor(
          ColorName.primaryColor, widget.controller.themeMode),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<UserData>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorRepository.getColor(
                  ColorName.specialColor, widget.controller.themeMode),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final userData = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  "¿A quién quieres enviar tu carta?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: ColorRepository.getColor(
                        ColorName.textColor, widget.controller.themeMode),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.builder(
                    itemCount: userData.friends.length,
                    itemBuilder: (context, index) {
                      final friendId = userData.friends[index];
                      return FutureBuilder<UserData>(
                        future: FirebaseService().getUserData(friendId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: ColorRepository.getColor(
                                  ColorName.specialColor,
                                  widget.controller.themeMode),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final friendData = snapshot.data!;
                            return FriendTile(
                              friend: Friend(
                                name: friendData.username,
                                imageUrl: 'assets/${friendData.username}.jpg',
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WritingLetterView(
                                          controller: widget.controller,
                                          title: 'Escribiendo carta',
                                          recipientData: friendData,
                                        )));
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          );
        }
      },
    );
  }
}

class Friend {
  final String name;
  final String imageUrl;

  Friend({required this.name, required this.imageUrl});
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  const FriendTile({
    super.key,
    required this.friend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(friend.imageUrl),
              radius: 30,
            ),
            const SizedBox(width: 10),
            Text(
              friend.name,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
