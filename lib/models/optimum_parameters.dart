import 'package:cloud_firestore/cloud_firestore.dart';

class OptimumParameter {
  final String parameterName;
  final double optimumMin;
  final double optimumMax;

  OptimumParameter({
    required this.parameterName,
    required this.optimumMin,
    required this.optimumMax,
  });

  factory OptimumParameter.fromFirestore(DocumentSnapshot doc) {
    return OptimumParameter(
      parameterName: doc.id,
      optimumMin: double.tryParse(doc['optimumMin'].toString()) ?? 0.0,
      optimumMax: double.tryParse(doc['optimumMax'].toString()) ?? 0.0,
    );
  }
}

Future<List<OptimumParameter>> fetchOptimumParameters(String? species) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('species')
        .doc(species)
        .collection('water_parameters')
        .get();

    return querySnapshot.docs
        .map((doc) => OptimumParameter.fromFirestore(doc))
        .toList();
  } catch (e) {
    print('Error fetching optimum parameters: $e');
    return [];
  }
}
