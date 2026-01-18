import 'package:flutter/material.dart';

class Review {
  final String riderName;
  final double rating;
  final String comment;
  final DateTime date;
  final String tripRoute;

  Review({
    required this.riderName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.tripRoute,
  });
}

class DriverRatings extends StatefulWidget {
  const DriverRatings({super.key});

  @override
  State<DriverRatings> createState() => _DriverRatingsState();
}

class _DriverRatingsState extends State<DriverRatings> {
  final double _overallRating = 4.8;
  final int _totalReviews = 347;
  final Map<int, int> _ratingDistribution = {
    5: 245,
    4: 78,
    3: 18,
    2: 4,
    1: 2,
  };

  final List<Review> _reviews = [
    Review(
      riderName: 'Sita Sharma',
      rating: 5.0,
      comment: 'Excellent driver! Very polite and professional. The car was clean and comfortable. Highly recommended!',
      date: DateTime.now().subtract(Duration(hours: 5)),
      tripRoute: 'Thamel → Airport',
    ),
    Review(
      riderName: 'Ram Prasad',
      rating: 5.0,
      comment: 'Safe driving and arrived on time. Thank you!',
      date: DateTime.now().subtract(Duration(days: 1)),
      tripRoute: 'Patan → Bhaktapur',
    ),
    Review(
      riderName: 'Maya Gurung',
      rating: 4.0,
      comment: 'Good service overall. Driver was friendly but the route taken was a bit longer than expected.',
      date: DateTime.now().subtract(Duration(days: 2)),
      tripRoute: 'Kathmandu Mall → Hotel',
    ),
    Review(
      riderName: 'Bikash Thapa',
      rating: 5.0,
      comment: 'Perfect ride! Clean car, smooth driving, and great conversation. Will request again.',
      date: DateTime.now().subtract(Duration(days: 3)),
      tripRoute: 'Office → Home',
    ),
    Review(
      riderName: 'Anita Rai',
      rating: 5.0,
      comment: 'Very professional and courteous driver. Felt safe throughout the journey.',
      date: DateTime.now().subtract(Duration(days: 4)),
      tripRoute: 'Hospital → Residence',
    ),
    Review(
      riderName: 'Suresh Karki',
      rating: 4.0,
      comment: 'Good driver, but could improve on communication. Otherwise great experience.',
      date: DateTime.now().subtract(Duration(days: 5)),
      tripRoute: 'Airport → Hotel',
    ),
    Review(
      riderName: 'Kritika Shrestha',
      rating: 5.0,
      comment: 'Excellent! Driver helped with my luggage and was very patient with directions.',
      date: DateTime.now().subtract(Duration(days: 7)),
      tripRoute: 'Station → Home',
    ),
    Review(
      riderName: 'Prakash Magar',
      rating: 3.0,
      comment: 'Average experience. Driver was okay but seemed distracted during the ride.',
      date: DateTime.now().subtract(Duration(days: 9)),
      tripRoute: 'City Center → Suburb',
    ),
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
          'Ratings & Reviews',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Overall rating card
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[600]!, Colors.amber[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _overallRating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < _overallRating.floor()
                                  ? Icons.star
                                  : (index < _overallRating ? Icons.star_half : Icons.star_border),
                              color: Colors.white,
                              size: 24,
                            );
                          }),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '$_totalReviews reviews',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                ..._ratingDistribution.entries.map((entry) {
                  final stars = entry.key;
                  final count = entry.value;
                  final percentage = (count / _totalReviews) * 100;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '$stars',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.white, size: 16),
                        SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 35,
                          child: Text(
                            '$count',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.thumb_up,
                  '${((_ratingDistribution[5]! + _ratingDistribution[4]!) / _totalReviews * 100).toStringAsFixed(0)}%',
                  'Positive',
                  Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.trending_up,
                  '+12',
                  'This Week',
                  Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Reviews section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Filter reviews
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filter feature coming soon'),
                      backgroundColor: Colors.green[700],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: Icon(Icons.filter_list, size: 18),
                label: Text('Filter'),
                style: TextButton.styleFrom(foregroundColor: Colors.green[700]),
              ),
            ],
          ),
          SizedBox(height: 12),
          ..._reviews.map((review) => _buildReviewCard(review)).toList(),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
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
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[700]!],
                  ),
                ),
                child: Center(
                  child: Text(
                    review.riderName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.riderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : (index < review.rating ? Icons.star_half : Icons.star_border),
                            color: Colors.amber[700],
                            size: 16,
                          );
                        }),
                        SizedBox(width: 8),
                        Text(
                          _formatTimeAgo(review.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.route, size: 14, color: Colors.grey[700]),
                SizedBox(width: 6),
                Text(
                  review.tripRoute,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.thumb_up_outlined, size: 16),
                label: Text('Helpful'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
              SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.reply, size: 16),
                label: Text('Reply'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} min ago';
    }
  }
}
