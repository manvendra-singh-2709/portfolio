import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:portfolio/globals/globals.dart';

class GameApiCaller {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<void> loadOrCreateUser(String email) async {
    final List<dynamic> rows = await _client
        .from('Pixel_Adventure')
        .select('id, email, game_data')
        .eq('email', email)
        .limit(1);

    if (rows.isEmpty) {
      await _client.from('Pixel_Adventure').insert(<String, dynamic>{
        'email': email,
        'game_data': <String, String>{},
      });

      Global.email = email;
      Global.levelData = <String, String>{};
      return;
    }

    final Map<String, dynamic> row = rows.first as Map<String, dynamic>;

    final Map<String, dynamic> rawData = (row['game_data'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    Global.email = email;
    Global.levelData = rawData.map(
      (String key, dynamic value) => MapEntry<String, String>(key, value.toString()),
    );
  }

  static Future<void> updateLevelTime({required String level, required String time}) async {
    final String? email = Global.email;

    if (email == null) return;

    Global.levelData[level] = time;

    await _client
        .from('Pixel_Adventure')
        .update(<String, dynamic>{'game_data': Global.levelData})
        .eq('email', email);
  }
}
