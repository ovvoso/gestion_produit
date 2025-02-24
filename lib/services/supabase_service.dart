import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProduits() async {
    try {
      final response = await supabase
          .from('produits')
          .select();  // Suppression du order by created_at
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erreur dans getProduits: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> ajouterProduit(Map<String, dynamic> produit) async {
    try {
      final response = await supabase
          .from('produits')
          .insert(produit)
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('Erreur dans ajouterProduit: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> updateProduit(int id, Map<String, dynamic> produit) async {
    try {
      final response = await supabase
          .from('produits')
          .update(produit)
          .eq('id', id)
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('Erreur dans updateProduit: $e');
      throw e;
    }
  }

  Future<void> deleteProduit(int id) async {
    try {
      await supabase
          .from('produits')
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Erreur dans deleteProduit: $e');
      throw e;
    }
  }
}
