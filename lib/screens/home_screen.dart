import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pokemon/controllers/pokemon_controller.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/utils/Strings.dart';
import 'detail_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/animation.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pokemonCardController = Get.put(PokemonController());
  bool _isSearching = false;
  bool _loadData = true;

  @override
  void initState() {
    super.initState();
    _pokemonCardController.fetchPokemonCards(); // Initial fetch of pokemon data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Obx(() => Visibility(
          visible: _pokemonCardController.errorMessage.isNotEmpty,
          child: FloatingActionButton(
            onPressed: () {
              _pokemonCardController.fetchPokemonCards();
            },
            child: const Icon(Icons.refresh),
          ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black, Colors.purple]),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.blue,
        title: _isSearching
            ? TextField(
                controller: _pokemonCardController.searchController,
                decoration: const InputDecoration(
                  hintText: Strings.search_hint,
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                autofocus: true,
                onChanged: (query) {
                  _pokemonCardController
                      .searchCards(query); // Search when typing
                },
              )
            : const Text(Strings.home_title),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _pokemonCardController.searchController.clear();
                  _pokemonCardController.searchCards(''); // Reset search
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_pokemonCardController.errorMessage.value.isNotEmpty) {
          return const Center(child: Text(Strings.generic_error_msg,style: TextStyle(color: Colors.white),));
        }
        if (_loadData) {
          _loadData = false;
          return const Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SpinKitThreeInOut(
                  color: Colors.purpleAccent,
                  size: 30,
                ),
                Text(Strings.please_wait_msg,style: TextStyle(color: Colors.white))
              ]));
        }

        // Main content (GridView)
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
              // When scrolled to the bottom, load more cards
              _pokemonCardController.fetchPokemonCards();
            }
            return true;
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns for the grid
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _pokemonCardController.filteredCards.length +
                (_pokemonCardController.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _pokemonCardController.filteredCards.length &&
                  _pokemonCardController.isLoading.value) {
                return const Center();
              }

              PokemonCard card = _pokemonCardController.filteredCards[index];

              return GestureDetector(
                onTap: () {
                  _pokemonCardController.pokemonId.value = card.id;
                  Get.to(() =>
                      const PokemonDetailScreen()); // Navigate to the details screen
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(colors: [
                            Colors.black,
                            Colors.black,
                            Colors.purple,
                          ])),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,

                        children:
              AnimateList(
              interval: 400.ms,
              effects: [MoveEffect(duration: 700.ms)],
                      children:   [

                          CachedNetworkImage(
                            imageUrl: card.images.small!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            placeholder: (context, url) => Container(
                              color: Colors.transparent,
                              height: 100,
                              width: 100,
                              child: const SpinKitFadingCircle(
                                color: Colors.purpleAccent,
                                size: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              card.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ));
            },
          ),
        );
      }),
    );
  }
}
