import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planago/models/travel_model.dart';

class ItineraryDatabase 
{
  static final ItineraryDatabase instance = ItineraryDatabase._();
  ItineraryDatabase._();

  final _db = FirebaseFirestore.instance;

  Future<List<Itinerary>> getItinerary(String travelPlanId) async 
  {
    final doc = await _db.collection('Itineraries').doc(travelPlanId).get();
    if (!doc.exists) return [];
    final data = doc.data();
    if (data == null || data['itinerary'] == null) return [];
    return List<Itinerary>.from(
      (data['itinerary'] as List).map((e) => Itinerary.fromJson(e)),
    );
  }

  Future<void> setItinerary(String travelPlanId, List<Itinerary> itinerary) async 
  {
    await _db.collection('Itineraries').doc(travelPlanId).set(
    {
      'itinerary': itinerary.map((e) => e.toJson()).toList(),
    });
  }
}