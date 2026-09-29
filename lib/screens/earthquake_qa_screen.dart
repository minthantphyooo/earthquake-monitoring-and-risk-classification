import 'package:flutter/material.dart';

class EarthquakeQAScreen extends StatefulWidget {
  const EarthquakeQAScreen({super.key});

  @override
  State<EarthquakeQAScreen> createState() => _EarthquakeQAScreenState();
}

class _EarthquakeQAScreenState extends State<EarthquakeQAScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedQuestionIndex;

  // Q&A Data
  final List<Map<String, dynamic>> _qaData = [
    {
      'question': 'What causes earthquakes?',
      'answer': 'Earthquakes are caused by the sudden release of energy in the Earth\'s crust, usually due to the movement of tectonic plates. When stress builds up along fault lines and is released, it creates seismic waves that we feel as earthquakes.',
      'category': 'General',
    },
    {
      'question': 'How are earthquakes measured?',
      'answer': 'Earthquakes are measured using the Richter scale (magnitude) and the Modified Mercalli Intensity scale (intensity). The Richter scale measures the energy released, while the Mercalli scale measures the effects on people and structures.',
      'category': 'Measurement',
    },
    {
      'question': 'What should I do during an earthquake?',
      'answer': 'Drop, Cover, and Hold On! Drop to your hands and knees, cover your head and neck with your arms, and hold on to something sturdy. Stay indoors if you\'re inside, and move to an open area if you\'re outside. Stay away from windows, heavy furniture, and objects that could fall.',
      'category': 'Safety',
    },
    {
      'question': 'What\'s the difference between magnitude and intensity?',
      'answer': 'Magnitude measures the energy released at the earthquake\'s source (like the Richter scale). Intensity measures the effects of the earthquake at a specific location (like the Mercalli scale). One earthquake can have different intensities in different places.',
      'category': 'Measurement',
    },
    {
      'question': 'Can earthquakes be predicted?',
      'answer': 'Currently, scientists cannot predict exactly when and where an earthquake will occur. However, they can identify areas at higher risk and estimate the probability of earthquakes occurring over longer time periods.',
      'category': 'Prediction',
    },
    {
      'question': 'What are aftershocks?',
      'answer': 'Aftershocks are smaller earthquakes that occur in the same area after a larger earthquake. They can continue for days, weeks, or even months. While usually smaller than the main earthquake, they can still cause damage to already weakened structures.',
      'category': 'General',
    },
    {
      'question': 'How do I prepare for an earthquake?',
      'answer': 'Create an emergency kit with food, water, first aid supplies, and important documents. Secure heavy furniture and objects. Know your evacuation routes. Have a family emergency plan. Keep emergency contact numbers handy.',
      'category': 'Safety',
    },
    {
      'question': 'What\'s the "Ring of Fire"?',
      'answer': 'The Ring of Fire is a region around the Pacific Ocean where many earthquakes and volcanic eruptions occur. It\'s shaped like a horseshoe and contains about 75% of Earth\'s volcanoes and 90% of its earthquakes.',
      'category': 'Geography',
    },
    {
      'question': 'How long do earthquakes last?',
      'answer': 'Most earthquakes last only a few seconds to a few minutes. However, the duration depends on the magnitude and distance from the epicenter. Larger earthquakes can last longer and may be followed by numerous aftershocks.',
      'category': 'General',
    },
    {
      'question': 'What should I do after an earthquake?',
      'answer': 'Check yourself and others for injuries. Turn off gas, electricity, and water if you smell gas or see damage. Listen to emergency broadcasts. Be prepared for aftershocks. Help neighbors if safe to do so.',
      'category': 'Safety',
    },
    {
      'question': 'Can animals predict earthquakes?',
      'answer': 'There\'s no scientific evidence that animals can reliably predict earthquakes. While some animals may behave unusually before earthquakes, this could be due to other factors and isn\'t a reliable warning system.',
      'category': 'Prediction',
    },
    {
      'question': 'What\'s liquefaction?',
      'answer': 'Liquefaction occurs when loose, water-saturated soil temporarily loses strength during an earthquake. The ground can behave like a liquid, causing buildings to sink or tilt. It\'s common in areas with loose soil near water.',
      'category': 'Science',
    },
  ];

  List<Map<String, dynamic>> get _filteredQA {
    if (_searchQuery.isEmpty) {
      return _qaData;
    }
    return _qaData.where((qa) {
      return qa['question'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             qa['answer'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             qa['category'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Q&A'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _filteredQA.isEmpty
                ? _buildNoResults()
                : _buildQAList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search earthquake questions...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _selectedQuestionIndex = null;
          });
        },
      ),
    );
  }

  Widget _buildQAList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _filteredQA.length,
      itemBuilder: (context, index) {
        final qa = _filteredQA[index];
        final isExpanded = _selectedQuestionIndex == index;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _selectedQuestionIndex = expanded ? index : null;
              });
            },
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(qa['category']),
              child: Icon(
                _getCategoryIcon(qa['category']),
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              qa['question'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              qa['category'],
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      qa['answer'],
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Category: ${qa['category']}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
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
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No questions found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'safety':
        return Colors.red.shade600;
      case 'measurement':
        return Colors.blue.shade600;
      case 'prediction':
        return Colors.orange.shade600;
      case 'geography':
        return Colors.green.shade600;
      case 'science':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'safety':
        return Icons.security;
      case 'measurement':
        return Icons.science;
      case 'prediction':
        return Icons.psychology;
      case 'geography':
        return Icons.public;
      case 'science':
        return Icons.school;
      default:
        return Icons.help_outline;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 