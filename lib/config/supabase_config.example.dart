class SupabaseConfig {
  static const String supabaseUrl = 'VOTRE_URL_SUPABASE';
  static const String supabaseAnonKey = 'VOTRE_CLE_ANONYME';

  static bool get isValid =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty;
}
