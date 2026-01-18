import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpTopic {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  HelpTopic({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });
}

class DriverHelp extends StatefulWidget {
  const DriverHelp({super.key});

  @override
  State<DriverHelp> createState() => _DriverHelpState();
}

class _DriverHelpState extends State<DriverHelp> {
  final List<HelpTopic> _topics = [
    HelpTopic(
      title: 'Getting Started',
      content: 'Learn how to start accepting rides, go online/offline, and understand the basics of the driver app.',
      icon: Icons.play_circle_outline,
      color: Colors.blue,
    ),
    HelpTopic(
      title: 'Accepting Rides',
      content: 'Tips on accepting ride requests, understanding fare estimates, and managing multiple requests.',
      icon: Icons.touch_app,
      color: Colors.green,
    ),
    HelpTopic(
      title: 'Navigation & Routes',
      content: 'How to use in-app navigation, report traffic issues, and find the best routes to destinations.',
      icon: Icons.navigation,
      color: Colors.teal,
    ),
    HelpTopic(
      title: 'Earnings & Payments',
      content: 'Understanding your earnings, payment methods, weekly payouts, and viewing earning history.',
      icon: Icons.account_balance_wallet,
      color: Colors.amber,
    ),
    HelpTopic(
      title: 'Ratings & Reviews',
      content: 'How ratings work, maintaining a high rating, and responding to rider feedback.',
      icon: Icons.star,
      color: Colors.orange,
    ),
    HelpTopic(
      title: 'Safety Guidelines',
      content: 'Safety tips for drivers, emergency contacts, and how to report safety concerns.',
      icon: Icons.security,
      color: Colors.red,
    ),
    HelpTopic(
      title: 'Vehicle Requirements',
      content: 'Vehicle inspection checklist, maintenance requirements, and document uploads.',
      icon: Icons.directions_car,
      color: Colors.purple,
    ),
    HelpTopic(
      title: 'Account Settings',
      content: 'Managing your profile, updating documents, changing preferences, and account security.',
      icon: Icons.settings,
      color: Colors.indigo,
    ),
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I get paid?',
      'answer': 'Payments are processed weekly every Monday. Your earnings are deposited directly to your registered bank account or mobile wallet.',
    },
    {
      'question': 'What if I have an accident?',
      'answer': 'Immediately ensure everyone\'s safety, call emergency services if needed, report the incident through the app, and contact our 24/7 support line.',
    },
    {
      'question': 'Can I cancel a ride after accepting?',
      'answer': 'Yes, but excessive cancellations may affect your account standing. Only cancel if absolutely necessary and inform the rider through the app.',
    },
    {
      'question': 'How do I improve my rating?',
      'answer': 'Be punctual, maintain a clean vehicle, drive safely, be courteous to riders, and follow navigation instructions accurately.',
    },
    {
      'question': 'What documents do I need?',
      'answer': 'Valid driver\'s license, vehicle registration, insurance certificate, fitness certificate, and pollution certificate.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Emergency contact card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[600]!, Colors.red[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.emergency, color: Colors.white, size: 48),
                SizedBox(height: 12),
                Text(
                  '24/7 Emergency Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Need immediate assistance?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('100'),
                  icon: Icon(Icons.phone, color: Colors.red[700]),
                  label: Text(
                    'Call Emergency: 100',
                    style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Quick actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  Icons.phone,
                  'Call Support',
                  Colors.blue,
                  () => _makePhoneCall('+977-1-4444444'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  Icons.email,
                  'Email Us',
                  Colors.green,
                  () => _sendEmail('support@laijau.com'),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  Icons.chat,
                  'Live Chat',
                  Colors.purple,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Live chat feature coming soon'),
                        backgroundColor: Colors.purple[700],
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  Icons.bug_report,
                  'Report Bug',
                  Colors.orange,
                  () => _showReportDialog(),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Help topics
          Text(
            'Help Topics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ..._topics.map((topic) => _buildTopicCard(topic)).toList(),
          SizedBox(height: 24),

          // FAQs
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ..._faqs.map((faq) => _buildFaqCard(faq)).toList(),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(HelpTopic topic) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showTopicDetail(topic),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: topic.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(topic.icon, color: topic.color, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        topic.content,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(Map<String, dynamic> faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(16),
          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.help_outline, color: Colors.green[700], size: 24),
          ),
          title: Text(
            faq['question'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          children: [
            Text(
              faq['answer'],
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicDetail(HelpTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: topic.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(topic.icon, color: topic.color, size: 32),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        topic.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    topic.content +
                        '\n\nThis is a detailed help article about ${topic.title.toLowerCase()}. '
                            'It would contain comprehensive information, step-by-step guides, screenshots, '
                            'and helpful tips to assist drivers in understanding and using this feature effectively.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.bug_report, color: Colors.orange[700]),
            SizedBox(width: 12),
            Text('Report a Bug'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Help us improve by reporting any issues you encounter.'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone dialer'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Driver Support Request',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch email client'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
