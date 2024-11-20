import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/utils/ApiConstants.dart';
import 'dart:convert';

import '../models/pokemon_model.dart';

class PokemonController extends GetxController {
  var isLoading = false.obs;
  var page = 1.obs;
  var currentPage = 1.obs;
  final int pageSize = 10;
  TextEditingController searchController = TextEditingController();
  RxList<PokemonCard> cards =
      <PokemonCard>[].obs; // List to store fetched cards
  RxList<PokemonCard> filteredCards = <PokemonCard>[].obs; // Filtered list
  var pokemonCard =
      Rx<PokemonDetailsModel?>(null); // To store the fetched Pokémon card
  var errorMessage = ''.obs; // To store any error message
  final Rx<String> pokemonId = "".obs;
  var isDetailLoading = false.obs;

  // Fetch the Pokémon card details based on the query parameter (id)
  Future<void> fetchPokemonCardDetails() async {
    // Reset the error message and loading state before starting the fetch
    errorMessage.value = '';
    isDetailLoading(true);

    try {
      final parseableUrl = "${ApiConstants.baseUrl}cards?q=id:$pokemonId";
      final response = await http.get(
        Uri.parse(parseableUrl),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if data is not empty and contains the expected structure
        if (data['data'].isNotEmpty) {
          // Parse the first card from the response
          pokemonCard.value = PokemonDetailsModel.fromJson(data['data'][0]);
        } else {
          // Handle empty data or no card found scenario
          errorMessage.value = 'No Pokemon found with this ID.';
        }
      } else {
        // Handle non-200 status code response
        errorMessage.value =
            'Failed to load card details. Please try again later.';
      }
    } catch (e) {
      // Handle exceptions, such as no internet connection
      errorMessage.value = 'Error occurred: $e';
    } finally {
      // Update loading state once the request is complete
      isDetailLoading(false);
    }
  }

  Future<void> fetchPokemonCards() async {
    if (isLoading.value) return; // Prevent multiple simultaneous requests
    isLoading.value = true;
    final url = ApiConstants.baseUrl +
        "cards?page=${currentPage.value}&pageSize=$pageSize";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage.value = '';
        final data = json.decode(response.body);

        final newCards = List<PokemonCard>.from(
          data['data'].map((card) => PokemonCard.fromJson(card)),
        );

        cards.addAll(newCards); // Add the new cards to the list
        filteredCards.addAll(newCards);

        currentPage.value++; // Increment page for next fetch
      } else {
        errorMessage.value =
            'Failed to load card details. Please try again later.';
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      errorMessage.value = 'Error occurred: $e';
      print('Error fetching cards: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  void searchCards(String query) {
    if (query.isEmpty) {
      filteredCards.value =
          List.from(cards); // If search is empty, show all cards
    } else {
      filteredCards.value = cards.where((card) {
        return card.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
