import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/athlete.dart';
import 'package:path/path.dart' as path;
import '../models/coach.dart';
class ApiService {
  static const String base = "http://192.168.1.66/gymapi";

  /// GET ATHLETES — version POST
  static Future<List<Athlete>> getAthletes() async {
    final url = Uri.parse("$base/get_athletes.php");

    final response = await http.post(url, body: {
      "action": "list"
    });

    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) return [];

      final List data = jsonDecode(body);
      return data.map((e) => Athlete.fromJson(e)).toList();
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  }
// services/api_service.dart
static Future<List<Coach>> getCoaches() async {
  final url = Uri.parse("$base/get_coaches.php");
  
  try {
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) return [];
      
      final List data = jsonDecode(body);
      return data.map((e) => Coach.fromJson(e)).toList();
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Failed to fetch coaches: $e");
  }
}
  /// ADD ATHLETE — multipart
  static Future<bool> addAthlete({
    required String firstName,
    required String lastName,
    required String gender,
    required String birthDate,
    required String phone,
    required int subscriptionId,
    required String paid,
    required int amountPaid,
    required File? imageFile,
  }) async {
    final uri = Uri.parse("$base/add_athlete.php");
    final request = http.MultipartRequest("POST", uri);

    request.fields["first_name"] = firstName;
    request.fields["last_name"] = lastName;
    request.fields["gender"] = gender;
    request.fields["birth_date"] = birthDate;
    request.fields["phone"] = phone;
    request.fields["subscription_id"] = subscriptionId.toString();
    request.fields["paid"] = paid;
    request.fields["amount_paid"] = amountPaid.toString();

    request.fields["start_date"] =
        DateTime.now().toIso8601String().split('T').first;

    if (imageFile != null) {
      final fileName = path.basename(imageFile.path);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: fileName,
      ));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }
}
