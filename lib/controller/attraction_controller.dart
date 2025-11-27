import 'package:tcc_project/model/attraction.dart';
import 'package:tcc_project/model/attraction_dependence.dart';
import 'package:tcc_project/services/attraction_service.dart';

class AttractionController {
  final AttractionService service;

  AttractionController(this.service);

  Future<AttractionDependence> getAttractionDependence(String id) async {
    final doc = await service.getAttractionById(id);

    return AttractionDependence.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  Stream<List<Attraction>> getAttractions() {
    return service.getAttractions().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Attraction.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Stream<Set<String>> getUnlocked(String userId) {
    return service.getUnlockedAttractions(userId);
  }

  List<Attraction> filter(List<Attraction> list, String query) {
    if (query.trim().isEmpty) return list;

    query = query.toLowerCase();

    return list.where((a) => a.titulo.toLowerCase().contains(query)).toList();
  }

  double getProgress(int unlocked, int total) {
    if (total == 0) return 0;
    return unlocked / total;
  }
}
