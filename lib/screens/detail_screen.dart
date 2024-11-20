import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pokemon/utils/Strings.dart';
import '../controllers/pokemon_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({super.key});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final PokemonController _controller = Get.put(PokemonController());

  @override
  void initState() {
    super.initState();
    _controller.fetchPokemonCardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.purple, Colors.black]),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.purple,
        title: const Text(Strings.detail_screen_title),
      ),
      body: Obx(
        () {
          // Check if the data is loading
          if (_controller.isDetailLoading.value) {
            return const Center(
                child: SpinKitThreeInOut(
              color: Colors.purpleAccent,
              size: 30,
            ));
          }

          // Get the card value from the controller
          var card = _controller.pokemonCard.value;

          // Check if the card is null (failed to load or not available)
          if (card == null) {
            return const Center(child: Text(Strings.generic_error_msg));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                CachedNetworkImage(
                  imageUrl: card.images!.large!,
                  height: 300,
                  width: 100,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) => Container(
                    color: Colors.transparent,
                    height: 100,
                    width: 100,
                    child: const SpinKitFadingCircle(
                      color: Colors.purpleAccent,
                      size: 30,
                    ),
                  ),
                ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
                const SizedBox(height: 20),

                // Card Name and Artist
                Text(
                  card.name!,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .tint(color: Colors.white)
                    .animate()
                    .fade(duration: 500.ms)
                    .scale(delay: 500.ms),
                const SizedBox(height: 20),
                Text(Strings.artist_lbl + card.artist.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            backgroundColor: Colors.blue))
                    .animate()
                    .fade(duration: 500.ms)
                    .scale(delay: 500.ms),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                Text(Strings.rarity_lbl + card.rarity.toString(),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            backgroundColor: Colors.purpleAccent))
                    .animate()
                    .fade(duration: 500.ms)
                    .scale(delay: 500.ms),
                const SizedBox(height: 20),
                const Text(Strings.types_lbl,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))
                    .animate()
                    .fade(duration: 500.ms)
                    .scale(delay: 500.ms),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: card.types
                      .map((type) => Chip(
                          backgroundColor: Colors.purple,
                          label: Text(
                            type,
                            style: TextStyle(color: Colors.white),
                          )))
                      .toList(),
                ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
                const SizedBox(height: 20),
                const SizedBox(height: 20),

                // Attacks
                const Text(Strings.attacks_lbl,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)).animate().fade(duration: 500.ms).scale(delay: 500.ms),
                ...card.attacks.map((attack) => ListTile(
                      title: Text(
                        attack.name!,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text('${attack.damage} - ${attack.text}',
                          style: TextStyle(color: Colors.blue)),
                    )),
                const SizedBox(height: 20),

                // Weaknesses
                const Text(Strings.weekness_lbl,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
                ...card.weaknesses.map((weakness) => Chip(
                      backgroundColor: Colors.black,
                      label: Text(
                        '${weakness.type} (${weakness.value})',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),

                // Links or other information if needed
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
