import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Alexander Bautista',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Wikipedia-logo-v2.svg/320px-Wikipedia-logo-v2.svg.png',
      phoneNumber: '8095551234',
      telegramLink: 'https://t.me/alexander_bautista'
    ),
    TeamMember(
      name: 'Malvin Peña',
      photoUrl: 'https://example.com/foto2.jpg',
      phoneNumber: '8299205572',
      telegramLink: 'https://t.me/malvin_pm'
    ),
    TeamMember(
        name: 'Nicolás Lantigua',
        photoUrl: 'https://example.com/foto2.jpg',
        phoneNumber: '8494892854',
        telegramLink: 'https://t.me/Rey_Lan06'
    ),
    TeamMember(
        name: 'Nombre Apellido #4',
        photoUrl: 'https://example.com/foto2.jpg',
        phoneNumber: '+18091112222',
        telegramLink: '#'
    ),
    TeamMember(
        name: 'Nombre Apellido #5',
        photoUrl: 'https://example.com/foto2.jpg',
        phoneNumber: '+18091112222',
        telegramLink: '#'
    ),
    TeamMember(
        name: 'Nombre Apellido #6',
        photoUrl: 'https://example.com/foto2.jpg',
        phoneNumber: '+18091112222',
        telegramLink: '#'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de'), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          final member = teamMembers[index];
          return Card(
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(member.photoUrl),
                  ),
                  SizedBox(height: 12),
                  Text(
                    member.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () async {
                          final uri = Uri.parse('tel:${member.phoneNumber}');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        tooltip: '${member.phoneNumber}',
                      ),
                      IconButton(
                        icon: Icon(Icons.messenger),
                        onPressed: () async {
                          final uri = Uri.parse('${member.telegramLink}');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        tooltip: '${member.telegramLink}',
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String photoUrl;
  final String phoneNumber;
  final String telegramLink;

  TeamMember({
    required this.name,
    required this.photoUrl,
    required this.phoneNumber,
    required this.telegramLink

  });
}
